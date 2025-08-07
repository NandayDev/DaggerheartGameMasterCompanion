class ChoiceUiModel {
  final ChoiceChildUiModel? selectedChild;
  final List<ChoiceChildUiModel> children;

  ChoiceUiModel.unselected({required this.children}) : selectedChild = null;

  ChoiceUiModel.selected({required this.selectedChild, required this.children});

  ChoiceUiModel select(ChoiceChildUiModel? selectedChild) {
    return ChoiceUiModel.selected(selectedChild: selectedChild, children: children);
  }
}

class ChoiceChildUiModel {
  final String key;
  final String name;

  ChoiceChildUiModel({required this.key, required this.name});
}
