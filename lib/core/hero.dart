import 'card.dart';
import 'item.dart';

class HeroModel {
  final String id;
  final String name;
  int hp;

  bool hasAttackedThisTurn = false;
  CardModel? equipment;
  ItemCard? equippedItem;

  HeroModel({
    required this.id,
    required this.name,
    required this.hp,
  });

  bool get isAlive => hp > 0;

  void resetTurn() {
    hasAttackedThisTurn = false;
  }
}
