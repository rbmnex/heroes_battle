import '../core/hero.dart';
import '../core/card.dart';
import '../core/reaction.dart';
import '../core/enums.dart';
import 'reaction_engine.dart';
import 'swift_combo_engine.dart';

class AttackEngine {
  final ReactionEngine _reactionEngine = ReactionEngine();
  final SwiftComboEngine _swiftComboEngine = SwiftComboEngine();

  /// Call this at the start of EACH HERO turn
  void resetHeroTurn() {
    _swiftComboEngine.resetTurn();
  }

  /// Perform an attack using 1 or more attack cards
  void performAttack({
    required HeroModel attacker,
    required List<HeroModel> defenders,
    required List<CardModel> attackCards,
    required Map<String, ReactionCard?> reactions,
    required Map<String, ReactionCard?> counters,
  }) {
    if (attacker.hasAttackedThisTurn) {
      throw Exception('${attacker.name} has already attacked this turn');
    }

    // 1️⃣ Resolve Swift logic
    final resolution = _swiftComboEngine.resolveAttack(attackCards);
    final CardModel baseAttack = resolution.baseAttack;

    attacker.hasAttackedThisTurn = true;

    // 2️⃣ Determine targets based on combo
    final List<HeroModel> finalDefenders =
        _resolveTargets(defenders, baseAttack, resolution);

    // 3️⃣ Calculate base damage
    final int baseDamage = _calculateBaseDamage(baseAttack);

    // 4️⃣ Resolve per defender
    for (final defender in finalDefenders) {
      if (defender.hp <= 0) continue;

      final reaction = reactions[defender.id];
      final counter = counters[defender.id];

      _resolveAttackOnDefender(
        attacker: attacker,
        defender: defender,
        attackCard: baseAttack,
        baseDamage: baseDamage,
        reaction: reaction,
        counter: counter,
      );
    }
  }

  // ------------------------------------------------------------
  // TARGET RESOLUTION (COMBOS LIVE HERE)
  // ------------------------------------------------------------

  List<HeroModel> _resolveTargets(
    List<HeroModel> defenders,
    CardModel baseAttack,
    AttackResolution resolution,
  ) {
    // No combo → original target list
    if (!resolution.comboTriggered) {
      return defenders;
    }

    // Swift combo logic by category
    switch (baseAttack.attackCategory) {
      case AttackCategory.range:
        // Quick Draw → up to 2 targets
        return defenders.take(2).toList();

      case AttackCategory.magic:
        // Double Cast
        if (baseAttack.attackType == AttackType.normal) {
          return defenders.take(2).toList(); // Bolt → multi
        } else {
          return defenders; // Blast → area
        }

      case AttackCategory.melee:
      default:
        // Blitz → follow-up single target
        return defenders.take(1).toList();
    }
  }

  // ------------------------------------------------------------
  // DAMAGE RESOLUTION
  // ------------------------------------------------------------

  void _resolveAttackOnDefender({
    required HeroModel attacker,
    required HeroModel defender,
    required CardModel attackCard,
    required int baseDamage,
    ReactionCard? reaction,
    ReactionCard? counter,
  }) {
    final result = _reactionEngine.resolveReaction(
      attackCard: attackCard,
      baseDamage: baseDamage,
      reaction: reaction,
      counter: counter,
    );

    // Defender damage
    if (!result.attackNegated) {
      final int finalDamage =
          (baseDamage * result.damageMultiplier).round();
      defender.hp -= finalDamage;
    }

    // Counter damage
    if (result.reflectedDamage > 0) {
      attacker.hp -= result.reflectedDamage;
    }

    _clampHp(defender);
    _clampHp(attacker);
  }

  // ------------------------------------------------------------
  // DAMAGE VALUES (BALANCE POINT)
  // ------------------------------------------------------------

  int _calculateBaseDamage(CardModel card) {
    switch (card.attackType) {
      case AttackType.heavy:
        return 6;
      case AttackType.swift:
        return 3;
      case AttackType.normal:
      default:
        return 4;
    }
  }

  // ------------------------------------------------------------
  // UTILS
  // ------------------------------------------------------------

  void _clampHp(HeroModel hero) {
    if (hero.hp < 0) hero.hp = 0;
  }
}
