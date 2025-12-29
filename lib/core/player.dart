import 'card.dart';
import 'hero.dart';

class Player {
  final String id;
  final List<HeroModel> heroes;

  List<CardModel> deck;
  List<CardModel> hand = [];
  List<CardModel> discardPile = [];

  Player({
    required this.id,
    required this.heroes,
    required this.deck,
  });

  void drawCards(int count) {
    for (int i = 0; i < count; i++) {
      if (deck.isEmpty) {
        recycleDiscard();
      }
      if (deck.isNotEmpty) {
        hand.add(deck.removeAt(0));
      }
    }
  }

  void recycleDiscard() {
    deck.addAll(discardPile);
    discardPile.clear();
    deck.shuffle();
  }
}
