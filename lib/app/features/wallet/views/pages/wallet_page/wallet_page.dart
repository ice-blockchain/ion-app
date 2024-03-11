import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/features/core/providers/permissions_provider_selectors.dart';
import 'package:ice/app/features/wallet/providers/contacts_data_provider.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/balance/balance.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/contacts/contacts_list.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/delimiter/delimiter.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/header/header.dart';
import 'package:ice/app/router/app_routes.dart';

class WalletPage extends IceSimplePage {
  const WalletPage(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final ScrollController scrollController = useScrollController();
    final bool? hasContactsPermission = useHasContactsPermission(ref);
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (hasContactsPermission == true) {
            ref.read(contactsDataNotifierProvider.notifier).fetchContacts();
          } else {
            IceRoutes.allowAccess.go(context);
          }
        });
        return null;
      },
      <Object?>[
        hasContactsPermission,
      ],
    );

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: const <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Header(),
                Balance(),
                ContactsList(),
                Delimiter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
