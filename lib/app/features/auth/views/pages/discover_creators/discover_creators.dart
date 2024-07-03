import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/components/template/my_ice_page.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/creator_list_item.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/mocked_creators.dart';
import 'package:ice/app/features/core/providers/permissions_provider.dart';
import 'package:ice/app/features/core/providers/permissions_provider_selectors.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class DiscoverCreators extends IcePage {
  const DiscoverCreators({super.key});

  // const DiscoverCreators(super.route, super.payload, {super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    final hasNotificationsPermission =
        hasPermissionSelector(ref, PermissionType.Notifications);

    final followedCreators = useState<Set<User>>(<User>{});

    final mayContinue = followedCreators.value.isNotEmpty;

    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 16.0.s),
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
                    height: 8.0.s,
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
                    bottom: 16.0.s +
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
                  top: 8.0.s,
                  bottom: 16.0.s + MediaQuery.paddingOf(context).bottom,
                ),
                child: Button(
                  disabled: authState is AuthenticationLoading,
                  trailingIcon: authState is AuthenticationLoading
                      ? const ButtonLoadingIndicator()
                      : null,
                  label: Text(context.i18n.button_continue),
                  mainAxisSize: MainAxisSize.max,
                  onPressed: () {
                    if (hasNotificationsPermission.falseOrValue) {
                      ref
                          .read(authProvider.notifier)
                          .signIn(email: 'foo@bar.baz', password: '123');
                    } else {
                      IceRoutes.notifications.go(context);
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
