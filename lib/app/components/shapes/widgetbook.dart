// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/shapes/hexagon_path.dart';
import 'package:ion/app/components/shapes/shape.dart';
import 'package:ion/app/components/shapes/triangle_path.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'regular',
  type: ShapeBuilder,
)
Widget regularShapeBuilderUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomPaint(
            size: Size(70.0.s, 50.0.s),
            painter: ShapePainter(
              TriangleShapeBuilder(),
              color: context.theme.appColors.primaryText,
            ),
          ),
          CustomPaint(
            size: Size(70.0.s, 70.0.s),
            painter: ShapePainter(
              HexagonShapeBuilder(),
              color: context.theme.appColors.primaryText,
            ),
          ),
        ],
      ),
    ),
  );
}
