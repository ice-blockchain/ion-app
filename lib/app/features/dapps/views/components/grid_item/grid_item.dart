import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/dapps/views/components/favourite_icon/favorite_icon.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_apps.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/utils/num.dart';

class GridItem extends HookWidget {
  const GridItem({
    super.key,
    required this.item,
    this.showIsFavourite = false,
  });
  final DAppItem item;
  final bool showIsFavourite;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isFavourite = useState(item.isFavourite);
    return InkWell(
      onTap: () => IceRoutes.dappsDetails.go(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 48.0.s,
            height: 48.0.s,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0.s),
            ),
            child: Image.asset(
              item.iconImage,
              width: 48.0.s,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 10.0.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  item.title,
                  style: context.theme.appTextThemes.body.copyWith(
                    color: context.theme.appColors.primaryText,
                  ),
                ),
                Text(
                  item.description ?? '',
                  style: context.theme.appTextThemes.caption3.copyWith(
                    color: context.theme.appColors.secondaryText,
                  ),
                ),
                Text(
                  item.value != null ? formatDouble(item.value!) : '',
                  style: context.theme.appTextThemes.caption3.copyWith(
                    color: context.theme.appColors.tertararyText,
                  ),
                ),
              ],
            ),
          ),
          if (showIsFavourite)
            FavouriteIcon(
              isFavourite: isFavourite.value,
              onTap: () {
                isFavourite.value = !isFavourite.value;
              },
            ),
        ],
      ),
    );
  }
}
