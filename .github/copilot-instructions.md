# Heroes Battle: AI Agent Instructions

## Project Overview
**Heroes Battle** is a turn-based card game engine built with Flutter/Dart. It's a game simulation library (not a full UI yet) focused on core game mechanics: deck management, hero combat with combo systems, and reactive defense mechanics.

## Architecture Overview

### Core Domain Layer (`lib/core/`)
Pure data models with no business logic:
- **`hero.dart`**: Individual combatant; tracks `hp`, `hasAttackedThisTurn`, equipment
- **`card.dart`**: Polymorphic card type (attack, buff, reaction, item) with optional attributes by type
- **`player.dart`**: Manages deck, hand, discard pile; implements deck recycling and card drawing
- **`enums.dart`**: All game constants (CardType, AttackCategory, AttackType, TargetType, ReactionType)
- **`reaction.dart`**: Defensive response cards

### Engine Layer (`lib/engine/`)
Stateful game logic engines that orchestrate rules:
- **`game_engine.dart`**: Top-level turn management; initializes players, manages active/opponent switching
- **`attack_engine.dart`**: Multi-step attack resolution (swiftness, targets, damage, reactions)
- **`swift_combo_engine.dart`**: Combo validation and triggering (swift cards + normal/heavy cards = multi-target bonus)
- **`reaction_engine.dart`**: Defense outcome calculation (block, evade, shield, counter mechanics)
- **`item_engine.dart`** & **`reaction_result.dart`**: Equipment and damage resolution helpers

## Critical Design Patterns

### 1. Attack Resolution Pipeline
Attacks are multi-phase, resolved in `attack_engine.dart`:
```
validateSequence → resolveCombo → calculateDamage → resolvePerDefender
```
Each phase is a separate method. **Key rule**: Only ONE normal/heavy attack per turn, but unlimited swift attacks (swift + normal = combo triggering multi-target).

### 2. Reaction System (Per-Defender)
Reactions are applied **per defender** in a multi-target attack. Each defender can have:
- `reaction` (defender's choice) - block, evade, shield
- `counter` (attacker's response)

Resolution order in `reaction_engine.dart`: counter → evade → shield → block

### 3. Swift Combo Mechanic
- **Combo** = swift card(s) + one normal/heavy card in same attack
- Triggers target expansion (e.g., range attacks hit 2 targets instead of 1)
- Tracked per-hero per-turn via `SwiftComboEngine._comboUsedThisTurn`

### 4. Deck Recycling
When deck runs empty, `discardPile` is shuffled back into `deck`. This happens automatically in `Player.drawCards()`.

## Common Developer Tasks

### Adding a New Card Type
1. Add enum to `enums.dart` (e.g., `CardType.buff`)
2. Extend `CardModel` optional fields if needed (see `attackCategory`, `itemType`)
3. If it affects combat, add resolution logic to appropriate engine

### Modifying Attack Damage Formula
- `attack_engine.dart`: `_calculateBaseDamage()` method
- After calculation, damage flows through `reaction_engine.dart` for modifier application

### Adding a New Reaction Type
1. Add `ReactionType` enum variant in `enums.dart`
2. Implement resolution in `ReactionEngine.resolveReaction()`
3. Update `_resolveAttackOnDefender()` in `attack_engine.dart` to pass reactions correctly

### Testing Game Logic
No test file structure yet, but engines are independently testable:
- `GameEngine` can be instantiated with mock players
- `AttackEngine.performAttack()` validates attack legality before execution
- `SwiftComboEngine.validateAttackSequence()` throws on rule violations

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
| Game state | `lib/core/player.dart`, `lib/engine/game_engine.dart` |
| Combat rules | `lib/engine/attack_engine.dart`, `lib/engine/swift_combo_engine.dart` |
| Damage/reactions | `lib/engine/reaction_engine.dart` |
| Card definitions | `lib/core/enums.dart`, `lib/core/card.dart` |

## Constraints & Edge Cases
1. **Multi-target attacks** require reaction from each defender independently
2. **Equipment** (one per hero) is tracked in `HeroModel.equippedItem`
3. **Turn state** resets via `startTurn()` which refills hand and resets `hasAttackedThisTurn`
4. **No persistent state** between games — instantiate new `GameEngine` per match

## Dart/Flutter Conventions Used
- Immutable models preferred (use `const` constructor where possible)
- Private methods prefixed with `_` (e.g., `_calculateBaseDamage`)
- Enums for all constant values
- No state management library (pure Dart classes); add later if UI layer grows
