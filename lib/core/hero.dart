import 'item.dart';

import '../model/status_effect.dart';
import '../model/buff_effect.dart';
import 'enums.dart';
import 'skill.dart';

class HeroModel {
  // =========================
  // Identity
  // =========================
  final String id;
  final String name;
  final JobClass jobClass;

  // =========================
  // Health
  // =========================
  final int maxHp;
  int currentHp;

  // =========================
  // Turn State
  // =========================
  bool hasAttackedThisTurn;
  int swiftUsedThisTurn;
  bool comboUsedThisTurn;

  /// =========================
  /// HERO SKILLS
  /// =========================
  final List<Skill> skills;

  // =========================
  // Effects
  // =========================
  final List<StatusEffect> statusEffects = [];
  final List<BuffEffect> buffs = [];

  // =========================
  // Equipment (optional, future-proof)
  // =========================
  // final List<EquipmentCard> equipment = [];
  ItemCard? equippedItem;

  HeroModel({
    required this.id,
    required this.name,
    required this.jobClass,
    required this.maxHp,
    required this.skills,
    List<StatusEffect>? statusEffects,
    List<BuffEffect>? buffs,
  })  : currentHp = maxHp,
        hasAttackedThisTurn = false,
        swiftUsedThisTurn = 0,
        comboUsedThisTurn = false;

   /// =========================
  /// DERIVED STATE
  /// =========================

  bool get isDefeated => currentHp <= 0;

  bool get canAct => !isDefeated;


  // =========================
  // Turn Helpers
  // =========================

  void startTurn() {
    hasAttackedThisTurn = false;
    comboUsedThisTurn = false;
    swiftUsedThisTurn = 0;
  }

  void endTurn() {
    hasAttackedThisTurn = false;
  }

  /// =========================
  /// DAMAGE & HEALING
  /// =========================

  void takeDamage(int amount) {
    if (amount <= 0) return;
    currentHp -= amount;
    if (currentHp < 0) currentHp = 0;
  }

  void heal(int amount) {
    if (amount <= 0) return;
    currentHp += amount;
    if (currentHp > maxHp) currentHp = maxHp;
  }

 /// =========================
 /// TURN RESET
 /// =========================

  void resetForNewTurn() {
    hasAttackedThisTurn = false;
    swiftUsedThisTurn = 0;
    comboUsedThisTurn = false;
  }
}
