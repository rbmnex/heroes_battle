# Heroes Battle: AI Agent Instructions

## Project Overview
**Heroes Battle** is a turn-based card game engine (Dart/Flutter library, not a UI). Core focus: deck management, multi-hero combat with swift combo mechanics, and reaction-based defense.

**Dependency Status**: Minimal (`flutter_test` for testing, `cupertino_icons` for UI; no third-party game engines).

## Architecture Overview

### Core Domain Layer (`lib/core/`)
Immutable data models, zero business logic:
- **`hero.dart`**: Combat unit; single `hp` int, `hasAttackedThisTurn` flag, optional `equippedItem`
- **`card.dart`**: Card model with `CardType` enum; optional fields vary by type (e.g., `attackCategory`, `itemType`)
- **`player.dart`**: Deck manager; `deck`, `hand`, `discardPile` lists; auto-recycles discard → deck when empty
- **`enums.dart`**: `CardType` (attack, buff, reaction, item), `AttackType` (normal, heavy, swift), `AttackCategory` (melee, range, magic), `ReactionType` (block, evade, shield, counter)
- **`item.dart`**, **`reaction.dart`**: Subclasses of `CardModel` for type-safe attributes

### Engine Layer (`lib/engine/`)
Stateful validation + rule enforcement; each engine tracks local turn state:
- **`game_engine.dart`**: Turn manager (draw phase, hero reset); player + opponent swap
- **`attack_engine.dart`**: Multi-phase attack orchestration: validate → combo → damage → per-defender reactions
- **`swift_combo_engine.dart`**: Stateful combo tracker (`_comboUsedThisTurn`, `_nonSwiftAttackUsed`); validates one normal/heavy + unlimited swift per turn
- **`reaction_engine.dart`**: Damage modifier application (counter, evade, shield, block in order)
- **`reaction_result.dart`**: Output struct (damage multiplier, negation, reflected damage)

## Critical Design Patterns

### 1. Attack Resolution (Four Phases)
In `AttackEngine.performAttack()`:
1. **Validate** via `SwiftComboEngine.validateAttackSequence()` → throws on illegal combos
2. **Resolve combo** via `SwiftComboEngine.resolveAttack()` → returns `AttackResolution` with `comboTriggered` flag
3. **Expand targets** if combo → category-specific target expansion (range: 2 targets; melee: all; magic: all)
4. **Apply reaction** per defender via `ReactionEngine.resolveReaction()` → modifies damage via `ReactionResult`

**Critical rule**: Exactly ONE normal/heavy attack per turn (`_nonSwiftAttackUsed` flag blocks repeats). Swift attacks unlimited.

### 2. Swift Combo Mechanic (Stateful Per-Hero)
- **Combo** triggered when: `swiftCount > 0 && baseAttack != swift && !_comboUsedThisTurn`
- **Effect**: Expands targets (rule varies by attack category; see `_resolveTargets()`)
- **State tracking**: `SwiftComboEngine` tracks per-turn flags; **must call `resetHeroTurn()` at turn start** to clear flags
- **Example**: Range attack (Quick Draw) normally hits 1 target → combo hits up to 2 targets

### 3. Reaction System (Per-Defender Model)
Each defender responds independently in multi-target attacks:
```dart
_resolveAttackOnDefender(
  attacker, defender, attackCard, baseDamage, 
  reaction: reactions[defender.id],   // Defender's choice
  counter: counters[defender.id]      // Attacker's counter
)
```
Resolution order: **counter** (50% reflected) → **evade** (negates) → **shield** (negates magic only) → **block** (50% reduction, physical only)

### 4. Deck Recycling (Automatic)
`Player.drawCards()` auto-recycles: empty deck → discard shuffled back in. No API call needed; just call `drawCards()` and let it handle underflow.

## Common Developer Tasks

### Adding a New Card Type
1. Add `CardType` enum to `enums.dart` (e.g., `spell`)
2. Add optional fields to `CardModel` for new card attributes (use `?` for optional)
3. If combat-relevant: update `attack_engine.dart` or `reaction_engine.dart` to handle resolution

### Adding a New Reaction Type (Defense Mechanic)
1. Add `ReactionType` enum variant to `enums.dart`
2. Implement logic in `ReactionEngine.resolveReaction()` 
3. Update resolution order comment if it changes the 4-phase sequence
4. Test with `SwiftComboEngine` state interactions (reactions shouldn't override combo flags)

### Modifying Attack Damage Formula
- Edit `_calculateBaseDamage()` in `attack_engine.dart` (returns `int`)
- **Important**: Damage multipliers/negation happens in `reaction_engine.dart`, not here
- After formula change, test combo expansion still triggers correctly

### Creating Test Cases
Engines are independently testable; no test directory structure yet:
```dart
// Example: Test swift combo blocking second attack
final attacker = HeroModel(id: '1', name: 'Hero', hp: 100);
final engine = AttackEngine();
engine.resetHeroTurn();
engine.performAttack(attacker, defenders, [normalCard], {}, {});
// This should throw: "Non-swift attack already used this turn"
engine.performAttack(attacker, defenders, [heavyCard], {}, {});
```

### Debugging Combo Failures
If combo isn't triggering when expected:
1. Check `SwiftComboEngine.resetTurn()` called before attack
2. Verify `swiftCount > 0` in card list
3. Verify base attack is NOT swift type
4. Verify `_comboUsedThisTurn` isn't already true

## Build & Run Commands
```bash
flutter pub get       # Install dependencies
flutter run          # Run on default device/emulator
flutter analyze      # Lint analysis (uses analysis_options.yaml)
flutter test         # Run test suite (when test files added)
```

## Key File Locations
| Component | File |
|-----------|------|
| Game initialization | `lib/engine/game_engine.dart` |
| Attack orchestration | `lib/engine/attack_engine.dart` |
| Combo validation & state | `lib/engine/swift_combo_engine.dart` |
| Reaction/defense logic | `lib/engine/reaction_engine.dart` |
| Card & hero models | `lib/core/card.dart`, `lib/core/hero.dart` |
| Game constants | `lib/core/enums.dart` |
| Deck/hand management | `lib/core/player.dart` |

## Constraints & Edge Cases
1. **Multi-target attacks** require reaction from each defender independently
2. **Equipment** (one per hero) is tracked in `HeroModel.equippedItem`
3. **Turn state** resets via `GameEngine.startTurn()` which refills hand and resets `hasAttackedThisTurn` on all heroes
4. **No persistent state** between games — instantiate new `GameEngine` per match
5. **Turn ordering**: Must call `resetHeroTurn()` on `AttackEngine` before first attack each hero turn
6. **Combo one-per-turn**: `_comboUsedThisTurn` flag prevents duplicate combos even across multiple attacks

## Dart/Flutter Conventions Used
- Immutable models preferred (use `const` constructor where possible)
- Private methods prefixed with `_` (e.g., `_calculateBaseDamage`)
- Enums for all constant values
- No state management library (pure Dart classes); add later if UI layer grows
