import '../core/enums.dart';

class BuffEffect {
  final BuffType type;
  int duration;
  final int value;

  BuffEffect({
    required this.type,
    required this.duration,
    required this.value,
  });
}