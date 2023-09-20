import 'package:flutter/material.dart';
import 'package:flutter_boot/widget.dart';

class HintToastDialogPage extends StatefulWidget {
  final String title;

  const HintToastDialogPage({super.key, required this.title});

  @override
  State<HintToastDialogPage> createState() => _HintPageState();
}

class _HintPageState extends State<HintToastDialogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: OverLayView(),
      // body: SimpleLoadingDialog(),
    );
  }
}

class OverLayView extends StatefulWidget {
  const OverLayView({super.key});

  @override
  State<OverLayView> createState() => _OverLayViewState();
}

class _OverLayViewState extends State<OverLayView> with HintOverlay {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [buildColumn()],
      ),
    );
  }

  Column buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Toast",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  toast("Top Toast",
                      alignment: ToastAlignment.top, duration: 3);
                },
                child: const Text("Top")),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  toast("Center Toast",
                      alignment: ToastAlignment.center, duration: 5);
                },
                child: const Text("Center")),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  toast("Flexible等组件导致的。");
                },
                child: const Text("Bottom"))
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          "Dialog",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            OutlinedButton(
                onPressed: () {
                  loading();
                },
                child: Text("Show Loading")),
            Spacer(),
            OutlinedButton(
                onPressed: () {
                  dismissLoading();
                },
                child: Text("Dismiss Loading"))
          ],
        )
      ],
    );
  }
}
