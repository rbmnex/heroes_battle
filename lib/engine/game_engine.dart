import '../core/player.dart';

class GameEngine {
  final Player playerA;
  final Player playerB;

  late Player activePlayer;
  late Player opponent;

  GameEngine({
    required this.playerA,
    required this.playerB,
  });

  void startGame({bool playerAGoesFirst = true}) {
    playerA.drawCards(5);
    playerB.drawCards(5);

    activePlayer = playerAGoesFirst ? playerA : playerB;
    opponent = playerAGoesFirst ? playerB : playerA;
  }

  void startTurn() {
    // Draw rule
    if (activePlayer.hand.length < 5) {
      activePlayer.drawCards(5 - activePlayer.hand.length);
    } else {
      activePlayer.drawCards(1);
      // Must discard 1 (handled by UI or AI later)
    }

    for (var hero in activePlayer.heroes) {
      hero.startTurn();
    }
  }

  void endTurn() {
    final temp = activePlayer;
    activePlayer = opponent;
    opponent = temp;
  }
}
