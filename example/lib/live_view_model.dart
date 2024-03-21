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
      useState(CounterEntity(num: 0, color: Colors.red), notify: true);

  void incrementCounter() {

    setState<CounterEntity>(stateCounter, (v) {
      stateCounter.state.num = v.num + 1;
    });

    //或 useState（notify = true ）时
    // stateCounter.state =
    //     CounterEntity(num: stateCounter.state.num + 1, color: Colors.black);
  }
}
