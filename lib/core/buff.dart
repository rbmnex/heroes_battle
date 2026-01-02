import 'enums.dart';

class Buff {
  final BuffType type;
  final int value;
  int duration;

  Buff({
    required this.type,
    required this.value,
    required this.duration,
  });
}
