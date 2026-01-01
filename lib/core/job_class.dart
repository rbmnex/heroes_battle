import 'enums.dart';

class JobClass {
  // final String name;
  // final JobRole role;

  // final Set<AttackCategory> allowedAttackCategories;
  // final Set<ReactionType> allowedReactions;
  // final Set<BuffType> allowedBuffs;

  // const JobClass({
  //   required this.name,
  //   required this.role,
  //   required this.allowedAttackCategories,
  //   required this.allowedReactions,
  //   required this.allowedBuffs,
  // });

  final String name;
  final Set<ReactionType> allowedReactions;

  const JobClass({
    required this.name,
    required this.allowedReactions,
  });
}
