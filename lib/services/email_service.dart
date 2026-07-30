import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static const String _serviceId = 'service_z0kqa9z';
  static const String _mainTemplateId = 'template_vam3odn';
  static const String _autoReplyTemplateId = 'template_veaibja';
  static const String _userId = 'wzRi4ZoPsBZAMnIXn'; // Public Key
  
  static const String _url = 'https://api.emailjs.com/api/v1.0/email/send';

  /// Sends both the main contact email and an auto-reply.
  /// Throws an exception if either fails.
  static Future<void> sendContactEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    // 1. Send Main Email to Rudra
    final mainParams = {
      'service_id': _serviceId,
      'template_id': _mainTemplateId,
      'user_id': _userId,
      'template_params': {
        'to_email': 'rpsinghiiitr@gmail.com',
        'to_name': 'Rudra Pratap Singh',
        'from_name': name,
        'from_email': email,
        'subject': subject,
        'message': message,
        'reply_to': email,
      },
    };

    final mainRes = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(mainParams),
    );

    if (mainRes.statusCode != 200) {
      throw Exception('Failed to send message.');
    }

    // 2. Send Auto-Reply to the user
    final autoReplyParams = {
      'service_id': _serviceId,
      'template_id': _autoReplyTemplateId,
      'user_id': _userId,
      'template_params': {
        'to_email': email,
        'to_name': name,
        'from_name': 'Rudra Pratap Singh',
        'from_email': 'rpsinghiiitr@gmail.com',
        'subject': 'Re: $subject',
        'message': 'Thank you for reaching out, $name!\n\nI\'ve received your message and will get back to you as soon as possible.\n\nBest regards,\nRudra Pratap Singh',
      },
    };

    final autoRes = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(autoReplyParams),
    );

    if (autoRes.statusCode != 200) {
      // We don't necessarily throw here if just the auto-reply fails, 
      // but we can log it. The main message was sent.
      print('Warning: Failed to send auto-reply.');
    }
  }
}
