import 'package:flutter/material.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/components/shapes/hexagon_path.dart';
import 'package:ice/app/components/shapes/shape.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'regular',
  type: Avatar,
)
Widget regularButtonUseCase(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Avatar(
          size: 200.0.s,
          badge: Positioned(
              right: 0, bottom: 0, child: Container(width: 20, height: 20, color: Colors.amber)),
          imageUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
        ),
        Avatar(
          size: 200.0.s,
          imageWidget: Assets.images.bg.bgWalletOpensea.image(width: 20, height: 20),
        ),
        Avatar(
          size: 200.0.s,
          imageUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
        ),
        ClipPath(
          clipper: ShapeClipper(HexagonShapeBuilder(borderRadius: 40)),
          child: Avatar(
            size: 200.0.s,
            imageUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
          ),
        )
      ],
    ),
  );
}
