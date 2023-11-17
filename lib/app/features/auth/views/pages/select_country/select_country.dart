import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/select_country/countries.dart';
import 'package:ice/app/shared/widgets/navigation_header/navigation_header.dart';

class SelectCountries extends HookConsumerWidget {
  const SelectCountries({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: context.theme.appColors.secondaryBackground,
        child: Stack(
          children: <Widget>[
            const NavigationHeader(title: 'Select country'),
            Padding(
              padding: const EdgeInsets.only(top: navigationHeaderHeight),
              child: ListView.builder(
                itemCount: countries.length,
                itemBuilder: (BuildContext context, int index) {
                  final Country country = countries[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: <Widget>[
                          Text(
                            country.flag,
                            style: context.theme.appTextThemes.subtitle2,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Text(
                              country.name,
                              style: context.theme.appTextThemes.subtitle2
                                  .copyWith(
                                color: context.theme.appColors.primaryText,
                              ),
                            ),
                          ),
                          Text(
                            country.iddCode,
                            style:
                                context.theme.appTextThemes.subtitle2.copyWith(
                              color: context.theme.appColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
