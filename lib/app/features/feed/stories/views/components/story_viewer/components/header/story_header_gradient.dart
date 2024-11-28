import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class StoryHeaderGradient extends StatelessWidget {
  const StoryHeaderGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 80.0.s,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(0, 0, 0, 0.3),
              Color.fromRGBO(0, 0, 0, 0.15),
              Color.fromRGBO(0, 0, 0, 0),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}
