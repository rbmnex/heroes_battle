import '../model/status_effect.dart';
import '../model/buff_effect.dart';
import 'item.dart';

class HeroModel {
  // =========================
  // Identity
  // =========================
  final String id;
  final String name;
  final String jobClass;

  // =========================
  // Health
  // =========================
  final int maxHp;
  int currentHp;

  // =========================
  // Turn State
  // =========================
  bool isDefeated = false;
  bool isStunned = false;
  bool hasAttackedThisTurn = false;

  // Swift / combo tracking
  bool comboUsedThisTurn = false;
  int swiftUsedThisTurn = 0;

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
  }) : currentHp = maxHp;

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

  // =========================
  // Health Helpers
  // =========================

  void receiveDamage(int damage) {
    currentHp -= damage;
    if (currentHp <= 0) {
      currentHp = 0;
      isDefeated = true;
    }
  }

  void heal(int amount) {
    if (isDefeated) return;

    currentHp += amount;
    if (currentHp > maxHp) {
      currentHp = maxHp;
    }
  }

 
}
