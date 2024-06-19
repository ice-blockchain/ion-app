part of '../list_item.dart';

class _ListItemWithCheckbox extends ListItem {
  _ListItemWithCheckbox({
    required super.onTap,
    required this.value,
    super.key,
    super.leading,
    super.title,
    super.subtitle,
    super.border,
    super.borderRadius,
    super.contentPadding,
    super.leadingPadding,
    super.trailingPadding,
    super.constraints,
    super.backgroundColor,
  }) : super(
          isSelected: value,
          trailing: value
              ? const Icon(
                  Icons.check_box,
                  color: Colors.white,
                )
              : const Icon(
                  Icons.check_box_outline_blank_sharp,
                ),
        );

  final bool value;

  @override
  Color _getBackgroundColor(BuildContext context) {
    return value
        ? context.theme.appColors.primaryAccent
        : super._getBackgroundColor(context);
  }

  @override
  TextStyle _getDefaultTitleStyle(BuildContext context) {
    return super._getDefaultTitleStyle(context).copyWith(
          color: value ? context.theme.appColors.onPrimaryAccent : null,
        );
  }

  @override
  TextStyle _getDefaultSubtitleStyle(BuildContext context) {
    return super._getDefaultSubtitleStyle(context).copyWith(
          color: value ? context.theme.appColors.onPrimaryAccent : null,
        );
  }
}
