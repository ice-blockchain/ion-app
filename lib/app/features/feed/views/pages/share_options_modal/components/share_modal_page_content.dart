import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/pages/share_options_modal/components/share_bottom_actions.dart';
import 'package:ice/generated/assets.gen.dart';

class ShareModalPageContent extends HookConsumerWidget {
  const ShareModalPageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock selection state for 10 items using useState hook
    final isSelectedList = useState<List<bool>>(List.generate(10, (index) => false));

    void toggleSelection(int index) {
      isSelectedList.value[index] = !isSelectedList.value[index];
      isSelectedList.value = List.from(isSelectedList.value);
    }

    final hasSelectedUsers = isSelectedList.value.any((isSelected) => isSelected);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: isSelectedList.value.length,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 16.0.s,
              );
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => toggleSelection(index),
                child: ScreenSideOffset.small(
                  child: ListItem.user(
                    title: const Text('Arnold Grey'),
                    subtitle: const Text('@arnoldgrey'),
                    profilePicture:
                        'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
                    trailing: _getCheckbox(context, isSelectedList.value[index]),
                    verifiedBadge: true,
                  ),
                ),
              );
            },
          ),
        ),
        ShareBottomActions(
          hasSelectedUsers: hasSelectedUsers,
        ),
      ],
    );
  }

  Widget _getCheckbox(BuildContext context, bool isSelected) {
    return isSelected
        ? Assets.images.icons.iconBlockCheckboxOn.icon()
        : Assets.images.icons.iconBlockCheckboxOff
            .icon(color: context.theme.appColors.onTerararyFill);
  }
}
