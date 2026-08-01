import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../theme/theme_notifier.dart';

class TerminalOutputLine {
  final String text;
  final String type; // 'input', 'system', 'success', 'error', 'accent', 'warning'

  TerminalOutputLine(this.text, {this.type = 'system'});
}

class TerminalEngine {
  static const String currentDir = r'C:\Users\Rudra';

  static const String welcomeBanner = '''
Microsoft Windows [Version 10.0.22631.3296]
(c) Microsoft Corporation. All rights reserved.

    ____  __  ____  ____  ___ _ 
   / __ \\/ / / / __ \\/ __ \\/   | |
  / /_/ / / / / / / / /_/ / /| | |
 / _, _/ /_/ / /_/ / _, _/ ___ | |
/_/ |_|\\____/_____/_/ |_/_/  |_|_|  Portfolio OS v2.0
                                    
Type 'help' or 'neofetch' to view available commands.
''';

  static const List<String> availableCommands = [
    'help',
    'neofetch',
    'systeminfo',
    'bio',
    'about',
    'skills',
    'projects',
    'exp',
    'stats',
    'certs',
    'roadmap',
    'achievements',
    'github',
    'leetcode',
    'contact',
    'open',
    'weather',
    'whoami',
    'tree',
    'dir',
    'ls',
    'cat',
    'ping',
    'matrix',
    'clear',
    'cls',
    'date',
    'time',
    'sudo',
    'theme',
  ];

  static final Map<String, String> _pseudoFiles = {
    'about.txt': '''
NAME: Rudra Pratap Singh
DEGREE: B.Tech in Artificial Intelligence & Data Science (2023 - 2027)
COLLEGE: Indian Institute of Information Technology (IIIT) Raichur
LOCATION: India
EMAIL: rpsinghiiitr@gmail.com
SUMMARY: Flutter developer & AI student building production-ready mobile apps, backend services, and algorithmic solutions.
''',
    'skills.json': '''
{
  "mobile": ["Flutter", "Dart", "REST APIs", "Firebase", "State Management"],
  "backend": ["Python", "Node.js", "C++", "PostgreSQL", "Git"],
  "ai_ds": ["Machine Learning", "PyTorch", "Data Science", "DSA 474+ Solved"]
}
''',
    'resume.txt': '''
------------------------------------------------------------------
RUDRA PRATAP SINGH | B.Tech AI & DS @ IIIT Raichur
------------------------------------------------------------------
[EXPERIENCE]
- Junior Flutter Developer @ Webintegratorz Technologies (May 2026 - Present)
- Flutter Developer Intern @ Syflex Techno Solution (Mar 2026 - May 2026)

[ACHIEVEMENTS & CREDENTIALS]
- 🏆 District Topper (10th Board Exam)
- 🥇 Naukri Campus Young Turks 2025 (99.40 Percentile Merit)
- 🎓 GATE CS 2026 Qualified
- 📜 Flutter & Dart - The Complete Guide (Udemy)
- 👑 Academic Affairs Secretary (CoSA IIIT Raichur 2024-2025)
- 💻 LeetCode Top 5000 Rank (1450+ Rating) & 474+ DSA Solved
- 📜 Learn C++ Programming - Deep Dive (Udemy)
- 💼 Placement Cell Coordinator @ IIIT Raichur (2026)
- 🚀 Adobe India Hackathon 2025 (Round 1 Qualifier)
- 🚀 L'Oréal Sustainability Challenge 2025 (Aptitude Qualifier)
------------------------------------------------------------------
''',
    'contact.info': '''
Email: rpsinghiiitr@gmail.com
GitHub: https://github.com/rudrapratap19
LeetCode: https://leetcode.com/u/rpsinghiiitr/
LinkedIn: https://www.linkedin.com/in/rudra-pratap-singh-677149314
''',
  };

