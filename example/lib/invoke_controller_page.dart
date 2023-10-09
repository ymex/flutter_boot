import 'package:flutter/material.dart';
import 'package:flutter_boot/architecture.dart';

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
                    controller.invoke("onMc", "from FilledButton!");
                  },
                  child: const Text("Invoke")),
              StateChangeWidget(
                controller: controller,
              )
            ],
          ),
        ));
  }
}

class StateChangeWidget extends StatefulInvokerWidget {
  const StateChangeWidget({super.key, required super.controller});

  @override
  State<StateChangeWidget> createState() => _StateChangeWidgetState();
}

class _StateChangeWidgetState extends State<StateChangeWidget>
    with StateInvokerMinix {

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
      color: Colors.blue,
      width: 200,
      height: 200,
      child: Center(
        child: Text(message),
      ),
    );
  }
}
