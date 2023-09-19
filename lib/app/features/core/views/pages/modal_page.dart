import 'package:flutter/material.dart';

class ModalPage extends StatelessWidget {
  const ModalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Column(
        children: <Widget>[
          Center(
            child: Text("I'm modal"),
          ),
        ],
      ),
    );
  }
}
