import '../core/hero_model.dart';
import '../core/card_model.dart';
import '../engine/swift_combo_engine.dart';
import '../engine/status_effect_engine.dart';
import '../engine/item_engine.dart';
import '../core/enums.dart';

class TurnController {
  TurnPhase currentPhase = TurnPhase.start;

  final List<CardModel> drawPile;
  final List<CardModel> discardPile;
  final List<CardModel> hand;

  final SwiftComboEngine swiftComboEngine;
  final StatusEffectEngine statusEffectEngine;
  final ItemEngine itemEngine;

  TurnController({
    required this.drawPile,
    required this.discardPile,
    required this.hand,
    required this.swiftComboEngine,
    required this.statusEffectEngine,
    required this.itemEngine,
  });

  /// =========================
  /// TURN FLOW
  /// =========================

  void startTurn(HeroModel activeHero) {
    currentPhase = TurnPhase.draw;
    statusEffectEngine.onTurnStart(activeHero);
  }

  void nextPhase(HeroModel activeHero) {
    switch (currentPhase) {
      case TurnPhase.start:
        currentPhase = TurnPhase.draw;
        break;

      case TurnPhase.draw:
        _drawPhase();
        currentPhase = TurnPhase.main;
        break;

      case TurnPhase.main:
        currentPhase = TurnPhase.action;
        break;

      case TurnPhase.action:
        currentPhase = TurnPhase.end;
        break;

      case TurnPhase.end:
        _endTurn(activeHero);
        currentPhase = TurnPhase.draw;
        break;
    }
  }

  /// =========================
  /// DRAW PHASE
  /// =========================

  void _drawPhase() {
    if (hand.length < 5) {
      _drawCards(5 - hand.length);
    } else {
      _drawCards(1);
      _discardOne();
    }
  }

  void _drawCards(int count) {
    for (int i = 0; i < count; i++) {
      if (drawPile.isEmpty) {
        _reshuffleDiscard();
      }
      if (drawPile.isNotEmpty) {
        hand.add(drawPile.removeAt(0));
      }
    }
  }

  void _discardOne() {
    if (hand.isNotEmpty) {
      discardPile.add(hand.removeAt(0));
    }
  }

  void _reshuffleDiscard() {
    drawPile.addAll(discardPile);
    discardPile.clear();
    drawPile.shuffle();
  }

  /// =========================
  /// VALIDATION
  /// =========================

  bool canUseItem(HeroModel hero) {
    return currentPhase == TurnPhase.main &&
        itemEngine.canUseItem(hero);
  }

  bool canAttack(HeroModel hero) {
    return currentPhase == TurnPhase.action &&
        !hero.hasAttackedThisTurn;
  }

  /// =========================
  /// END TURN
  /// =========================

  void _endTurn(HeroModel hero) {
    discardPile.addAll(hand);
    hand.clear();

    hero.hasAttackedThisTurn = false;

    // swiftComboEngine.resetForNewTurn(hero);
    // itemEngine.resetForNewTurn(hero);
    // statusEffectEngine.onTurnEnd(hero);
  }
}
