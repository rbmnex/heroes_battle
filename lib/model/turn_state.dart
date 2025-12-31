import '../core/enums.dart';
import '../core/hero_model.dart';

class TurnState {
  HeroModel activeHero;
  TurnPhase phase;
  bool hasAttacked;

  TurnState({
    required this.activeHero,
    this.phase = TurnPhase.start,
    this.hasAttacked = false,
  });

  void resetForNewTurn(HeroModel hero) {
    activeHero = hero;
    phase = TurnPhase.start;
    hasAttacked = false;
  }
}