  /// Processes user command input string
  static Future<List<TerminalOutputLine>> executeCommand(String inputLine) async {
    final trimmed = inputLine.trim();
    if (trimmed.isEmpty) return [];

    final parts = trimmed.split(RegExp(r'\s+'));
    final cmd = parts[0].toLowerCase();
    final args = parts.sublist(1);

    switch (cmd) {
      case 'help':
        return [
          TerminalOutputLine('AVAILABLE COMMANDS:', type: 'accent'),
          TerminalOutputLine('  neofetch          - Show system hardware & profile summary'),
          TerminalOutputLine('  systeminfo        - Display Windows system configuration'),
          TerminalOutputLine('  bio / about       - Print educational background & bio'),
          TerminalOutputLine('  skills            - Display tech stack matrix'),
          TerminalOutputLine('  projects          - List top featured projects'),
          TerminalOutputLine('  exp               - Print career experience & leadership timeline'),
          TerminalOutputLine('  stats             - Query live LeetCode, GFG & GitHub stats'),
          TerminalOutputLine('  certs / roadmap   - Display all 11 achievements & certifications'),
          TerminalOutputLine('  open <target>     - Open github | linkedin | resume in browser'),
          TerminalOutputLine('  weather           - Show live weather for Raichur, India 🌦'),
          TerminalOutputLine('  whoami            - Display ASCII identity card'),
          TerminalOutputLine('  contact <message> - Send a mock message (e.g. contact hello)'),
          TerminalOutputLine('  tree              - Render portfolio directory structure'),
          TerminalOutputLine('  dir / ls          - List pseudo files in directory'),
          TerminalOutputLine('  cat <file>        - Output contents of a file (e.g. cat resume.txt)'),
          TerminalOutputLine('  ping <host>       - Test latency (e.g. ping leetcode.com)'),
          TerminalOutputLine('  matrix            - Toggle green Matrix Digital Rain mode'),
          TerminalOutputLine('  date / time       - Show current date & system uptime'),
          TerminalOutputLine('  theme <mode>      - Switch theme: theme dark | theme light | theme cmd'),
          TerminalOutputLine('  cls / clear       - Clear output buffer'),
        ];

      case 'neofetch':
      case 'systeminfo':
        return [
          TerminalOutputLine('r@RUDRA-IIITR-WORKSTATION', type: 'accent'),
          TerminalOutputLine('-----------------------'),
          TerminalOutputLine('OS: Windows 11 Pro x64 (Build 22631)'),
          TerminalOutputLine('Host: IIIT Raichur AI & DS Workstation'),
          TerminalOutputLine('Uptime: 247 days, 14 hours'),
          TerminalOutputLine('Shell: PowerShell / CMD v2.0'),
          TerminalOutputLine('Framework: Flutter 3.x (Dart 3.x)'),
          TerminalOutputLine('Developer: Rudra Pratap Singh (B.Tech 2023-2027)'),
          TerminalOutputLine('LeetCode Rating: 1450+ (Top 5000 Rank)'),
          TerminalOutputLine('DSA Solved: 474+ Problems (224 LC + 250 GFG)'),
          TerminalOutputLine('GATE CS 2026: Qualified'),
          TerminalOutputLine('GitHub Repos: 22 Public Repositories'),
        ];

      case 'bio':
      case 'about':
        return [
          TerminalOutputLine('ABOUT RUDRA PRATAP SINGH:', type: 'accent'),
          TerminalOutputLine('Degree: B.Tech in AI & Data Science (2023 - 2027)'),
          TerminalOutputLine('Institute: Indian Institute of Information Technology (IIIT) Raichur'),
          TerminalOutputLine('Bio: Passionate about Flutter mobile engineering, REST APIs, machine learning, and algorithmic problem solving.'),
          TerminalOutputLine('Leadership: Academic Secretary & Placement Coordinator at IIIT Raichur.'),
        ];

      case 'skills':
        return [
          TerminalOutputLine('TECHNICAL SKILLS MATRIX:', type: 'accent'),
          TerminalOutputLine('┌────────────────────────┬────────────────────────────────────────┐'),
          TerminalOutputLine('│ CATEGORY               │ TECHNOLOGIES                           │'),
          TerminalOutputLine('├────────────────────────┼────────────────────────────────────────┤'),
          TerminalOutputLine('│ Mobile & Frontend      │ Flutter, Dart, Clean Arch, Responsive │'),
          TerminalOutputLine('│ Backend & Cloud        │ REST APIs, Firebase, Node.js, Python   │'),
          TerminalOutputLine('│ Core & Languages       │ C++, Data Structures, Algorithms, Git  │'),
          TerminalOutputLine('│ AI & Data Science      │ PyTorch, Machine Learning, Pandas      │'),
          TerminalOutputLine('└────────────────────────┴────────────────────────────────────────┘'),
        ];

      case 'projects':
        return [
          TerminalOutputLine('FEATURED PROJECTS:', type: 'accent'),
          TerminalOutputLine('1. 📱 Mobile Todo App (Flutter)'),
          TerminalOutputLine('   - State management, SQLite/Hive, clean architecture'),
          TerminalOutputLine('   - Repo: https://github.com/rudrapratap19/flutter-todo-app'),
          TerminalOutputLine(''),
          TerminalOutputLine('2. ⚡ Decoder-Only Transformer (C++ / AI)'),
          TerminalOutputLine('   - Built custom GPT-style autoregressive language model'),
          TerminalOutputLine('   - Repo: https://github.com/rudrapratap19/Decoder-Only-Transformer-for-Language-Modeling'),
          TerminalOutputLine(''),
          TerminalOutputLine('3. 🎵 Real-time Audio Processing Engine (Python)'),
          TerminalOutputLine('   - Audio waveform DSP & spectral filtering algorithms'),
        ];

      case 'exp':
        return [
          TerminalOutputLine('CAREER EXPERIENCE & LEADERSHIP:', type: 'accent'),
          TerminalOutputLine('├── 🚀 Junior Flutter Developer @ Webintegratorz Technologies (May 2026 - Present)'),
          TerminalOutputLine('│   ├── Built scalable Flutter UI components & REST API integrations'),
          TerminalOutputLine('│   └── Improved app performance & async workflow responsiveness'),
          TerminalOutputLine('│'),
          TerminalOutputLine('├── 📱 Flutter Developer Intern @ Syflex Techno Solution (Mar 2026 - May 2026)'),
          TerminalOutputLine('│   ├── Integrated Firebase services & real-time sync modules'),
          TerminalOutputLine('│   └── Implemented error handling & state management'),
          TerminalOutputLine('│'),
          TerminalOutputLine('└── 🎓 Student Leadership @ IIIT Raichur'),
          TerminalOutputLine('    ├── Academic Secretary (Aug 2024 - Aug 2025): Led student-faculty feedback'),
          TerminalOutputLine('    └── Placement Coordinator (Jan 2026 - May 2026): Coordinated 15+ recruiters'),
        ];

      case 'stats':
      case 'github':
      case 'leetcode':
        try {
          final stats = await ApiService.fetchAllStats();
          final lc = stats.leetcode;
          final gh = stats.github;
          return [
            TerminalOutputLine('LIVE PLATFORM STATISTICS:', type: 'accent'),
            TerminalOutputLine('LeetCode Total Solved: ${lc.totalSolved} (Easy: ${lc.easySolved}, Med: ${lc.mediumSolved}, Hard: ${lc.hardSolved})'),
            TerminalOutputLine('LeetCode Contest Rating: ${lc.contestRating.toStringAsFixed(0)}'),
            TerminalOutputLine('GeeksforGeeks Score: 450+ (250+ Solved)'),
            TerminalOutputLine('Combined DSA Solved: ${lc.totalSolved + 250}+ Problems'),
            TerminalOutputLine('GitHub Public Repos: ${gh.publicRepos}'),
            TerminalOutputLine('GitHub Stars: ${gh.totalStars} ⭐'),
          ];
        } catch (_) {
          return [
            TerminalOutputLine('LIVE PLATFORM STATISTICS (Cached):', type: 'accent'),
            TerminalOutputLine('LeetCode Solved: 224+ Problems (Rating: 1450+)'),
            TerminalOutputLine('GeeksforGeeks Score: 450+ (250+ Solved)'),
            TerminalOutputLine('Total DSA Solved: 474+ Problems'),
            TerminalOutputLine('GitHub Public Repos: 22'),
          ];
        }

      case 'certs':
      case 'certificates':
      case 'roadmap':
      case 'achievements':
        return [
          TerminalOutputLine('ACHIEVEMENTS & CREDENTIALS ROADMAP:', type: 'accent'),
          TerminalOutputLine('├── 🏆 District Topper (10th Board Exam) [Academic Excellence]'),
          TerminalOutputLine('├── 🥇 Naukri Campus Young Turks 2025 [99.40 Percentile Merit]'),
          TerminalOutputLine('├── 🎓 GATE CS 2026 [Qualified]'),
          TerminalOutputLine('├── 📜 Flutter & Dart - The Complete Guide [Udemy / Schwarzmüller]'),
          TerminalOutputLine('├── 👑 Academic Affairs Secretary [CoSA IIIT Raichur 2024-2025]'),
          TerminalOutputLine('├── 💻 LeetCode Top 5000 Rank & 474+ DSA Solved [1450+ Rating]'),
          TerminalOutputLine('├── 📜 Learn C++ Programming - Deep Dive [Udemy / Abdul Bari]'),
          TerminalOutputLine('├── 💼 Placement Cell Coordinator [IIIT Raichur 2026]'),
          TerminalOutputLine('├── 🚀 Adobe India Hackathon 2025 [Round 1 Qualifier]'),
          TerminalOutputLine('└── 🚀 L\'Oréal Sustainability Challenge 2025 [Aptitude Qualifier]'),
        ];

      case 'tree':
        return [
          TerminalOutputLine(currentDir, type: 'accent'),
          TerminalOutputLine('├── 📁 About'),
          TerminalOutputLine('│   ├── about.txt'),
          TerminalOutputLine('│   └── resume.txt'),
          TerminalOutputLine('├── 📁 Skills'),
          TerminalOutputLine('│   └── skills.json'),
          TerminalOutputLine('├── 📁 Projects'),
          TerminalOutputLine('│   ├── flutter_todo/'),
          TerminalOutputLine('│   └── cpp_transformer/'),
          TerminalOutputLine('└── 📁 Contact'),
          TerminalOutputLine('    └── contact.info'),
        ];

      case 'dir':
      case 'ls':
        return [
          TerminalOutputLine(' Directory of $currentDir', type: 'accent'),
          TerminalOutputLine(''),
          TerminalOutputLine('2026-07-26  01:00 AM    <DIR>          About'),
          TerminalOutputLine('2026-07-26  01:00 AM    <DIR>          Skills'),
          TerminalOutputLine('2026-07-26  01:00 AM    <DIR>          Projects'),
          TerminalOutputLine('2026-07-26  01:00 AM              1,024 about.txt'),
          TerminalOutputLine('2026-07-26  01:00 AM                850 skills.json'),
          TerminalOutputLine('2026-07-26  01:00 AM              1,420 resume.txt'),
          TerminalOutputLine('2026-07-26  01:00 AM                410 contact.info'),
          TerminalOutputLine('               4 File(s)          3,704 bytes'),
          TerminalOutputLine('               3 Dir(s)  142,512,128,000 bytes free'),
        ];

      case 'cat':
      case 'type':
        if (args.isEmpty) {
          return [TerminalOutputLine('Usage: cat <filename> (e.g. cat resume.txt)', type: 'warning')];
        }
        final fname = args[0].toLowerCase();
        if (_pseudoFiles.containsKey(fname)) {
          return _pseudoFiles[fname]!
              .trim()
              .split('\n')
              .map((line) => TerminalOutputLine(line))
              .toList();
        } else {
          return [TerminalOutputLine("File not found: '$fname'. Type 'dir' to list files.", type: 'error')];
        }

      case 'ping':
        final host = args.isNotEmpty ? args[0] : 'leetcode.com';
        return [
          TerminalOutputLine('Pinging $host [104.22.65.91] with 32 bytes of data:'),
          TerminalOutputLine('Reply from 104.22.65.91: bytes=32 time=18ms TTL=56'),
          TerminalOutputLine('Reply from 104.22.65.91: bytes=32 time=16ms TTL=56'),
          TerminalOutputLine('Reply from 104.22.65.91: bytes=32 time=19ms TTL=56'),
          TerminalOutputLine('Reply from 104.22.65.91: bytes=32 time=17ms TTL=56'),
          TerminalOutputLine('Ping statistics for 104.22.65.91:'),
          TerminalOutputLine('    Packets: Sent = 4, Received = 4, Lost = 0 (0% loss)'),
          TerminalOutputLine('Approximate round trip times in milli-seconds:'),
          TerminalOutputLine('    Minimum = 16ms, Maximum = 19ms, Average = 17ms'),
        ];

      case 'date':
      case 'time':
        final now = DateTime.now();
        return [
          TerminalOutputLine('System Date & Time: ${now.toLocal()}', type: 'accent'),
          TerminalOutputLine('Time Zone: India Standard Time (UTC+05:30)'),
        ];

      case 'sudo':
      case 'su':
        return [
          TerminalOutputLine('[SUDO] Password:', type: 'warning'),
          TerminalOutputLine('Access Granted! Administrator privileges verified for Rudra Pratap Singh.', type: 'success'),
        ];

      case 'theme':
        if (args.isEmpty) {
          return [TerminalOutputLine('Current theme: cmd. Usage: theme dark | theme light | theme cmd', type: 'warning')];
        }
        final target = args[0].toLowerCase();
        if (target == 'dark') {
          ThemeNotifier.instance.setTheme(AppThemeMode.dark);
          return [TerminalOutputLine('Switched theme to Dark Space mode 🌙', type: 'success')];
        } else if (target == 'light') {
          ThemeNotifier.instance.setTheme(AppThemeMode.light);
          return [TerminalOutputLine('Switched theme to Light Minimalist mode ☀️', type: 'success')];
        } else if (target == 'cmd') {
          ThemeNotifier.instance.setTheme(AppThemeMode.cmd);
          return [TerminalOutputLine('Command Prompt mode active 💻', type: 'success')];
        } else {
          return [TerminalOutputLine("Unknown theme '$target'. Choose 'dark', 'light', or 'cmd'.", type: 'error')];
        }

      case 'contact':
        if (args.isNotEmpty) {
          final message = args.join(' ');
          final now = DateTime.now();
          final timestamp = '${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}:${now.second.toString().padLeft(2,'0')}';
          return [
            TerminalOutputLine(''),
            TerminalOutputLine('  ┌─────────────────────────────────────────────┐', type: 'accent'),
            TerminalOutputLine('  │           📧  MESSAGE SENT                  │', type: 'accent'),
            TerminalOutputLine('  ├─────────────────────────────────────────────┤', type: 'accent'),
            TerminalOutputLine('  │  To:      rpsinghiiitr@gmail.com           │'),
            TerminalOutputLine('  │  From:    visitor@portfolio.dev             │'),
            TerminalOutputLine('  │  Time:    $timestamp IST                        │'),
            TerminalOutputLine('  │  Status:  ✅ DELIVERED                      │', type: 'success'),
            TerminalOutputLine('  ├─────────────────────────────────────────────┤', type: 'accent'),
            TerminalOutputLine('  │  Msg: ${message.substring(0, message.length.clamp(0, 38)).padRight(38)} │'),
            TerminalOutputLine('  └─────────────────────────────────────────────┘', type: 'accent'),
            TerminalOutputLine(''),
            TerminalOutputLine("I'll get back to you soon! 🚀", type: 'success'),
          ];
        }
        return [
          TerminalOutputLine('CONTACT DETAILS:', type: 'accent'),
          TerminalOutputLine('  Email:    rpsinghiiitr@gmail.com'),
          TerminalOutputLine('  GitHub:   https://github.com/rudrapratap19'),
          TerminalOutputLine('  LeetCode: https://leetcode.com/u/rpsinghiiitr/'),
          TerminalOutputLine('  LinkedIn: https://www.linkedin.com/in/rudra-pratap-singh-677149314'),
          TerminalOutputLine(''),
          TerminalOutputLine("Tip: Try 'contact <your message>' to send a quick message!", type: 'warning'),
        ];

      case 'open':
        if (args.isEmpty) {
          return [
            TerminalOutputLine('Usage: open <target>', type: 'warning'),
            TerminalOutputLine('  open github    - Opens GitHub profile'),
            TerminalOutputLine('  open linkedin  - Opens LinkedIn profile'),
            TerminalOutputLine('  open resume    - Opens Resume PDF'),
          ];
        }
        final target = args[0].toLowerCase();
        switch (target) {
          case 'github':
            return [
              TerminalOutputLine('Opening GitHub profile in browser...', type: 'accent'),
              TerminalOutputLine('URL: https://github.com/rudrapratap19', type: 'success'),
              TerminalOutputLine('>> OPEN_URL:https://github.com/rudrapratap19', type: '__url__'),
            ];
          case 'linkedin':
            return [
              TerminalOutputLine('Opening LinkedIn profile in browser...', type: 'accent'),
              TerminalOutputLine('URL: https://www.linkedin.com/in/rudra-pratap-singh-677149314', type: 'success'),
              TerminalOutputLine('>> OPEN_URL:https://www.linkedin.com/in/rudra-pratap-singh-677149314', type: '__url__'),
            ];
          case 'resume':
            return [
              TerminalOutputLine('Opening Resume PDF...', type: 'accent'),
              TerminalOutputLine('Downloading: Resume_Rudra_Pratap_Singh.pdf', type: 'success'),
              TerminalOutputLine('>> OPEN_URL:Resume.pdf', type: '__url__'),
            ];
          case 'leetcode':
            return [
              TerminalOutputLine('Opening LeetCode profile in browser...', type: 'accent'),
              TerminalOutputLine('URL: https://leetcode.com/u/rpsinghiiitr/', type: 'success'),
              TerminalOutputLine('>> OPEN_URL:https://leetcode.com/u/rpsinghiiitr/', type: '__url__'),
            ];
          default:
            return [
              TerminalOutputLine("Unknown target '$target'. Try: open github | open linkedin | open resume", type: 'error'),
            ];
        }

      case 'whoami':
        return [
          TerminalOutputLine(''),
          TerminalOutputLine('   ____  _   _ ____  ____      _    ', type: 'accent'),
          TerminalOutputLine('  |  _ \\| | | |  _ \\|  _ \\    / \\   ', type: 'accent'),
          TerminalOutputLine('  | |_) | | | | | | | |_) |  / _ \\  ', type: 'accent'),
          TerminalOutputLine('  |  _ <| |_| | |_| |  _ <  / ___ \\ ', type: 'accent'),
          TerminalOutputLine('  |_| \\_\\\\___/|____/|_| \\_\\/_/   \\_\\', type: 'accent'),
          TerminalOutputLine(''),
          TerminalOutputLine('  +------------------------------------------+'),
          TerminalOutputLine('  |  Name    : Rudra Pratap Singh            |'),
          TerminalOutputLine('  |  Role    : Flutter Dev & AI Student      |'),
          TerminalOutputLine('  |  College : IIIT Raichur (B.Tech 2023-27) |'),
          TerminalOutputLine('  |  Skills  : Flutter, Python, ML, DSA      |'),
          TerminalOutputLine('  |  DSA     : 474+ problems solved          |'),
          TerminalOutputLine('  |  GATE    : CS 2026 Qualified             |'),
          TerminalOutputLine('  |  Email   : rpsinghiiitr@gmail.com        |'),
          TerminalOutputLine('  +------------------------------------------+'),
          TerminalOutputLine(''),
        ];

      case 'weather':
        try {
          // Raichur, India coordinates
          const lat = 16.2120;
          const lon = 77.3566;
          final url = Uri.parse(
            'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,weather_code,wind_speed_10m,relative_humidity_2m&timezone=Asia%2FKolkata',
          );
          final response = await http.get(url).timeout(const Duration(seconds: 6));
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final current = data['current'];
            final temp = (current['temperature_2m'] as num).toStringAsFixed(1);
            final humidity = current['relative_humidity_2m'];
            final wind = (current['wind_speed_10m'] as num).toStringAsFixed(1);
            final code = current['weather_code'] as int;
            final condition = _weatherCode(code);
            return [
              TerminalOutputLine(''),
              TerminalOutputLine('  🌍 WEATHER: Raichur, Karnataka, India', type: 'accent'),
              TerminalOutputLine('  ─────────────────────────────────────'),
              TerminalOutputLine('  🌡  Temperature : ${temp}°C'),
              TerminalOutputLine('  $condition'),
              TerminalOutputLine('  💧 Humidity    : $humidity%'),
              TerminalOutputLine('  💨 Wind Speed  : ${wind} km/h'),
              TerminalOutputLine('  ─────────────────────────────────────'),
              TerminalOutputLine('  Source: Open-Meteo API (open-meteo.com)', type: 'warning'),
              TerminalOutputLine(''),
            ];
          } else {
            throw Exception('API error');
          }
        } catch (_) {
          return [
            TerminalOutputLine('🌍 WEATHER: Raichur, Karnataka, India (Estimated)', type: 'accent'),
            TerminalOutputLine('  🌡  Temperature : ~32°C (Typical monsoon/summer)'),
            TerminalOutputLine('  ☁️  Condition   : Partly cloudy'),
            TerminalOutputLine('  💧 Humidity    : ~65%'),
            TerminalOutputLine('  💨 Wind Speed  : ~12 km/h'),
            TerminalOutputLine('  [Weather API unavailable — showing estimates]', type: 'warning'),
          ];
        }

      default:
        return [
          TerminalOutputLine(
            "'$cmd' is not recognized as an internal or external command, operable program or batch file.",
            type: 'error',
          ),
          TerminalOutputLine("Type 'help' or 'neofetch' to view available commands.", type: 'warning'),
        ];
    }
  }

  /// Tab Autocomplete matching helper
  static String autocomplete(String input) {
    if (input.isEmpty) return input;
    final matches = availableCommands
        .where((cmd) => cmd.startsWith(input.toLowerCase()))
        .toList();
    if (matches.isNotEmpty) {
      return matches.first;
    }
    return input;
  }

  /// Weather code to human-readable description
  static String _weatherCode(int code) {
    if (code == 0) return '☀️  Condition   : Clear sky';
    if (code <= 3) return '🌤  Condition   : Partly cloudy';
    if (code <= 48) return '🌫  Condition   : Foggy / Hazy';
    if (code <= 67) return '🌧  Condition   : Rainy';
    if (code <= 77) return '🌨  Condition   : Snowy';
    if (code <= 82) return '🌦  Condition   : Rain showers';
    if (code <= 99) return '⛈  Condition   : Thunderstorm';
    return '🌡  Condition   : Unknown';
  }
}
