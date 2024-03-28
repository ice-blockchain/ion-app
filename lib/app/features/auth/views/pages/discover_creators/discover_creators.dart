import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/title_description_header/title_description_header.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/creator_list_item.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/mocked_creators.dart';
import 'package:ice/app/router/components/floating_app_bar/floating_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class DiscoverCreators extends IceSimplePage {
  const DiscoverCreators(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final ValueNotifier<String> searchText = useState('');

    final ValueNotifier<Set<User>> followedCreators =
        useState<Set<User>>(<User>{});

    final List<User> filteredCreators = searchText.value.isEmpty
        ? creators
        : creators.where((User creator) {
            final String searchLower = searchText.value.toLowerCase().trim();
            final String nameLower = creator.name.toLowerCase();
            final String nicknameLower = creator.nickname.toLowerCase();
            return nameLower.contains(searchLower) ||
                nicknameLower.contains(searchLower);
          }).toList();

    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: Column(
        children: <Widget>[
          NavigationAppBar.modal(),
          TitleDescription(
            title: context.i18n.discover_creators_title,
            description: context.i18n.discover_creators_description,
          ),
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                FloatingAppBar(
                  height: SearchInput.height,
                  child: ScreenSideOffset.small(
                    child: SearchInput(
                      onTextChanged: (String value) => searchText.value = value,
                    ),
                  ),
                ),
                SliverList.separated(
                  separatorBuilder: (BuildContext _, int __) => SizedBox(
                    height: 8.0.s,
                  ),
                  itemCount: filteredCreators.length,
                  itemBuilder: (BuildContext context, int index) {
                    final User creator = filteredCreators[index];
                    final bool followed =
                        followedCreators.value.contains(creator);

                    return CreatorListItem(
                      creator: creator,
                      followed: followed,
                      onPressed: () {
                        final Set<User> newFollowedCreators =
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
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: 16.0.s + MediaQuery.paddingOf(context).bottom,
                  ),
                ),
              ],
            ),
          ),
          if (followedCreators.value.isNotEmpty)
            ScreenSideOffset.small(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 8.0.s,
                  bottom: 16.0.s + MediaQuery.paddingOf(context).bottom,
                ),
                child: Button(
                  label: Text(context.i18n.button_continue),
                  mainAxisSize: MainAxisSize.max,
                  onPressed: () {},
                ),
              ),
            ),
        ],
      ),
    );
  }
}
