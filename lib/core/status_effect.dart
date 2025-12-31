import 'enums.dart';

class StatusEffect {
  final StatusType type;
  int remainingTurns;

  StatusEffect({
    required this.type,
    required this.remainingTurns,
  });
}