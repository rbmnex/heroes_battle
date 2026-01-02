enum CardType {
  attack,
  reaction,
  buff,
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

enum ReactionType {
  block,
  parry,
  evade,
  counter,
  shield,
  deflect,
}

enum BuffType {
  attackUp,
  defenseUp,
  swiftPlus,
}

enum StatusType {
  stun,
  bleed,
  burn,
  shielded,
  poison,
  freeze,
  silence,
}

enum ItemType {
  consumable,
  equipment,
}

enum JobRole {
  melee,
  range,
  magic,
  support,
}

enum TurnPhase {
  start,
  draw,
  main,
  action,
  end,
}

