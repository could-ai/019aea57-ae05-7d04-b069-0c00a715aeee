import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../models/bet_model.dart';

class BettingService extends ChangeNotifier {
  // User State
  int _balance = 10000;
  int get balance => _balance;

  // Data State
  final List<MatchModel> _matches = [];
  final List<BetModel> _bets = [];

  List<MatchModel> get matches => _matches;
  List<BetModel> get bets => _bets;

  BettingService() {
    _generateMockMatches();
  }

  void _generateMockMatches() {
    final now = DateTime.now();
    _matches.addAll([
      MatchModel(
        id: '1',
        league: 'Premier League',
        homeTeam: 'Arsenal',
        awayTeam: 'Liverpool',
        startTime: now.add(const Duration(hours: 2)),
        status: MatchStatus.scheduled,
        oddsHome: 2.45,
        oddsDraw: 3.40,
        oddsAway: 2.80,
      ),
      MatchModel(
        id: '2',
        league: 'La Liga',
        homeTeam: 'Real Madrid',
        awayTeam: 'Barcelona',
        startTime: now.subtract(const Duration(minutes: 45)),
        status: MatchStatus.live,
        scoreHome: 1,
        scoreAway: 1,
        oddsHome: 3.10,
        oddsDraw: 2.90,
        oddsAway: 2.50,
      ),
      MatchModel(
        id: '3',
        league: 'Serie A',
        homeTeam: 'Juventus',
        awayTeam: 'AC Milan',
        startTime: now.add(const Duration(days: 1)),
        status: MatchStatus.scheduled,
        oddsHome: 1.95,
        oddsDraw: 3.20,
        oddsAway: 4.10,
      ),
      MatchModel(
        id: '4',
        league: 'Bundesliga',
        homeTeam: 'Bayern Munich',
        awayTeam: 'Dortmund',
        startTime: now.subtract(const Duration(hours: 2)),
        status: MatchStatus.finished,
        scoreHome: 3,
        scoreAway: 1,
        oddsHome: 1.50,
        oddsDraw: 4.50,
        oddsAway: 5.50,
      ),
    ]);
    notifyListeners();
  }

  void placeBet(MatchModel match, BetSelection selection, int stake) {
    if (stake > _balance) return;

    _balance -= stake;

    double odds;
    switch (selection) {
      case BetSelection.home:
        odds = match.oddsHome;
        break;
      case BetSelection.draw:
        odds = match.oddsDraw;
        break;
      case BetSelection.away:
        odds = match.oddsAway;
        break;
    }

    final newBet = BetModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      matchId: match.id,
      matchLabel: '${match.homeTeam} vs ${match.awayTeam}',
      selection: selection,
      odds: odds,
      stake: stake,
      potentialWin: (stake * odds).round(),
      status: BetStatus.open,
      placedAt: DateTime.now(),
    );

    _bets.insert(0, newBet);
    notifyListeners();
  }

  void resetBalance() {
    _balance = 10000;
    _bets.clear();
    notifyListeners();
  }
}
