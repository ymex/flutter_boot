import 'package:flutter/material.dart';
import 'package:flutter_boot/lifecycle.dart';

class CounterEntity {
  CounterEntity({required this.num, required this.color});

  int num;
  Color color;
}

class CounterViewModel extends LiveViewModel {
  CounterViewModel(super.scope);

  late ViewModelState<CounterEntity> stateCounter =
  createState(CounterEntity(num: 0, color: Colors.red));

  void incrementCounter() {
    setState<CounterEntity>(stateCounter, (value) {
      stateCounter.value.num = value.num + 1;
    });
  }
}