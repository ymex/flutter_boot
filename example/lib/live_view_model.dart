import 'package:flutter/material.dart';
import 'package:flutter_boot/core.dart';

class CounterEntity {
  CounterEntity({required this.num, required this.color});

  int num;
  Color color;
}

class CounterViewModel extends ViewModel {
  CounterViewModel();

  late var stateCounter =
      useState(CounterEntity(num: 0, color: Colors.red), true);

  // late var stateCounter =
  //     CounterEntity(num: 0, color: Colors.red).liveData(scope: this);

  void incrementCounter() {
    setState<CounterEntity>(stateCounter, (v) {
      stateCounter.value.num = v.num + 1;
    });

    //或 useState（notify = true ）时
    // stateCounter.state =
    //     CounterEntity(num: stateCounter.state.num + 1, color: Colors.black);
  }
}
