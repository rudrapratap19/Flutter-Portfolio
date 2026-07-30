/// Data models for all platform stats

class ContestEntry {
  final String title;
  final double rating;
  final int ranking;

  const ContestEntry({
    required this.title,
    required this.rating,
    required this.ranking,
  });
}

class GitHubRepo {
  final String name;
  final int stars;
  final String? language;

  const GitHubRepo({required this.name, required this.stars, this.language});
}

class GitHubStats {
  final int publicRepos;
  final int followers;
  final int following;
  final int totalStars;
  final String bio;
  final String location;
  final List<GitHubRepo> topRepos;

  const GitHubStats({
    required this.publicRepos,
    required this.followers,
    required this.following,
    required this.totalStars,
    required this.bio,
    required this.location,
    required this.topRepos,
  });

  factory GitHubStats.fromJson(
      Map<String, dynamic> json, List<dynamic> repos) {
    int totalStars = 0;
    final List<GitHubRepo> repoList = [];
    for (final r in repos) {
      final stars = (r['stargazers_count'] ?? 0) as int;
      totalStars += stars;
      repoList.add(GitHubRepo(
        name: r['name'] as String,
        stars: stars,
        language: r['language'] as String?,
      ));
    }
    repoList.sort((a, b) => b.stars.compareTo(a.stars));

    return GitHubStats(
      publicRepos: json['public_repos'] ?? 0,
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      totalStars: totalStars,
      bio: json['bio'] ?? '',
      location: json['location'] ?? '',
      topRepos: repoList.take(6).toList(),
    );
  }

  static GitHubStats get fallback => const GitHubStats(
        publicRepos: 22,
        followers: 0,
        following: 0,
        totalStars: 0,
        bio: '',
        location: 'India',
        topRepos: [],
      );
}

class LeetCodeStats {
  final int totalSolved;
  final int easySolved;
  final int mediumSolved;
  final int hardSolved;
  final double contestRating;
  final int globalRanking;
  final int contestAttend;
  final double topPercentage;
  final List<ContestEntry> contestHistory;

  const LeetCodeStats({
    required this.totalSolved,
    required this.easySolved,
    required this.mediumSolved,
    required this.hardSolved,
    required this.contestRating,
    required this.globalRanking,
    required this.contestAttend,
    required this.topPercentage,
    required this.contestHistory,
  });

  factory LeetCodeStats.fromSolvedAndContest(
    Map<String, dynamic> solved,
    Map<String, dynamic> contest,
  ) {
    final participations =
        (contest['contestParticipation'] as List<dynamic>? ?? []);
    final history = participations.map((p) {
      final c = p['contest'] as Map<String, dynamic>;
      return ContestEntry(
        title: c['title'] as String,
        rating: (p['rating'] as num).toDouble(),
        ranking: (p['ranking'] as num).toInt(),
      );
    }).toList();

    return LeetCodeStats(
      totalSolved: solved['solvedProblem'] ?? 0,
      easySolved: solved['easySolved'] ?? 0,
      mediumSolved: solved['mediumSolved'] ?? 0,
      hardSolved: solved['hardSolved'] ?? 0,
      contestRating: (contest['contestRating'] ?? 0.0).toDouble(),
      globalRanking: (contest['contestGlobalRanking'] ?? 0) as int,
      contestAttend: (contest['contestAttend'] ?? 0) as int,
      topPercentage: (contest['contestTopPercentage'] ?? 0.0).toDouble(),
      contestHistory: history,
    );
  }

  static LeetCodeStats get fallback => const LeetCodeStats(
        totalSolved: 224,
        easySolved: 69,
        mediumSolved: 139,
        hardSolved: 16,
        contestRating: 1501,
        globalRanking: 383134,
        contestAttend: 9,
        topPercentage: 44.15,
        contestHistory: [
          ContestEntry(title: 'BC 136', rating: 1414, ranking: 38302),
          ContestEntry(title: 'BC 163', rating: 1407, ranking: 16095),
          ContestEntry(title: 'WC 469', rating: 1387, ranking: 17203),
          ContestEntry(title: 'BC 168', rating: 1449, ranking: 5248),
          ContestEntry(title: 'WC 473', rating: 1469, ranking: 9313),
          ContestEntry(title: 'BC 169', rating: 1479, ranking: 10552),
          ContestEntry(title: 'BC 172', rating: 1439, ranking: 27592),
          ContestEntry(title: 'BC 175', rating: 1442, ranking: 17765),
          ContestEntry(title: 'WC 504', rating: 1501, ranking: 4402),
        ],
      );
}

class AllStats {
  final GitHubStats github;
  final LeetCodeStats leetcode;

  const AllStats({required this.github, required this.leetcode});
}
