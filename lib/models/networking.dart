import 'dart:convert';
import 'package:aoe2/constants.dart';
import 'package:aoe2/models/leaderboards.dart';
import 'package:http/http.dart' as http;

const leaderboardsURL = 'https://aoe2.net/api/leaderboard?game=aoe2de&leaderboard_id=';

class NetworkHelper {
  Future getData(String url) async {
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
      return null;
    }
  }

  Future<Leaderboards> getLeaderboards(int lbId, int start) async {
    var leaderboardsData = await getData('$leaderboardsURL$lbId&start=$start&count=$kNumberPerBatch');
    if (leaderboardsData == null) {
      return new Leaderboards();
    } else {
      return new Leaderboards.fromJson(leaderboardsData);
    }
  }

  Future<Leaderboards> getLeaderboardsByName(int lbId,int total,String lbName) async {
    var leaderboardsData = await getData('$leaderboardsURL$lbId&search=$lbName&count=$total');
    if (leaderboardsData == null) {
      return new Leaderboards();
    } else {
      return new Leaderboards.fromJson(leaderboardsData);
    }
  }
}
