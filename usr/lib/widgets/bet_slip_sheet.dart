import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/betting_service.dart';
import '../models/match_model.dart';
import '../models/bet_model.dart';

class BetSlipSheet extends StatefulWidget {
  final MatchModel match;
  final BetSelection selection;

  const BetSlipSheet({
    super.key,
    required this.match,
    required this.selection,
  });

  @override
  State<BetSlipSheet> createState() => _BetSlipSheetState();
}

class _BetSlipSheetState extends State<BetSlipSheet> {
  final TextEditingController _stakeController = TextEditingController(text: '100');
  
  @override
  void dispose() {
    _stakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<BettingService>(context);
    final odds = _getOdds(widget.match, widget.selection);
    
    // Calculate potential win safely
    int stake = int.tryParse(_stakeController.text) ?? 0;
    int potentialWin = (stake * odds).round();

    return Container(
      padding: EdgeInsets.only(
        left: 20, 
        right: 20, 
        top: 20, 
        bottom: MediaQuery.of(context).viewInsets.bottom + 20
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bet Slip',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.match.homeTeam} vs ${widget.match.awayTeam}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        odds.toStringAsFixed(2),
                        style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Selection: '),
                    Text(
                      _getSelectionName(widget.selection),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _stakeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Stake (Coins)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.monetization_on_outlined),
                  ),
                  onChanged: (val) => setState(() {}),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Potential Win'),
                  Text(
                    '$potentialWin',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: stake > 0 && stake <= service.balance
                  ? () {
                      service.placeBet(widget.match, widget.selection, stake);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bet Placed Successfully!')),
                      );
                    }
                  : null,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                stake > service.balance 
                  ? 'Insufficient Balance' 
                  : 'Place Bet ($stake Coins)',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getOdds(MatchModel match, BetSelection selection) {
    switch (selection) {
      case BetSelection.home: return match.oddsHome;
      case BetSelection.draw: return match.oddsDraw;
      case BetSelection.away: return match.oddsAway;
    }
  }

  String _getSelectionName(BetSelection selection) {
    switch (selection) {
      case BetSelection.home: return 'Home Win';
      case BetSelection.draw: return 'Draw';
      case BetSelection.away: return 'Away Win';
    }
  }
}
