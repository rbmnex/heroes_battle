import '../core/hero_model.dart';

class ItemEngine {
  bool canUseItem(HeroModel hero) => !hero.usedItemThisTurn;

  void markItemUsed(HeroModel hero) {
    hero.usedItemThisTurn = true;
  }

  void resetForNewTurn(HeroModel hero) {
    hero.usedItemThisTurn = false;
  }
}
