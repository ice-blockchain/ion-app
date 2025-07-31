// SPDX-License-Identifier: ice License 1.0

part of '../search_emoji_modal.dart';

class _EmojiCategoryButton extends StatelessWidget {
  const _EmojiCategoryButton({
    required this.category,
    required this.onPressed,
    this.isActive = false,
  });

  final EmojiCategory category;
  final VoidCallback onPressed;
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8.0.s),
        decoration: BoxDecoration(
          color: isActive ? context.theme.appColors.onTertararyFill : Colors.transparent,
          borderRadius: BorderRadius.circular(30.0.s),
        ),
        child: category.getIcon(context).icon(
              size: 20.0.s,
              color: isActive
                  ? context.theme.appColors.primaryAccent
                  : context.theme.appColors.quaternaryText,
            ),
      ),
    );
  }
}
