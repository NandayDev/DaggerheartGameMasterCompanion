abstract class ViewModel {
  final List<EventObserver> _observerList = List.empty(growable: true);

  ViewModel() {
    currentState = initialState;
  }

  void subscribe(EventObserver o) {
    if (_observerList.contains(o)) return;
    _observerList.add(o);
  }

  void unsubscribe(EventObserver o) {
    _observerList.remove(o);
  }

  void notify(BaseState state) {
    currentState = state;
    for (var element in _observerList) {
      element.state = state;
    }
  }

  BaseState initialState = BaseState(isLoading: true);
  late BaseState currentState;
}

abstract class EventObserver {
  abstract BaseState state;
}

class BaseState {
  final bool isLoading;

  const BaseState({required this.isLoading});
}
