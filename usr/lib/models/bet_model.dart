enum BetStatus { open, won, lost }
enum BetSelection { home, draw, away }

class BetModel {
  final String id;
  final String matchId;
  final String matchLabel; // e.g. "Arsenal vs Chelsea"
  final BetSelection selection;
  final double odds;
  final int stake;
  final int potentialWin;
  final BetStatus status;
  final DateTime placedAt;

  BetModel({
    required this.id,
    required this.matchId,
    required this.matchLabel,
    required this.selection,
    required this.odds,
    required this.stake,
    required this.potentialWin,
    required this.status,
    required this.placedAt,
  });
}
