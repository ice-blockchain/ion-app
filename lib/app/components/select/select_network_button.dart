// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/generated/assets.gen.dart';

class SelectNetworkButton extends StatelessWidget {
  const SelectNetworkButton({
    required this.onTap,
    required this.selectedNetwork,
    super.key,
  });

  final VoidCallback onTap;
  final Network? selectedNetwork;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: selectedNetwork == null
          ? const _NoNetworkSelected()
          : _HasNetworkSelected(selectedNetwork: selectedNetwork!),
    );
  }
}

class _SelectNetworkButtonContainer extends StatelessWidget {
  const _SelectNetworkButtonContainer({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 58.0.s),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: colors.strokeElements),
          borderRadius: BorderRadius.circular(16.0.s),
          color: colors.secondaryBackground,
        ),
        child: Row(
          children: [
            SizedBox(width: 16.0.s),
            Expanded(child: child),
            Assets.svg.iconArrowDown.icon(),
            SizedBox(width: 16.0.s),
          ],
        ),
      ),
    );
  }
}

class _NoNetworkSelected extends StatelessWidget {
  const _NoNetworkSelected();

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textTheme = context.theme.appTextThemes;

    return _SelectNetworkButtonContainer(
      child: Row(
        children: [
          SizedBox.square(
            dimension: 30.0.s,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: colors.onTerararyFill),
                borderRadius: BorderRadius.circular(6.66.s),
                color: colors.secondaryBackground,
              ),
              child: Padding(
                padding: EdgeInsets.all(5.0.s),
                child: Assets.svg.iconMemeNetwork.icon(
                  color: colors.secondaryText,
                  size: 20.0.s,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0.s),
          Text(
            context.i18n.common_select_network_button_unselected,
            style: textTheme.body.copyWith(
              color: colors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _HasNetworkSelected extends StatelessWidget {
  const _HasNetworkSelected({
    required this.selectedNetwork,
  });

  final Network selectedNetwork;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textTheme = context.theme.appTextThemes;

    return _SelectNetworkButtonContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Text(
            context.i18n.wallet_network,
            style: textTheme.caption3.copyWith(
              color: colors.secondaryText,
            ),
          ),
          SizedBox(height: 2.0.s),
          Row(
            children: [
              selectedNetwork.svgIconAsset.icon(),
              SizedBox(width: 10.0.s),
              Expanded(
                child: Text(
                  selectedNetwork.serverName,
                  style: textTheme.body,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0.s),
          const Spacer(),
        ],
      ),
    );
  }
}
