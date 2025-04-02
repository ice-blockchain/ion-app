// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/text_input/components/paste_suffix_button.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_border.dart';
import 'package:ion/app/components/inputs/text_input/text_input.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/select/select_network_button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/views/pages/import_token_page/components/token_already_exists_dialog.dart';
import 'package:ion/app/features/wallets/views/pages/import_token_page/components/token_not_found_dialog.dart';
import 'package:ion/app/features/wallets/views/pages/import_token_page/providers/selected_network_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/import_token_page/providers/token_address_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/import_token_page/providers/token_already_exists_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/import_token_page/providers/token_data_notifier_provider.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/clipboard/clipboard.dart';

class ImportTokenForm extends HookConsumerWidget {
  const ImportTokenForm({
    required this.onValidationStateChanged,
    super.key,
  });

  final ValueChanged<bool> onValidationStateChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..watch(selectedNetworkProvider)
      ..watch(tokenAddressProvider);

    final selectedNetwork = ref.watch(selectedNetworkProvider);
    final tokenAddressController = useTextEditingController();
    final tokenSymbolController = useTextEditingController();
    final tokenDecimalsController = useTextEditingController();

    ref
      ..listen(tokenDataNotifierProvider, (previous, next) {
        final token = next.valueOrNull;
        final decimals = token?.decimals ?? 0;
        final decimalsString = decimals == 0 ? '' : decimals.toString();

        tokenSymbolController.text = token?.abbreviation ?? '';
        tokenDecimalsController.text = decimalsString;

        if (tokenAddressController.text.isNotEmpty && !next.isLoading) {
          _checkIfTokenNotFound(context, token);
        }
      })
      ..listenSuccess(
        tokenAlreadyExistsProvider,
        (exists) => _onTokenAlreadyExists(context, exists: exists ?? false),
      );

    _useListenAddressChanges(ref, tokenAddressController);

    useOnInit(
      () {
        final isValid = selectedNetwork != null && tokenAddressController.text.isNotEmpty;
        onValidationStateChanged(isValid);
      },
      [selectedNetwork, tokenAddressController.text],
    );

    return Column(
      children: [
        SelectNetworkButton(
          selectedNetwork: selectedNetwork,
          onTap: () => _onNetworkPressed(ref),
        ),
        SizedBox(height: 16.0.s),
        TextInput(
          labelText: context.i18n.wallet_import_token_address_label,
          controller: tokenAddressController,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          suffixIcon: PasteSuffixButton(
            onTap: () async {
              tokenAddressController.text = await getClipboardText();
              unawaited(ref.read(tokenDataNotifierProvider.notifier).fetchTokenData());
            },
          ),
          onFocused: (hasFocus) {
            if (!hasFocus) {
              ref.read(tokenDataNotifierProvider.notifier).fetchTokenData();
            }
          },
        ),
        SizedBox(height: 16.0.s),
        _DisabledTextInput(
          labelText: context.i18n.wallet_import_token_symbol_label,
          controller: tokenSymbolController,
        ),
        SizedBox(height: 16.0.s),
        _DisabledTextInput(
          labelText: context.i18n.wallet_import_token_decimals_label,
          controller: tokenDecimalsController,
        ),
      ],
    );
  }

  Future<void> _onNetworkPressed(WidgetRef ref) async {
    final newNetwork = await SelectNetworkForTokenRoute().push<NetworkData?>(ref.context);
    if (newNetwork != null) {
      ref.read(selectedNetworkProvider.notifier).network = newNetwork;
      unawaited(ref.read(tokenDataNotifierProvider.notifier).fetchTokenData());
    }
  }

  void _onTokenAlreadyExists(BuildContext context, {required bool exists}) {
    if (context.mounted && exists) {
      showSimpleBottomSheet<void>(
        context: context,
        child: const TokenAlreadyExistsDialog(),
      );
    }
  }

  void _checkIfTokenNotFound(BuildContext context, CoinData? token) {
    if (context.mounted && (token == null || token.name.isEmpty)) {
      showSimpleBottomSheet<void>(
        context: context,
        child: const TokenNotFoundDialog(),
      );
    }
  }

  void _useListenAddressChanges(
    WidgetRef ref,
    TextEditingController tokenAddressController,
  ) {
    useOnInit(
      () {
        tokenAddressController.addListener(
          () {
            ref.read(tokenAddressProvider.notifier).address = tokenAddressController.text;
          },
        );
      },
      [tokenAddressController],
    );
  }
}

class _DisabledTextInput extends ConsumerWidget {
  const _DisabledTextInput({
    required this.controller,
    required this.labelText,
  });

  final TextEditingController controller;
  final String labelText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(tokenDataNotifierProvider.select((state) => state.isLoading));

    return TextInput(
      labelText: labelText,
      controller: controller,
      suffixIcon: isLoading
          ? Padding(
              padding: EdgeInsetsDirectional.only(end: 8.0.s),
              child: const IONLoadingIndicatorThemed(),
            )
          : null,
      enabled: false,
      color: context.theme.appColors.onTertararyBackground,
      disabledBorder: TextInputBorder(
        borderSide: BorderSide(color: context.theme.appColors.onTerararyFill),
      ),
      fillColor: context.theme.appColors.secondaryBackground,
      labelColor: context.theme.appColors.sheetLine,
      floatingLabelColor: context.theme.appColors.sheetLine,
    );
  }
}
