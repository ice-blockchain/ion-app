import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/creator_list_item.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/mocked_creators.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class DiscoverCreators extends IceSimplePage {
  const DiscoverCreators(super.route, super.payload, {super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, void payload) {
    final authState = ref.watch(authProvider);

    final followedCreators = useState<Set<User>>(<User>{});

    final mayContinue = followedCreators.value.isNotEmpty;

    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: UiSize.large),
            child: AuthHeader(
              title: context.i18n.discover_creators_title,
              description: context.i18n.discover_creators_description,
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList.separated(
                  separatorBuilder: (BuildContext _, int __) => SizedBox(
                    height: UiSize.small,
                  ),
                  itemCount: creators.length,
                  itemBuilder: (BuildContext context, int index) {
                    final creator = creators[index];
                    final followed = followedCreators.value.contains(creator);

                    return CreatorListItem(
                      creator: creator,
                      followed: followed,
                      onPressed: () {
                        final newFollowedCreators =
                            Set<User>.from(followedCreators.value);
                        if (followed) {
                          newFollowedCreators.remove(creator);
                        } else {
                          newFollowedCreators.add(creator);
                        }
                        followedCreators.value = newFollowedCreators;
                      },
                    );
                  },
                ),
                // TODO add ScreenBottomOffset.sliver factory for this case
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: UiSize.large +
                        (mayContinue
                            ? 0
                            : MediaQuery.paddingOf(context).bottom),
                  ),
                ),
              ],
            ),
          ),
          if (mayContinue)
            ScreenSideOffset.small(
              child: Padding(
                padding: EdgeInsets.only(
                  top: UiSize.small,
                  bottom: UiSize.large + MediaQuery.paddingOf(context).bottom,
                ),
                child: Button(
                  disabled: authState is AuthenticationLoading,
                  trailingIcon: authState is AuthenticationLoading
                      ? const ButtonLoadingIndicator()
                      : null,
                  label: Text(context.i18n.button_continue),
                  mainAxisSize: MainAxisSize.max,
                  onPressed: () {
                    ref
                        .read(authProvider.notifier)
                        .signIn(email: 'foo@bar.baz', password: '123');
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
