import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/select_country/countries.dart';
import 'package:ice/generated/assets.gen.dart';

class CountryCodeInput extends StatelessWidget {
  const CountryCodeInput({super.key, required this.country, this.onTap});

  final Country country;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            country.flag,
            style: const TextStyle(fontSize: 30),
          ),
          const SizedBox(width: 8),
          Image.asset(
            Assets.images.loginDropdown.path,
            color: context.theme.appColors.secondaryText,
            width: 15,
            height: 15,
          ),
        ],
      ),
    );
  }
}
