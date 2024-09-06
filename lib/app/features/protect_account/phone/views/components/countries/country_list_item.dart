import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/constants/countries.dart';
import 'package:ice/app/extensions/extensions.dart';

class CountryListItem extends StatelessWidget {
  const CountryListItem({
    super.key,
    required this.country,
    required this.onTap,
  });

  final Country country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextThemes;
    final colors = context.theme.appColors;

    return GestureDetector(
      onTap: onTap,
      child: ScreenSideOffset.small(
        child: SizedBox(
          height: 40.0.s,
          child: Row(
            children: [
              Text(
                country.flag,
                style: TextStyle(fontSize: 21.0.s),
              ),
              SizedBox(width: 16.0.s),
              Expanded(
                child: Text(
                  country.name,
                  style: textTheme.subtitle2.copyWith(
                    color: colors.primaryText,
                  ),
                ),
              ),
              Text(
                country.iddCode,
                style: textTheme.subtitle2.copyWith(
                  color: colors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
