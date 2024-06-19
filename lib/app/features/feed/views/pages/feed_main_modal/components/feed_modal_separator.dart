import 'package:flutter/material.dart';

class FeedModalSeparator extends StatelessWidget {
  const FeedModalSeparator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final separatorWidth = MediaQuery.of(context).size.width;

    return Container(
      width: separatorWidth,
      height: 0.5,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.bottomCenter,
          radius: 0,
          colors: <Color>[Color(0xFFC2C2C2), Color(0x47D9D9D9)],
        ),
      ),
    );
  }
}
