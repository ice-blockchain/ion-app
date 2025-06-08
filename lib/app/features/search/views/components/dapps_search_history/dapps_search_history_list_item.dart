// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/dapps/data/models/dapp_data.c.dart';
import 'package:ion/app/features/dapps/providers/dapps_provider.c.dart';
import 'package:ion/app/features/search/views/components/search_history/search_list_item_loading.dart';
import 'package:ion/app/router/app_routes.c.dart';

class DAppsSearchHistoryListItem extends ConsumerWidget {
  const DAppsSearchHistoryListItem({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dapp = ref.watch(dappByIdProvider(dappId: id));

    return dapp.maybeWhen(
      data: (app) => _ListItem(app: app),
      orElse: ListItemLoading.new,
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({required this.app});

  final DAppData app;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => DAppDetailsRoute(dappId: app.identifier).push<void>(context),
      child: SizedBox(
        width: 65.0.s,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Avatar(
              size: 65.0.s,
              imageWidget: Image.asset(app.iconImage),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  app.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme.appTextThemes.caption3.copyWith(
                    color: context.theme.appColors.primaryText,
                  ),
                ),
                Text(
                  app.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme.appTextThemes.caption3.copyWith(
                    color: context.theme.appColors.tertararyText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
