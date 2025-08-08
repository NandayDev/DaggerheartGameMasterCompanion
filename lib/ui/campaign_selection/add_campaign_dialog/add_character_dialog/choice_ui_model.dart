class ChoiceUiModel {
  final ChoiceType type;
  final bool isEnabled;
  final bool isError;
  final ChoiceChildUiModel? selectedChild;
  final List<ChoiceChildUiModel> children;

  String get key => type.toString() + (selectedChild?.key?.toString() ?? "");

  const ChoiceUiModel({required this.type, required this.isEnabled, required this.isError, required this.selectedChild, required this.children});

  ChoiceUiModel select(ChoiceChildUiModel? selectedChild) =>
      ChoiceUiModel(type: type,
          isEnabled: isEnabled,
          isError: false,
          selectedChild: selectedChild,
          children: children);

  ChoiceUiModel enable() => ChoiceUiModel(type: type, isEnabled: true, isError: isError, selectedChild: selectedChild, children: children);

  ChoiceUiModel withError() =>
      ChoiceUiModel(type: type,
          isEnabled: isEnabled,
          isError: true,
          selectedChild: selectedChild,
          children: children);
}

class ChoiceChildUiModel {
  final dynamic key;
  final String name;

  ChoiceChildUiModel({required this.key, required this.name});
}

enum ChoiceType {
  Class,
  Subclass,
  Ancestry,
  Community,
  Agility,
  Strength,
  Finesse,
  Instinct,
  Presence,
  Knowledge,
  FirstDomainAbility,
  SecondDomainAbility,
  ThirdDomainAbility,
  Unchanged
}
