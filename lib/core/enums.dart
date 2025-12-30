enum CardType {
  attack,
  buff,
  reaction,
  item,
}

enum AttackCategory {
  melee,
  range,
  magic,
}

enum AttackType {
  normal,
  heavy,
  swift,
}

enum TargetType {
  single,
  multi,
  area,
}

enum StatusType {
  burn,      // HP loss each turn
  bleed,    // HP loss when acting
  stun,     // Skip action phase
  shielded, // Temporary damage reduction
  poison,   // HP loss each turn, cannot be cured
  
}

enum TurnPhase {
  draw,
  item,
  action,
  end,
}

enum BuffType {
  attackUp,    // +X damage
  defenseUp,   // reduce incoming damage
  swiftPlus,   // extra Swift combo allowance
}

enum ItemType {
  consumable,
  equipment,
}

enum ItemEffectType {
  heal,
  cure,
  buff,
}

enum ReactionType {
  block,
  evade,
  shield,
  counter,
}

enum JobClass {
  melee,
  ranged,
  mage,
  support,
}

