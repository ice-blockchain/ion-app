import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/search_input/search_input.dart';
import 'package:ice/app/components/sheet_content/sheet_content.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/title_description_header/title_description_header.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/mocked_creators.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/generated/assets.gen.dart';

class DiscoverCreators extends IceSimplePage {
  const DiscoverCreators(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final ValueNotifier<String> searchText = useState('');

    final ValueNotifier<Set<User>> followedCreatorsNotifier =
        useState<Set<User>>(<User>{});
    final Set<User> followedCreators = followedCreatorsNotifier.value;

    final ValueNotifier<List<User>> creatorsNotifier =
        useState<List<User>>(<User>[]);

    useEffect(
      () {
        creatorsNotifier.value = creators;
        return null;
      },
      const <Object?>[],
    );

    final List<User> filteredCreators = searchText.value.isEmpty
        ? creatorsNotifier.value
        : creatorsNotifier.value.where((User creator) {
            final String searchLower = searchText.value.toLowerCase().trim();
            final String nameLower = creator.name.toLowerCase();
            final String nicknameLower = creator.nickname.toLowerCase();
            return nameLower.contains(searchLower) ||
                nicknameLower.contains(searchLower);
          }).toList();

    void handleOnTap(User creator, bool isFollowing) {
      final Set<User> newFollowedCreators = Set<User>.from(followedCreators);
      if (isFollowing) {
        newFollowedCreators.remove(creator);
      } else {
        newFollowedCreators.add(creator);
      }
      followedCreatorsNotifier.value = newFollowedCreators;
    }

    return SheetContent(
      body: Container(
        width: double.infinity,
        color: context.theme.appColors.secondaryBackground,
        child: Stack(
          children: <Widget>[
            NavigationAppBar.modal(),
            ScreenSideOffset.small(
              child: Padding(
                padding: EdgeInsets.only(
                  top: NavigationAppBar.modalHeaderHeight,
                ),
                child: Column(
                  children: <Widget>[
                    TitleDescription(
                      title: context.i18n.discover_creators_title,
                      description: context.i18n.discover_creators_description,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0.s),
                      child: SearchInput(
                        onTextChanged: (String value) =>
                            searchText.value = value,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredCreators.length,
                        itemBuilder: (BuildContext context, int index) {
                          final User creator = filteredCreators[index];
                          final bool isFollowing =
                              followedCreators.contains(creator);

                          return Container(
                            height: 66.0.s,
                            decoration: BoxDecoration(
                              color:
                                  context.theme.appColors.tertararyBackground,
                              borderRadius: BorderRadius.circular(12.0.s),
                            ),
                            margin: EdgeInsets.only(
                              bottom: 12.0.s,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0.s,
                            ),
                            child: Row(
                              children: <Widget>[
                                if (creator.imageUrl != null &&
                                    creator.imageUrl!.isNotEmpty)
                                  Container(
                                    width: 30.0.s,
                                    height: 30.0.s,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10.0.s),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.network(
                                      creator.imageUrl!,
                                      width: 30.0.s,
                                      height: 30.0.s,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                SizedBox(
                                  width: 16.0.s,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            creator.name,
                                            style: context
                                                .theme.appTextThemes.subtitle2
                                                .copyWith(
                                              color: context
                                                  .theme.appColors.primaryText,
                                            ),
                                          ),
                                          if (creator.isVerified ?? false)
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 4.0.s,
                                                top: 2.0.s,
                                              ),
                                              child: Image.asset(
                                                Assets.images.icons
                                                    .iconBadgeVerify.path,
                                                width: 16.0.s,
                                                height: 16.0.s,
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: 2.0.s),
                                      Text(
                                        creator.nickname,
                                        style: context
                                            .theme.appTextThemes.caption
                                            .copyWith(
                                          color: context
                                              .theme.appColors.tertararyText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  child: Button(
                                    onPressed: () => handleOnTap(
                                      creator,
                                      isFollowing,
                                    ),
                                    type: isFollowing
                                        ? ButtonType.primary
                                        : ButtonType.outlined,
                                    tintColor: isFollowing
                                        ? null
                                        : context.theme.appColors.primaryAccent,
                                    // TODO: check why its not working
                                    // label: Text(
                                    //   isFollowing
                                    //       ? context.i18n.button_following
                                    //       : context.i18n.button_follow,
                                    //   style: context.theme.appTextThemes.caption
                                    //       .copyWith(
                                    //     color: isFollowing
                                    //         ? context.theme.appColors
                                    //             .secondaryBackground
                                    //         : context
                                    //             .theme.appColors.primaryAccent,
                                    //   ),
                                    // ),
                                    mainAxisSize: MainAxisSize.max,
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: Size(77.0.s, 28.0.s),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.0.s,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
