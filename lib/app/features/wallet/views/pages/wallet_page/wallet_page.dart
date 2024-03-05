import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/balance/balance.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/header/header.dart';

class WalletPage extends IceSimplePage {
  const WalletPage(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final ScrollController scrollController = useScrollController();

    return Scaffold(
      body: SafeArea(
        child: ScreenSideOffset.small(
          child: CustomScrollView(
            controller: scrollController,
            slivers: const <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    Header(),
                    Balance(),
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
