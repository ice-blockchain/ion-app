part of '../button.dart';

class _ButtonWithIcon extends Button {
  _ButtonWithIcon({
    super.key,
    required this.type,
    required Widget image,
  }) : super(
          leadingIcon: image,
          onPressed: () {},
        );

  final ButtonType type;

  @override
  Widget? buildLeadingIcon(
    BuildContext context,
  ) {
    final Color iconColor = _getBackgroundColor(context, type);
    return Icon((leadingIcon! as Icon).icon, color: iconColor);
  }

  Color _getBackgroundColor(BuildContext context, ButtonType type) {
    switch (type) {
      case ButtonType.primary:
        return context.theme.appColors.primaryAccent;
      case ButtonType.secondary:
        return context.theme.appColors.onPrimaryAccent;
      case ButtonType.outlined:
        return Colors.transparent;
      case ButtonType.disabled:
        return context.theme.appColors.sheetLine;
    }
  }
}
