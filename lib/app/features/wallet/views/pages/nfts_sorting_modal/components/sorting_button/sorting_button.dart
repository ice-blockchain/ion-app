import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/user/model/nft_sorting_type.dart';
import 'package:ice/app/features/user/providers/user_preferences_provider.dart';

class SortingButton extends HookConsumerWidget {
  const SortingButton({
    required this.sortingType,
    super.key,
  });

  final NftSortingType sortingType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenSideOffset.small(
      child: Button(
        leadingIcon: sortingType.iconAsset.icon(
          color: context.theme.appColors.primaryAccent,
        ),
        onPressed: () {
          ref.read(userPreferencesNotifierProvider.notifier).setNftSortingType(sortingType);
        },
        label: Text(sortingType.getTitle(context)),
        mainAxisSize: MainAxisSize.max,
        type: ButtonType.secondary,
      ),
    );
  }
}
