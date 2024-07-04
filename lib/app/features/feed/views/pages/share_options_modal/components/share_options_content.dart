import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_header.dart';
import 'package:ice/app/features/feed/views/pages/share_options_modal/components/has_selection.dart';
import 'package:ice/generated/assets.gen.dart';

class ShareOptionsContent extends StatefulWidget {
  const ShareOptionsContent({super.key});

  @override
  ShareOptionsContentState createState() => ShareOptionsContentState();
}

class ShareOptionsContentState extends State<ShareOptionsContent> {
  // Mock selection state for 10 items
  List<bool> isSelectedList = List.generate(10, (index) => false);

  void _toggleSelection(int index) {
    setState(() {
      isSelectedList[index] = !isSelectedList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = isSelectedList.any((isSelected) => isSelected);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: isSelectedList.length,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 14.0.s,
              );
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _toggleSelection(index),
                child: PostHeader(
                  minHeight: 0.0.s,
                  trailing: _getCheckbox(index),
                ),
              );
            },
          ),
        ),
        HasSelection(
          hasSelection: hasSelection,
        ),
      ],
    );
  }

  Widget _getCheckbox(int index) {
    return isSelectedList[index]
        ? Assets.images.icons.iconBlockCheckboxOn.icon()
        : Assets.images.icons.iconBlockCheckboxOff
            .icon(color: context.theme.appColors.onTerararyFill);
  }
}
