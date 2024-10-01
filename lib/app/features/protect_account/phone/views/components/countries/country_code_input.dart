// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/constants/countries.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class CountryCodeInput extends StatelessWidget {
  const CountryCodeInput({required this.country, super.key, this.onTap});

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
            children: [
              Text(
                country.flag,
                style: TextStyle(fontSize: 24.0.s),
              ),
              SizedBox(width: 8.0.s),
              Assets.svg.iconLoginDropdown.icon(
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
