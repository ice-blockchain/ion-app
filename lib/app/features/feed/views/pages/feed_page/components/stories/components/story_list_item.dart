import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/components/shapes/hexagon_path.dart';
import 'package:ice/app/components/shapes/shape.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/components/plus_icon.dart';

final _borderGradients = [
  SweepGradient(
    colors: [
      Color(0xFFEF1D4F),
      Color(0xFFFF9F0E),
      Color(0xFFFFBB0E),
      Color(0xFFFF012F),
      Color(0xFFEF1D4F)
    ],
    stops: [0.0, 0.21, 0.47, 0.77, 1],
    startAngle: pi / 2,
    endAngle: pi * 5 / 2,
    tileMode: TileMode.repeated,
  ),
  SweepGradient(
    colors: [
      Color(0xFF0166FF),
      Color(0XFF00DDB5),
      Color(0XFF3800D6),
      Color(0XFF0166FF),
    ],
    stops: [0.0, 0.30, 0.72, 1],
    startAngle: pi / 2,
    endAngle: pi * 5 / 2,
    tileMode: TileMode.repeated,
  ),
  SweepGradient(
    colors: [
      Color(0xFFAE01FF),
      Color(0XFF1F00DD),
      Color(0XFF0AA7FF),
      Color(0XFFC100BA),
    ],
    stops: [0.0, 0.30, 0.72, 0.97],
    startAngle: pi / 2,
    endAngle: pi * 5 / 2,
    tileMode: TileMode.repeated,
  ),
  SweepGradient(
    colors: [
      Color(0xFF00AFA5),
      Color(0XFF1B76FF),
      Color(0XFF0AFFFF),
      Color(0XFF00C1B6),
    ],
    stops: [0.0, 0.30, 0.72, 0.97],
    startAngle: pi / 2,
    endAngle: pi * 5 / 2,
    tileMode: TileMode.repeated,
  ),
];

class StoryListItem extends StatelessWidget {
  const StoryListItem({
    required this.imageUrl,
    required this.label,
    super.key,
    this.nft = false,
    this.viewed = false,
    this.showPlus = false,
  });

  final String imageUrl;
  final String label;
  final bool nft;
  final bool viewed;
  final bool showPlus;

  static double get width => 65.0.s;

  static double get height => 91.0.s;

  static double get plusSize => 18.0.s;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                nft
                    ? ColoredBox(
                        color: Colors.amber,
                        child: CustomPaint(
                          size: Size.square(width),
                          painter: ShapePainter(
                            HexagonShapeBuilder(borderRadius: (width) / 5),
                            color: context.theme.appColors.sheetLine,
                            shader: _borderGradients[Random().nextInt(_borderGradients.length)]
                                .createShader(
                              Rect.fromCircle(
                                  center: Offset(width / 2, width / 2), radius: width / 2),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: width,
                        height: width,
                        decoration: BoxDecoration(
                          gradient: _borderGradients[Random().nextInt(_borderGradients.length)],
                          borderRadius: BorderRadius.circular(width * 0.3),
                          color: context.theme.appColors.sheetLine,
                        ),
                      ),
                Positioned(
                  top: 2,
                  left: 2,
                  right: 2,
                  child: nft
                      ? CustomPaint(
                          size: Size.square(width - 4),
                          painter: ShapePainter(
                            HexagonShapeBuilder(borderRadius: (width - 4) / 5),
                            color: Colors.white,
                          ),
                        )
                      : Container(
                          width: width - 4,
                          height: width - 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular((width - 4) * 0.3),
                            color: Colors.white,
                          ),
                        ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  left: 4,
                  child: Avatar(
                    size: width - 8,
                    imageUrl: imageUrl,
                    nft: nft,
                    borderRadius: BorderRadius.circular((width - 8) * 0.3),
                  ),
                ),
                if (showPlus)
                  Positioned(
                    bottom: -plusSize / 2,
                    child: PlusIcon(
                      size: plusSize,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0.s),
              child: Text(
                label,
                style: context.theme.appTextThemes.caption3.copyWith(
                  color: context.theme.appColors.primaryText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
