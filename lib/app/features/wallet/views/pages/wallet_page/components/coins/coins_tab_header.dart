import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';

class CoinsTabHeader extends StatelessWidget {
  const CoinsTabHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 8.0.s,
      ),
    );
  }
}
