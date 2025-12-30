import '../engine/turn_controller.dart';
import '../core/hero.dart';
import '../engine/attack_engine.dart';
import '../engine/item_engine.dart';

class TurnFlow {
  void executeTurn(
    TurnController turnController,
    HeroModel hero,
    AttackEngine attackEngine,
    ItemEngine itemEngine,
  ) {
    // Implementation of turn execution
    turnController.startTurn();

// DRAW
    turnController.nextPhase();

    // ITEM
    if (turnController.canUseItem()) {
      // itemEngine.useConsumable(...);
    }
    turnController.nextPhase();

    // ACTION
    if (turnController.canAttack(hero)) {
      // attackEngine.resolveAttack(...);
      hero.hasAttackedThisTurn = true;
    }
    turnController.nextPhase();

    // END
    turnController.nextPhase();
    turnController.resetHeroForNewTurn(hero);

  }
}