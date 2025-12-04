import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/betting_service.dart';
import '../models/bet_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<BettingService>(context);
    final bets = service.bets;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            child: Column(
              children: [
                const Text('Current Balance', style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  '${service.balance} Coins',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => service.resetBalance(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Balance'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Bet History',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          Expanded(
            child: bets.isEmpty
                ? const Center(child: Text('No bets placed yet.'))
                : ListView.builder(
                    itemCount: bets.length,
                    itemBuilder: (context, index) {
                      final bet = bets[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getStatusColor(bet.status).withOpacity(0.1),
                          child: Icon(
                            _getStatusIcon(bet.status),
                            color: _getStatusColor(bet.status),
                            size: 20,
                          ),
                        ),
                        title: Text(bet.matchLabel),
                        subtitle: Text(
                          '${_getSelectionText(bet.selection)} @ ${bet.odds.toStringAsFixed(2)}',
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '-${bet.stake}',
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                            if (bet.status == BetStatus.open)
                              Text(
                                'Pot. Win: ${bet.potentialWin}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              )
                            else if (bet.status == BetStatus.won)
                              Text(
                                '+${bet.potentialWin}',
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BetStatus status) {
    switch (status) {
      case BetStatus.open: return Colors.orange;
      case BetStatus.won: return Colors.green;
      case BetStatus.lost: return Colors.red;
    }
  }

  IconData _getStatusIcon(BetStatus status) {
    switch (status) {
      case BetStatus.open: return Colors.hourglass_empty == Colors.hourglass_empty ? Icons.hourglass_empty : Icons.hourglass_empty; // Fix for weird lint if any
      case BetStatus.won: return Icons.check;
      case BetStatus.lost: return Icons.close;
    }
    return Icons.hourglass_empty;
  }

  String _getSelectionText(BetSelection selection) {
    switch (selection) {
      case BetSelection.home: return 'Home';
      case BetSelection.draw: return 'Draw';
      case BetSelection.away: return 'Away';
    }
  }
}
