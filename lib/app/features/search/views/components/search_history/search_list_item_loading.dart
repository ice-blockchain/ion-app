// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';

class ListItemLoading extends StatelessWidget {
  const ListItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: Column(
        children: [
          Container(
            width: 65.0.s,
            height: 65.0.s,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0.s),
            ),
          ),
          SizedBox(height: 6.0.s),
          Container(
            width: 65.0.s,
            height: 34.0.s,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0.s),
            ),
          ),
        ],
      ),
    );
  }
}
