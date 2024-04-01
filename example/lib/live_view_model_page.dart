import 'package:flutter/material.dart';
import 'package:flutter_boot/chain.dart';
import 'package:flutter_boot/core.dart';
import 'package:flutter_boot/kits.dart';

import 'live_view_model.dart';

class LiveViewModelPage extends StatefulWidget {
  const LiveViewModelPage({super.key, required this.title});

  final String title;

  @override
  State<LiveViewModelPage> createState() => _LiveViewModelPageState();
}

// 混入 ViewModelScope
class _LiveViewModelPageState extends State<LiveViewModelPage>
    with ViewModelStateScope {
  var viewModel = CounterViewModel();

  @override
  List<ViewModel> useViewModels() {
    return [viewModel];
  }

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

            // 可观察多个状态变化 ， 如果仅观察一个，可使用 LiveDataBuilder
            MultiLiveDataBuilder(
                //状态，要观察的 view model 的状态
                observe: [viewModel.stateCounter],
                builder: (context, child) {
                  logI("----------------:${viewModel.stateCounter.value.num}");
                  var counterValue = viewModel.stateCounter.value;

                  return Column(
                    children: [
                      Text(
                        // 计数
                        '${counterValue.num}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: counterValue.color),
                      ),
                    ],
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
