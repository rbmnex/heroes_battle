import '../core/hero.dart';
import '../core/card.dart';
import '../core/enums.dart';

class TurnController {
  TurnPhase currentPhase = TurnPhase.draw;

  final List<CardModel> drawPile;
  final List<CardModel> discardPile;
  final List<CardModel> hand;

  TurnController({
    required this.drawPile,
    required this.discardPile,
    required this.hand,
  });

  /// =========================
  /// PHASE CONTROL
  /// =========================

  void startTurn() {
    currentPhase = TurnPhase.draw;
  }

  void nextPhase() {
    switch (currentPhase) {
      case TurnPhase.draw:
        _handleDrawPhase();
        currentPhase = TurnPhase.item;
        break;

      case TurnPhase.item:
        currentPhase = TurnPhase.action;
        break;

      case TurnPhase.action:
        currentPhase = TurnPhase.end;
        break;

      case TurnPhase.end:
        _handleEndPhase();
        currentPhase = TurnPhase.draw;
        break;
    }
  }

  /// =========================
  /// DRAW PHASE
  /// =========================

  void _handleDrawPhase({int drawCount = 1}) {
    for (int i = 0; i < drawCount; i++) {
      if (drawPile.isEmpty) {
        _reshuffleDiscardIntoDraw();
      }

      if (drawPile.isNotEmpty) {
        hand.add(drawPile.removeAt(0));
      }
    }
  }

  void _reshuffleDiscardIntoDraw() {
    drawPile.addAll(discardPile);
    discardPile.clear();
    drawPile.shuffle();
  }

  /// =========================
  /// ACTION VALIDATION
  /// =========================

  bool canUseItem() {
    return currentPhase == TurnPhase.item;
  }

  bool canAttack(HeroModel hero) {
    return currentPhase == TurnPhase.action &&
        hero.hasAttackedThisTurn == false;
  }

  /// =========================
  /// END PHASE
  /// =========================

  void _handleEndPhase() {
    // Discard all cards in hand (simple rule for now)
    discardPile.addAll(hand);
    hand.clear();
  }

  /// =========================
  /// TURN RESET
  /// =========================

  void resetHeroForNewTurn(HeroModel hero) {
    hero.hasAttackedThisTurn = false;
  }
}
