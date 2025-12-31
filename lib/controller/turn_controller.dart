import 'package:heroes_battle/core/card_model.dart';
import 'package:heroes_battle/core/enums.dart';
import 'package:heroes_battle/core/hero_model.dart';
import 'package:heroes_battle/engine/attack_engine.dart';
import 'package:heroes_battle/engine/status_effect_engine.dart';
import 'package:heroes_battle/engine/swift_combo_engine.dart';
import 'package:heroes_battle/model/combat_result.dart';
import 'package:heroes_battle/model/turn_state.dart';

class TurnController {
  final AttackEngine _attackEngine;
  final StatusEffectEngine _statusEffectEngine;
  final SwiftComboEngine _swiftComboEngine;

  late TurnState _turn;

  TurnController({
    required AttackEngine attackEngine,
    required StatusEffectEngine statusEffectEngine,
    required SwiftComboEngine swiftComboEngine,
    required HeroModel startingHero,
  })  : _attackEngine = attackEngine,
        _statusEffectEngine = statusEffectEngine,
        _swiftComboEngine = swiftComboEngine {
    _turn = TurnState(activeHero: startingHero);
  }

  TurnState get state => _turn;

  // =========================
  // TURN START
  // =========================
  void startTurn() {
    if (_turn.phase != TurnPhase.start) {
      throw Exception('Turn already started');
    }

    _statusEffectEngine.processTurnStart(_turn.activeHero);
    _swiftComboEngine.resetTurn(_turn.activeHero);

    _turn.phase = TurnPhase.action;
  }

  // =========================
  // ATTACK
  // =========================
  CombatResult performAttack({
    required CardModel attackCard,
    required List<HeroModel> targets,
    bool isCombo = false,
    Map<String, CardModel?> reactions = const {},
  }) {
    if (_turn.phase != TurnPhase.action) {
      throw Exception('Cannot attack outside action phase');
    }

    if (_turn.hasAttacked && !isCombo) {
      throw Exception('Already attacked this turn');
    }

    final result = _attackEngine.resolveAttack(
      attacker: _turn.activeHero,
      attackCard: attackCard,
      defenders: targets,
      isCombo: isCombo,
      reactions: reactions,
    );

    _turn.hasAttacked = true;
    return result;
  }

  // =========================
  // TURN END
  // =========================
  void endTurn() {
    if (_turn.phase != TurnPhase.action) {
      throw Exception('Cannot end turn now');
    }

    _statusEffectEngine.processTurnEnd(_turn.activeHero);
    _turn.phase = TurnPhase.end;
  }

  // =========================
  // NEXT HERO
  // =========================
  void nextTurn(HeroModel nextHero) {
    if (_turn.phase != TurnPhase.end) {
      throw Exception('Turn not finished');
    }

    _turn.resetForNewTurn(nextHero);
  }
}
