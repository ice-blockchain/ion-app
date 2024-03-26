import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/select_country/countries.dart';
import 'package:ice/generated/assets.gen.dart';

class CountryCodeInput extends StatelessWidget {
  const CountryCodeInput({super.key, required this.country, this.onTap});

  final Country country;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.0.s),
      child: TextButton(
        onPressed: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.s, vertical: 8.0.s),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                country.flag,
                style: TextStyle(fontSize: 24.0.s),
              ),
              SizedBox(width: 8.0.s),
              Assets.images.icons.iconLoginDropdown.icon(
                color: context.theme.appColors.secondaryText,
                size: 15.0.s,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
