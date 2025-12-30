import 'package:heroes_battle/controller/turn_controller.dart';
import 'package:heroes_battle/core/hero.dart';
import 'package:heroes_battle/engine/attack_engine.dart';
import 'package:heroes_battle/engine/item_engine.dart';

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