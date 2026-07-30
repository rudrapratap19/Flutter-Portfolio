import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';

void main() async {
  const apiKey = 'AIzaSyDbzTvaa74gb_X2VUEo7jJ-qwWUwfGKETA';
  final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);
  final chat = model.startChat();
  
  try {
    print('Sending message...');
    final response = await chat.sendMessage(Content.text('who is amitabh?'));
    print('Response: ${response.text}');
  } catch (e) {
    print('Error: $e');
  }
}
