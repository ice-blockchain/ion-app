import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/empty_list/empty_list.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/dapps/model/dapp_data.dart';
import 'package:ice/app/features/dapps/providers/dapps_provider.dart';
import 'package:ice/app/features/dapps/views/categories/apps/apps.dart';
import 'package:ice/app/features/dapps/views/components/grid_item/grid_item.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/generated/assets.gen.dart';

class DAppsList extends HookConsumerWidget {
  const DAppsList({required this.payload, super.key});

  final AppsRouteData payload;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = useState('');
    final apps = ref.watch(dappsDataProvider).valueOrNull ?? [];

    final filteredApps = searchText.value.isEmpty
        ? apps
        : apps.where((DAppData app) {
            final searchLower = searchText.value.toLowerCase().trim();
            final titleLower = app.title.toLowerCase();

            return titleLower.contains(searchLower);
          }).toList();

    return Scaffold(
      appBar: NavigationAppBar.screen(
        title: Text(payload.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ScreenSideOffset.small(
              child: Padding(
                padding: EdgeInsets.only(top: 12.0.s),
                child: Column(
                  children: [
                    if (payload.isSearchVisible ?? false)
                      SearchInput(
                        onTextChanged: (String value) => searchText.value = value,
                      ),
                    Expanded(
                      child: Container(
                        child: apps.isEmpty
                            ? EmptyList(
                                asset: Assets.svg.walletIconWalletEmptyfavourites,
                                title: context.i18n.dapps_favourites_empty_title,
                              )
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0.s,
                                ),
                                itemCount: filteredApps.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final app = filteredApps[index];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5.5.s),
                                    child: GridItem(
                                      dAppData: app,
                                      showIsFavourite: true,
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
