import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_apps.dart';

class FeaturedCollection extends StatelessWidget {
  const FeaturedCollection({super.key, required this.items});

  final List<DAppItem> items;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double itemWidth = screenWidth * 0.64;
    final double itemHeight = itemWidth * 0.66;

    return SizedBox(
      height: itemHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final double leftOffset = index == 0 ? 16.0 : 8.0;
          final double rightOffset = index == items.length - 1 ? 16.0 : 8.0;
          final String assetBg = items[index].backgroundImage ?? '';
          return Container(
            width: itemWidth,
            margin: EdgeInsets.only(right: rightOffset, left: leftOffset),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(
                  assetBg,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  bottom: 14,
                  left: 14,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          items[index].iconImage,
                          width: 30,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 36,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              items[index].title,
                              style: context.theme.appTextThemes.body
                                  .copyWith(
                                    color: context
                                        .theme.appColors.secondaryBackground,
                                  )
                                  .merge(shadowStyle),
                            ),
                            Text(
                              items[index].description ?? '',
                              style: context.theme.appTextThemes.caption3
                                  .copyWith(
                                    color: context
                                        .theme.appColors.secondaryBackground,
                                  )
                                  .merge(shadowStyle),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
