// SPDX-License-Identifier: ice License 1.0

part of 'components.dart';

class PhotoGalleryContextMenu extends StatelessWidget {
  const PhotoGalleryContextMenu({super.key});

  static double get iconSize => 20.0.s;

  @override
  Widget build(BuildContext context) {
    return OverlayMenu(
      menuBuilder: (closeMenu) => Column(
        children: [
          OverlayMenuContainer(
            child: IntrinsicWidth(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0.s),
                child: Column(
                  children: [
                    OverlayMenuItem(
                      label: context.i18n.button_share,
                      icon: Assets.svg.iconButtonShare.icon(
                        size: iconSize,
                        color: context.theme.appColors.quaternaryText,
                      ),
                      onPressed: closeMenu,
                    ),
                    const OverlayMenuItemSeperator(),
                    OverlayMenuItem(
                      label: context.i18n.button_save,
                      icon: Assets.svg.iconSecurityDownload
                          .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                      onPressed: closeMenu,
                    ),
                    const OverlayMenuItemSeperator(),
                    OverlayMenuItem(
                      label: context.i18n.button_report,
                      icon: Assets.svg.iconBlockClose3
                          .icon(size: iconSize, color: context.theme.appColors.quaternaryText),
                      onPressed: closeMenu,
                    ),
                    const OverlayMenuItemSeperator(),
                    OverlayMenuItem(
                      label: context.i18n.button_delete,
                      labelColor: context.theme.appColors.attentionRed,
                      icon: Assets.svg.iconBlockDelete
                          .icon(size: iconSize, color: context.theme.appColors.attentionRed),
                      onPressed: closeMenu,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      child: Assets.svg.iconMorePopup.icon(
        color: context.theme.appColors.onPrimaryAccent,
      ),
    );
  }
}
