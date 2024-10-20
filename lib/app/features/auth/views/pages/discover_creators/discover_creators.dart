// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/ice_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/content_creators_provider.dart';
import 'package:ion/app/features/auth/providers/onboarding_complete_notifier.dart';
import 'package:ion/app/features/auth/providers/onboarding_data_provider.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ion/app/features/auth/views/pages/discover_creators/creator_list_item.dart';
import 'package:ion/app/hooks/use_selected_state.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class DiscoverCreators extends ConsumerWidget {
  const DiscoverCreators({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finishNotifier = ref.watch(onboardingCompleteNotifierProvider);
    final creatorPubkeys = ref.watch(contentCreatorsProvider);

    final (selectedCreators, toggleCreatorSelection) = useSelectedState(<String>[]);

    final mayContinue = selectedCreators.isNotEmpty;

    return SheetContent(
      body: Column(
        children: [
          Expanded(
            child: AuthScrollContainer(
              title: context.i18n.discover_creators_title,
              description: context.i18n.discover_creators_description,
              slivers: [
                SliverPadding(padding: EdgeInsets.only(top: 34.0.s)),
                SliverList.separated(
                  separatorBuilder: (BuildContext _, int __) => SizedBox(
                    height: 8.0.s,
                  ),
                  itemCount: creatorPubkeys.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CreatorListItem(
                      pubkey: creatorPubkeys[index],
                      selected: false,
                      onPressed: () {},
                    );
                  },
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: 16.0.s + (mayContinue ? 0 : MediaQuery.paddingOf(context).bottom),
                  ),
                ),
              ],
            ),
          ),
          if (mayContinue)
            Column(
              children: [
                const HorizontalSeparator(),
                SizedBox(height: 16.0.s),
                ScreenSideOffset.small(
                  child: Button(
                    disabled: finishNotifier.isLoading,
                    trailingIcon: finishNotifier.isLoading ? const IceLoadingIndicator() : null,
                    label: Text(context.i18n.button_continue),
                    mainAxisSize: MainAxisSize.max,
                    onPressed: () {
                      ref.read(onboardingDataProvider.notifier).followees = selectedCreators;
                      ref.read(onboardingCompleteNotifierProvider.notifier).finish();
                    },
                  ),
                ),
                SizedBox(height: 8.0.s + MediaQuery.paddingOf(context).bottom),
              ],
            ),
        ],
      ),
    );
  }
}
