import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/views/pages/share_via_message_modal/components/share_options_menu_item.dart';
import 'package:ion/app/services/share/share_provider.r.dart';
import 'package:ion/generated/assets.gen.dart';

class CopyLinkOption extends HookConsumerWidget {
  const CopyLinkOption({required this.shareUrl, required this.iconSize, super.key});

  final String shareUrl;
  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCopied = useState<bool>(false);

    useEffect(
      () {
        Timer? timer;

        if (isCopied.value) {
          timer = Timer(const Duration(seconds: 2), () {
            isCopied.value = false;
          });
        }

        return () {
          timer?.cancel();
        };
      },
      [isCopied.value],
    );

    return ShareOptionsMenuItem(
      buttonType: ButtonType.dropdown,
      borderColor: isCopied.value ? context.theme.appColors.success : null,
      icon: SizedBox(
        width: iconSize * 1.2.s,
        height: iconSize * 1.2.s,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Assets.svg.iconBlockCopy1.icon(size: iconSize, color: Colors.black),
            if (isCopied.value)
              Positioned(
                right: 5.s,
                top: 2.s,
                child: Assets.svg.iconBlockCheckGreen.icon(size: 16.s),
              ),
          ],
        ),
      ),
      label: isCopied.value ? context.i18n.common_copied : context.i18n.feed_copy_link,
      onPressed: () {
        ref.read(socialShareServiceProvider.notifier).shareToClipboard(shareUrl);
        isCopied.value = true;
      },
    );
  }
}
