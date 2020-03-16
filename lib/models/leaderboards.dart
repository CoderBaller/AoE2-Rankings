import 'package:aoe2/constants.dart';

String getLeaderboardTitle(int lbId){
  switch(lbId){
    case kUNRANKED:
      return 'Unranked';
    case k1V1DM: 
      return '1vs1 Death Match';
    case kTDM:
      return 'Team Death Match';
    case k1v1RM:
      return '1vs1 Random Map';
    case kTRM:
      return 'Team Random Map';
    default:
      return '1vs1 Random Map';
  }
}

class Leaderboards {
  int total;
  int leaderboardId;
  int start;
  int count;
  List<Leaderboard> leaderboard;
  bool isLoaded = false;

  Leaderboards(
      {this.total,
      this.leaderboardId,
      this.start,
      this.count,
      this.leaderboard});

  Leaderboards.fromJson(Map<String, dynamic> json) {
    isLoaded = true;
    total = json['total'];
    leaderboardId = json['leaderboard_id'];
    start = json['start'];
    count = json['count'];
    if (json['leaderboard'] != null) {
      leaderboard = new List<Leaderboard>();
      json['leaderboard'].forEach((v) {
        leaderboard.add(new Leaderboard.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['leaderboard_id'] = this.leaderboardId;
    data['start'] = this.start;
    data['count'] = this.count;
    if (this.leaderboard != null) {
      data['leaderboard'] = this.leaderboard.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Leaderboard {
  int profileId;
  int rank;
  int rating;
  String steamId;
  Null icon;
  String name;
  String clan;
  Null country;
  int previousRating;
  int highestRating;
  int streak;
  int lowestStreak;
  int highestStreak;
  int games;
  int wins;
  int losses;
  int drops;
  int lastMatch;
  int lastMatchTime;

  Leaderboard(
      {this.profileId,
      this.rank,
      this.rating,
      this.steamId,
      this.icon,
      this.name,
      this.clan,
      this.country,
      this.previousRating,
      this.highestRating,
      this.streak,
      this.lowestStreak,
      this.highestStreak,
      this.games,
      this.wins,
      this.losses,
      this.drops,
      this.lastMatch,
      this.lastMatchTime});

  Leaderboard.fromJson(Map<String, dynamic> json) {
    profileId = json['profile_id'];
    rank = json['rank'];
    rating = json['rating'];
    steamId = json['steam_id'];
    icon = json['icon'];
    name = json['name'];
    clan = json['clan'];
    country = json['country'];
    previousRating = json['previous_rating'];
    highestRating = json['highest_rating'];
    streak = json['streak'];
    lowestStreak = json['lowest_streak'];
    highestStreak = json['highest_streak'];
    games = json['games'];
    wins = json['wins'];
    losses = json['losses'];
    drops = json['drops'];
    lastMatch = json['last_match'];
    lastMatchTime = json['last_match_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_id'] = this.profileId;
    data['rank'] = this.rank;
    data['rating'] = this.rating;
    data['steam_id'] = this.steamId;
    data['icon'] = this.icon;
    data['name'] = this.name;
    data['clan'] = this.clan;
    data['country'] = this.country;
    data['previous_rating'] = this.previousRating;
    data['highest_rating'] = this.highestRating;
    data['streak'] = this.streak;
    data['lowest_streak'] = this.lowestStreak;
    data['highest_streak'] = this.highestStreak;
    data['games'] = this.games;
    data['wins'] = this.wins;
    data['losses'] = this.losses;
    data['drops'] = this.drops;
    data['last_match'] = this.lastMatch;
    data['last_match_time'] = this.lastMatchTime;
    return data;
  }
}
