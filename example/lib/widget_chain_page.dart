import 'package:flutter/material.dart';
import 'package:flutter_boot/chain.dart';
import 'package:flutter_boot/kits.dart';

class WidgetChainPage extends StatefulWidget {
  final String title;

  const WidgetChainPage({super.key, required this.title});

  @override
  State<WidgetChainPage> createState() => _WidgetChainPageState();
}

class _WidgetChainPageState extends State<WidgetChainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          """Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () => logI("----点击"),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Text("假如我是文本按钮"),
              ),
            ),
          )""".text(style: const TextStyle(color: Colors.green)),
          12.verticalSpace,
          "以上代码转为链接调用".text(style: 14.textStyle(color: Colors.red)),
          12.verticalSpace,
          """"假如我是文本按钮"
              .text()
              .padding(const EdgeInsets.all(8))
              .gestureDetector(onTap: () => logI("----点击"))
              .expanded(1),""".text(style: const TextStyle(color: Colors.green)),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () => logI("----点击"),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Text("假如我是文本按钮"),
              ),
            ),
          ),

          24.verticalSpace, // 等同 SizedBox(height: 24,),

          //链式调用，减少嵌套。
          "假如我是文本按钮"
              .text()
              .padding(const EdgeInsets.all(8))
              .gestureDetector(onTap: () => logI("----点击"))
              .expanded(1),
        ],
      ),
    );
  }
}
