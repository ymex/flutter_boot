import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boot/lifecycle.dart';

import 'live_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Boot'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// 混入 ViewModelScope
class _MyHomePageState extends State<MyHomePage> with ViewModelScope {
  late var viewModel = CounterViewModel(this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '基于ViewModel的计数器，当前计数:',
            ),
            const SizedBox(
              height: 8,
            ),
            // 可观察多个状态变化 ， 如果仅观察一个，可使用 ViewModelSingleStateBuilder
            ViewModelStateBuilder(
                //状态，要观察的 view model 的状态
                state: [viewModel.stateCounter],
                builder: (context, child) {
                  var counterValue = viewModel.stateCounter.value;

                  return Text(
                    // 计数
                    '${counterValue.num}',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: counterValue.color),
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          viewModel.incrementCounter();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
