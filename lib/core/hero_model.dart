import 'buff.dart';
import 'status_effect.dart';
import 'job_class.dart';

class HeroModel {
  final String id;
  final String name;
  final JobClass jobClass;

  final int maxHp;
  int currentHp;

  bool hasAttackedThisTurn = false;

  final List<Buff> buffs = [];
  final List<StatusEffect> statusEffects = [];

  HeroModel({
    required this.id,
    required this.name,
    required this.jobClass,
    required this.maxHp,
  }) : currentHp = maxHp;

  bool get isDefeated => currentHp <= 0;
}
