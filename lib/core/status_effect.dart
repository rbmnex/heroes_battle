import 'enums.dart';

class StatusEffect {
  final StatusType type;
  final int value;      // Flat value (e.g. DOT damage)
  int duration;         // Turns remaining

  StatusEffect({
    required this.type,
    required this.value,
    required this.duration,
  });
}