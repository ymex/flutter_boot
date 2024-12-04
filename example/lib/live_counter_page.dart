import 'package:flutter/material.dart';
import 'package:flutter_boot/boot.dart';
import 'package:flutter_boot/core.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key, required this.title});

  final String title;

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> with BootStateScope {
  // State 混入   LiveDataScope ， 可用 useState(), 可省去注销。
  late LiveData<int> liveCounter = useLiveState(0);

  //  LiveData<int?> liveMM = LiveData.useState();
  // var liveCounter = 0.state();

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
              '基于LiveData的计数器，当前计数:',
            ),
            const SizedBox(
              height: 8,
            ),
            liveCounter.watch((count) => Text('$count')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          liveCounter.setState((v) {
            liveCounter.value = v + 1;
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
