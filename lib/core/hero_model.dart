import 'buff.dart';
import 'card_model.dart';
import 'status_effect.dart';
import 'job_class.dart';

class HeroModel {
  /// =========================
  /// IDENTITY
  /// =========================
  final String id;
  final String name;
  final JobClass jobClass;

  /// =========================
  /// HEALTH
  /// =========================
  final int maxHp;
  int currentHp;

  bool get isDefeated => currentHp <= 0;

  /// =========================
  /// TURN FLAGS
  /// =========================
  
  /// Can only attack once per turn
  bool hasAttackedThisTurn = false;

 /// Used for Swift / combo rules
  bool swiftUsedThisTurn = false;
  bool comboUsedThisTurn = false;

  /// Used for item phase rules
  bool usedItemThisTurn = false;

  /// =========================
  /// COMBAT STATE
  /// =========================
  final List<Buff> buffs = [];
  final List<StatusEffect> statusEffects = [];

  CardModel? activeReaction;

  /// =========================
  /// CONSTRUCTOR
  /// =========================
  HeroModel({
    required this.id,
    required this.name,
    required this.jobClass,
    required this.maxHp,
  }) : currentHp = maxHp;


}
