// SPDX-License-Identifier: ice License 1.0

//ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/utils/clipboard.dart';
import 'package:ion/app/utils/future.dart';

class CopyBuilder extends HookWidget {
  const CopyBuilder({required this.builder, super.key});

  final Widget Function(
    BuildContext context,
    void Function(String text) onCopy,
    bool isCopied,
  ) builder;

  @override
  Widget build(BuildContext context) {
    final isCopied = useState<bool>(false);
    return builder(
      context,
      (text) {
        isCopied.value = true;
        copyToClipboard(text);
        delayed(() => isCopied.value = false, after: 3.seconds);
      },
      isCopied.value,
    );
  }
}
