import 'enums.dart';

extension JobClassX on JobClass {
  bool get isPhysical =>
      this == JobClass.melee || this == JobClass.ranged;

  bool get isMagic =>
      this == JobClass.mage;

  bool get isSupport =>
      this == JobClass.support;
}
