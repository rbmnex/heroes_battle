import '../core/enums.dart';

class StatusEffect {
  final StatusType type;
  int duration;
  final int value; // damage, reduction %, etc.

  StatusEffect({
    required this.type,
    required this.duration,
    this.value = 0,
  });
}