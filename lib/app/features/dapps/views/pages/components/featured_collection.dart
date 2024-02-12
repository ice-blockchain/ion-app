import 'package:flutter/material.dart';
import 'package:ice/app/components/shadow_text/shadow_text.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
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
          final double leftOffset = index == 0 ? 16.s : 8.s;
          final double rightOffset = index == items.length - 1 ? 16.s : 8.s;
          final String assetBg = items[index].backgroundImage ?? '';
          return Container(
            width: itemWidth,
            margin: EdgeInsets.only(right: rightOffset, left: leftOffset),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.s),
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
                  bottom: 14.s,
                  left: 14.s,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.s),
                        ),
                        child: Image.asset(
                          items[index].iconImage,
                          width: 30.s,
                        ),
                      ),
                      SizedBox(width: 8.s),
                      SizedBox(
                        height: 36.s,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ShadowText(
                              child: Text(
                                items[index].title,
                                style:
                                    context.theme.appTextThemes.body.copyWith(
                                  color: context
                                      .theme.appColors.secondaryBackground,
                                ),
                              ),
                            ),
                            ShadowText(
                              child: Text(
                                items[index].description ?? '',
                                style: context.theme.appTextThemes.caption3
                                    .copyWith(
                                  color: context
                                      .theme.appColors.secondaryBackground,
                                ),
                              ),
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
