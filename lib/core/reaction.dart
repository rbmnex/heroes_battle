import 'enums.dart';

class ReactionCard {
  final String id;
  final String name;
  final ReactionType type;

  const ReactionCard({
    required this.id,
    required this.name,
    required this.type,
  });
}
