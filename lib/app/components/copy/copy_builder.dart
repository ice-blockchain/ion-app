// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/services/clipboard/clipboard.dart';
import 'package:ion/app/utils/future.dart';
import 'package:ion/generated/assets.gen.dart';

class CopyBuilder extends HookWidget {
  const CopyBuilder({
    required this.builder,
    required this.defaultIcon,
    required this.defaultText,
    this.copiedIcon,
    this.defaultBorderColor,
    this.copiedBorderColor,
    this.copiedText,
    super.key,
  });

  final Widget? copiedIcon;
  final Widget defaultIcon;
  final Color? copiedBorderColor;
  final Color? defaultBorderColor;
  final String? copiedText;
  final String defaultText;

  final Widget Function(
    BuildContext context,
    void Function(String text) onCopy,
    CopyBuilderContent content,
  ) builder;

  @override
  Widget build(BuildContext context) {
    final isCopied = useState<bool>(false);
    return builder(
      context,
      (text) {
        isCopied.value = true;
        copyToClipboard(text);
        delayed(() => isCopied.value = false, after: 2.seconds);
      },
      CopyBuilderContent(
        icon: isCopied.value ? copiedIcon ?? IconAsset(Assets.svgIconBlockCheckGreen) : defaultIcon,
        borderColor: isCopied.value
            ? copiedBorderColor ?? context.theme.appColors.success
            : defaultBorderColor,
        text: isCopied.value ? copiedText ?? context.i18n.common_copied : defaultText,
      ),
    );
  }
}

final class CopyBuilderContent {
  CopyBuilderContent({
    required this.icon,
    required this.borderColor,
    required this.text,
  });

  final Widget icon;
  final Color? borderColor;
  final String text;
}
