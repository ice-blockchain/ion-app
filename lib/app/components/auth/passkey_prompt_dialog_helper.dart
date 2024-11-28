// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/auth/passkey_prompt_dialog.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

Future<void> guardPasskeyDialog(
  BuildContext context,
  Widget Function(Widget child) passkeyRequestBuilder,
) async {
  return showSimpleBottomSheet<void>(
    context: context,
    child: passkeyRequestBuilder(const PasskeyPromptDialog()),
  );
}

class RiverpodPasskeyRequestBuilder<T> extends HookConsumerWidget {
  const RiverpodPasskeyRequestBuilder({
    required this.child,
    required this.provider,
    required this.request,
    super.key,
  });

  final Widget child;
  final ProviderListenable<AsyncValue<T>> provider;
  final VoidCallback request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(provider, (prev, next) {
      if (!next.isLoading && context.mounted) {
        Navigator.of(context).pop();
      }
    });

    useOnInit(request);

    return child;
  }
}

class HookPasskeyRequestBuilder extends HookWidget {
  const HookPasskeyRequestBuilder({
    required this.child,
    required this.request,
    super.key,
  });

  final Widget child;
  final VoidCallback request;

  @override
  Widget build(BuildContext context) {
    useOnInit(
      () {
        try {
          request();
        } finally {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
    );

    return child;
  }
}
