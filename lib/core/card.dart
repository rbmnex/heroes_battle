import 'enums.dart';

abstract class CardModel {
  final String id;
  final String name;
  final CardType cardType;

  const CardModel({
    required this.id,
    required this.name,
    required this.cardType,
  });
}
