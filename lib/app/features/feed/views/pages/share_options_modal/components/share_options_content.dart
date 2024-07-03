import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_header.dart';
import 'package:ice/app/features/feed/views/pages/share_options_modal/components/horizontal_scroll_menu.dart';
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
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: isSelectedList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _toggleSelection(index),
                child: PostHeader(
                  trailing: _getCheckbox(index),
                ),
              );
            },
          ),
        ),
        if (hasSelection)
          Container(
            decoration: BoxDecoration(
              color: context.theme.appColors.secondaryBackground,
              boxShadow: [
                BoxShadow(
                  color:
                      context.theme.appColors.strokeElements.withOpacity(0.5),
                  offset: Offset(0.0.s, -1.0.s),
                  blurRadius: 5.0.s,
                ),
              ],
            ),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 31.0.s, horizontal: 44.0.s),
              child: Button.compact(
                mainAxisSize: MainAxisSize.max,
                minimumSize: Size(56.0.s, 56.0.s),
                trailingIcon: Assets.images.icons.iconButtonNext
                    .icon(color: context.theme.appColors.onPrimaryAccent),
                label: Text(
                  context.i18n.feed_send,
                ),
                onPressed: () {},
              ),
            ),
          )
        else
          const HorizontalScrollMenu(),
      ],
    );
  }

  Widget _getCheckbox(int index) {
    return isSelectedList[index]
        ? Assets.images.icons.iconBlockCheckboxOn.icon()
        : Assets.images.icons.iconBlockCheckboxOff.icon();
  }
}
