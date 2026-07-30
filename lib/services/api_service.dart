import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/platform_stats.dart';

class ApiService {
  static const _githubUser = 'rudrapratap19';
  static const _leetcodeUser = 'rpsinghiiitr';

  static Future<GitHubStats> fetchGitHubStats() async {
    try {
      final userRes = await http
          .get(Uri.parse('https://api.github.com/users/$_githubUser'))
          .timeout(const Duration(seconds: 8));
      if (userRes.statusCode != 200) return GitHubStats.fallback;

      final userJson = jsonDecode(userRes.body) as Map<String, dynamic>;

      final reposRes = await http
          .get(Uri.parse(
              'https://api.github.com/users/$_githubUser/repos?per_page=100&sort=stars'))
          .timeout(const Duration(seconds: 8));

      final repos = reposRes.statusCode == 200
          ? (jsonDecode(reposRes.body) as List<dynamic>)
          : <dynamic>[];

      return GitHubStats.fromJson(userJson, repos);
    } catch (_) {
      return GitHubStats.fallback;
    }
  }

  static Future<LeetCodeStats> fetchLeetCodeStats() async {
    try {
      final results = await Future.wait([
        http
            .get(Uri.parse(
                'https://alfa-leetcode-api.onrender.com/$_leetcodeUser/solved'))
            .timeout(const Duration(seconds: 12)),
        http
            .get(Uri.parse(
                'https://alfa-leetcode-api.onrender.com/$_leetcodeUser/contest'))
            .timeout(const Duration(seconds: 12)),
      ]);

      if (results[0].statusCode != 200 || results[1].statusCode != 200) {
        return LeetCodeStats.fallback;
      }

      return LeetCodeStats.fromSolvedAndContest(
        jsonDecode(results[0].body) as Map<String, dynamic>,
        jsonDecode(results[1].body) as Map<String, dynamic>,
      );
    } catch (_) {
      return LeetCodeStats.fallback;
    }
  }

  static Future<AllStats> fetchAllStats() async {
    final results =
        await Future.wait([fetchGitHubStats(), fetchLeetCodeStats()]);
    return AllStats(
      github: results[0] as GitHubStats,
      leetcode: results[1] as LeetCodeStats,
    );
  }
}
