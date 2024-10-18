// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/overlay_menu/hooks/use_hide_on_scroll.dart';

class OverlayMenu extends HookWidget {
  const OverlayMenu({
    required this.child,
    required this.menuBuilder,
    super.key,
    this.offset = Offset.zero,
  });

  final Widget child;
  final Widget Function(VoidCallback closeMenu) menuBuilder;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final overlayPortalController = useMemoized(OverlayPortalController.new);
    final followLink = useMemoized(LayerLink.new);

    useHideOnScroll(context, overlayPortalController);

    return OverlayPortal(
      controller: overlayPortalController,
      overlayChildBuilder: (_) {
        final renderBox = context.findRenderObject()! as RenderBox;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: overlayPortalController.hide,
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: followLink,
                offset: Offset(0, renderBox.size.height).translate(offset.dx, offset.dy),
                child: menuBuilder(overlayPortalController.hide),
              ),
            ],
          ),
        );
      },
      child: GestureDetector(
        onTap: overlayPortalController.show,
        child: CompositedTransformTarget(
          link: followLink,
          child: child,
        ),
      ),
    );
  }
}
