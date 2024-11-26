import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/pages/components/user_banner/user_banner.dart';
import 'package:ion/app/features/user/providers/banner_picker_notifier.dart';

class UserBannerPicked extends ConsumerWidget {
  const UserBannerPicked({required this.pubkey, super.key});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banner = ref.watch(bannerPickerNotifierProvider).whenOrNull(
          cropped: (file) => file,
          processed: (file) => file,
        );

    return UserBanner(pubkey: pubkey, bannerFile: banner);
  }
}
