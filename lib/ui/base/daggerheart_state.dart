import 'package:daggerheart_game_master_companion/ui/base/view_model.dart';
import 'package:flutter/material.dart';

abstract class DaggerheartState<T extends StatefulWidget, VM extends ViewModel> extends State<T> implements EventObserver {
  VM viewModel;
  late BaseState _state;

  @override
  BaseState get state {
    return _state;
  }

  @override
  set state(BaseState state) {
    setState(() {
      _state = state;
    });
  }

  DaggerheartState(this.viewModel) {
    _state = viewModel.initialState;
  }

  @override
  void initState() {
    viewModel.subscribe(this);
    super.initState();
  }

  @override
  void dispose() {
    viewModel.unsubscribe(this);
    super.dispose();
  }
}
