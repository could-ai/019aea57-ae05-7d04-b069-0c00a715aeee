enum MatchStatus { scheduled, live, finished }

class MatchModel {
  final String id;
  final String league;
  final String homeTeam;
  final String awayTeam;
  final DateTime startTime;
  final MatchStatus status;
  final int? scoreHome;
  final int? scoreAway;
  final double oddsHome;
  final double oddsDraw;
  final double oddsAway;

  MatchModel({
    required this.id,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    required this.startTime,
    required this.status,
    this.scoreHome,
    this.scoreAway,
    required this.oddsHome,
    required this.oddsDraw,
    required this.oddsAway,
  });
}
