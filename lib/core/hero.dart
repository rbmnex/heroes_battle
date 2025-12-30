import 'card.dart';
import 'item.dart';
import '../model/status_effect.dart';
import '../model/buff_effect.dart';

class HeroModel {
  final String id;
  final String name;
  int hp;

  bool hasAttackedThisTurn = false;
  CardModel? equipment;
  ItemCard? equippedItem;

  int currentHp;
  bool isStunned = false;

  List<StatusEffect> statusEffects = [];
  List<BuffEffect> buffs = [];

  HeroModel({
    required this.id,
    required this.name,
    required this.hp,
    required this.currentHp,
  });

  bool get isAlive => hp > 0;

  void resetTurn() {
    hasAttackedThisTurn = false;
  }
}
