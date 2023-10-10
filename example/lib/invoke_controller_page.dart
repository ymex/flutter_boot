import 'package:flutter/material.dart';
import 'package:flutter_boot/core.dart';

class StateControllerPage extends StatefulWidget {
  final String title;

  const StateControllerPage({super.key, required this.title});

  @override
  State<StateControllerPage> createState() => _StateControllerPageState();
}

class _StateControllerPageState extends State<StateControllerPage> {
  InvokeController controller = InvokeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: [
              FilledButton(
                  onPressed: () {
                    controller.invoke(
                        "onMc", DateTime.now().millisecond.toString());
                  },
                  child: const Text("Invoke")),
              StateChangeWidget(
                controller: controller,
                title: "SC-1",
                color: Colors.blue,
              ),
              const SizedBox(
                height: 12,
              ),
              StateChangeWidget(
                controller: controller,
                title: "SC-2",
                color: Colors.red,
              ),
            ],
          ),
        ));
  }
}

class StateChangeWidget extends StatefulInvokerWidget {
  final String title;
  final Color color;

  const StateChangeWidget(
      {super.key,
      required super.controller,
      required this.title,
      required this.color});

  @override
  State<StateChangeWidget> createState() => _StateChangeWidgetState();
}

class _StateChangeWidgetState extends State<StateChangeWidget>
    with InvokeStateMinix {
  String message = "init";

  @override
  List<MethodPair<VoidValueCallback>> useInvokes() {
    return [
      MethodPair("onMc", onMc),
    ];
  }

  void onMc(data) {
    setState(() {
      message = "$data";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      width: 200,
      height: 200,
      child: Center(
        child: Text(
          "${widget.title}:$message",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
