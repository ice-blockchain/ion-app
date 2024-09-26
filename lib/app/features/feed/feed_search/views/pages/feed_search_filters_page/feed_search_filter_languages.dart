import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class FeedSearchFilterLanguages extends StatelessWidget {
  const FeedSearchFilterLanguages({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.i18n.feed_search_filter_languages,
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.quaternaryText,
          ),
        ),
        SizedBox(height: 16.0.s),
        ListItem(
          leading: Container(
            width: 30.0.s,
            height: 30.0.s,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.theme.appColors.onSecondaryBackground,
              borderRadius: BorderRadius.all(Radius.circular(8.0.s)),
              border: Border.all(
                width: 1.0.s,
                color: context.theme.appColors.onTerararyFill,
              ),
            ),
            child: Assets.svg.iconSelectLanguage
                .icon(size: 20.0.s, color: context.theme.appColors.secondaryText),
          ),
          title: Text(context.i18n.feed_search_filter_select_languages),
          subtitle: Text(
            'English, Italian, German, Russian, Chinese, Danish, Polish',
            overflow: TextOverflow.visible,
          ),
          switchTitleStyles: true,
          trailing: Assets.svg.iconArrowRight.icon(),
          backgroundColor: context.theme.appColors.secondaryBackground,
          border: Border.all(color: context.theme.appColors.strokeElements),
        ),
      ],
    );
  }
}
