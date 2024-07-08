import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/rounded_card/card.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class NftName extends HookConsumerWidget {
  const NftName({
    required this.name,
    required this.rank,
    required this.price,
    required this.networkSymbol,
    required this.networkSymbolIcon,
    super.key,
  });

  final String? name;
  final int? rank;
  final double? price;
  final String? networkSymbol;
  final Widget? networkSymbolIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RoundedCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 4.0.s),
                child: Text(
                  name ?? '',
                  maxLines: 2,
                  style: context.theme.appTextThemes.subtitle.copyWith(
                    color: context.theme.appColors.primaryText,
                  ),
                ),
              ),
              Text(
                '#${rank ?? ''}',
                style: context.theme.appTextThemes.subtitle2.copyWith(
                  color: context.theme.appColors.tertararyText,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.0.s),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (networkSymbolIcon != null)
                  Padding(
                    padding: EdgeInsets.only(right: 5.0.s, top: 2.0.s),
                    child: networkSymbolIcon,
                  ),
                Padding(
                  padding: EdgeInsets.only(right: 4.0.s),
                  child: Text(
                    '${price ?? ''}',
                    style: context.theme.appTextThemes.subtitle2.copyWith(
                      color: context.theme.appColors.primaryText,
                    ),
                  ),
                ),
                Text(
                  networkSymbol ?? '',
                  style: context.theme.appTextThemes.subtitle2.copyWith(
                    color: context.theme.appColors.tertararyText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
