import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/empty_list/empty_list.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/search_input/search_input.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/dapps/views/categories/apps/apps.dart';
import 'package:ice/app/features/dapps/views/components/grid_item/grid_item.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_apps.dart';
import 'package:ice/app/router/views/navigation_app_bar.dart';
import 'package:ice/generated/assets.gen.dart';

class DAppsList extends IcePage<AppsRouteData> {
  const DAppsList(super.route, super.payload);

  @override
  Widget buildPage(
    BuildContext context,
    WidgetRef ref,
    AppsRouteData? payload,
  ) {
    final ValueNotifier<String> searchText = useState('');
    final List<DAppItem> items = payload?.items ?? <DAppItem>[];

    final List<DAppItem> filteredApps = searchText.value.isEmpty
        ? items
        : items.where((DAppItem app) {
            final String searchLower = searchText.value.toLowerCase().trim();
            final String titleLower = app.title.toLowerCase();

            return titleLower.contains(searchLower);
          }).toList();

    return Scaffold(
      appBar: NavigationAppBar.screen(
        title: payload?.title ?? '',
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: ScreenSideOffset.small(
              child: Column(
                children: <Widget>[
                  if (payload?.isSearchVisible == true)
                    SearchInput(
                      onTextChanged: (String value) => searchText.value = value,
                    ),
                  Expanded(
                    child: Container(
                      child: items.isEmpty
                          ? EmptyList(
                              icon: Assets.images.misc.dappsEmpty
                                  .image(width: 48.0.s, height: 48.0.s),
                              title: context.i18n.dapps_favourites_empty_title,
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(
                                vertical: 12.0.s,
                              ),
                              itemCount: filteredApps.length,
                              itemBuilder: (BuildContext context, int index) {
                                final DAppItem app = filteredApps[index];
                                return GridItem(
                                  item: app,
                                  showIsFavourite: true,
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
