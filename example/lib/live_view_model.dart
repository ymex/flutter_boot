import 'package:flutter/material.dart';
import 'package:flutter_boot/core.dart';

class CounterEntity {
  CounterEntity({required this.num, required this.color});

  int num;
  Color color;
}

class CounterViewModel extends ViewModel {
  CounterViewModel();

  late LiveData<CounterEntity> stateCounter =
      useState(CounterEntity(num: 0, color: Colors.red));

  void incrementCounter() {
    setState<CounterEntity>(stateCounter, (value) {
      stateCounter.value.num = value.num + 1;
    });
  }
}
