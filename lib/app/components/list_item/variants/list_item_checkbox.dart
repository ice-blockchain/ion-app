part of '../list_item.dart';

class _ListItemWithCheckbox extends ListItem {
  _ListItemWithCheckbox({
    super.key,
    super.leading,
    super.title,
    super.subtitle,
    required this.onTap,
    required this.value,
  }) : super(
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

  final GestureTapCallback? onTap;

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
    return _getDefaultSubtitleStyle(context).copyWith(
      color: value ? context.theme.appColors.onPrimaryAccent : null,
    );
  }

  @override
  Widget _buildMainContainer({
    required BuildContext context,
    required Widget child,
  }) {
    return Material(
      color: _getBackgroundColor(context),
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: child,
      ),
    );
  }
}
