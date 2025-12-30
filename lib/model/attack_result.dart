class AttackResult {
  final bool success;
  final bool evaded;
  final int damageDealt;
  final int counterDamageTaken;

  AttackResult({
    required this.success,
    required this.evaded,
    required this.damageDealt,
    required this.counterDamageTaken,
  });

  factory AttackResult.success({
    required int damageDealt,
    required int counterDamageTaken,
  }) {
    return AttackResult(
      success: true,
      evaded: false,
      damageDealt: damageDealt,
      counterDamageTaken: counterDamageTaken,
    );
  }

  factory AttackResult.evaded() {
    return AttackResult(
      success: false,
      evaded: true,
      damageDealt: 0,
      counterDamageTaken: 0,
    );
  }

  factory AttackResult.invalid() {
    return AttackResult(
      success: false,
      evaded: false,
      damageDealt: 0,
      counterDamageTaken: 0,
    );
  }
}
