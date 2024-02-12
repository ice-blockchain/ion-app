import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/nav_header_offset/nav_header_offset.dart';
import 'package:ice/app/components/navigation_header/navigation_header.dart';
import 'package:ice/app/components/search/search.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/dapps/views/pages/components/apps_collection.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_apps.dart';

class DAppsList extends HookConsumerWidget {
  const DAppsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<String> searchText = useState('');

    final List<DAppItem> filteredApps = searchText.value.isEmpty
        ? featured
        : featured.where((DAppItem app) {
            final String searchLower = searchText.value.toLowerCase().trim();
            final String titleLower = app.title.toLowerCase();

            return titleLower.contains(searchLower);
          }).toList();

    return Scaffold(
      body: NavHeaderOffset(
        child: Container(
          width: double.infinity,
          color: context.theme.appColors.secondaryBackground,
          child: Stack(
            children: <Widget>[
              NavigationHeader(
                title: context.i18n.dapps_list_defi,
              ),
              Padding(
                padding: const EdgeInsets.only(top: navigationHeaderHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Search(
                      onTextChanged: (String value) => searchText.value = value,
                      onClearText: () => searchText.value = '',
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredApps.length,
                        itemBuilder: (BuildContext context, int index) {
                          final DAppItem app = filteredApps[index];
                          return DAppGridItem(item: app, showIsFavourite: true);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
