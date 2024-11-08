// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/overlay_menu/hooks/use_hide_on_scroll.dart';
import 'package:ion/app/extensions/extensions.dart';

class OverlayMenu extends HookWidget {
  const OverlayMenu({
    required this.child,
    required this.menuBuilder,
    super.key,
  });

  final Widget child;
  final Widget Function(VoidCallback closeMenu) menuBuilder;

  @override
  Widget build(BuildContext context) {
    final overlayPortalController = useMemoized(OverlayPortalController.new);
    final followLink = useMemoized(LayerLink.new);
    final animationController = useAnimationController(duration: const Duration(milliseconds: 400));
    final scaleAnimation = CurvedAnimation(parent: animationController, curve: Curves.easeOutBack);

    useHideOnScroll(context, overlayPortalController);

    final hideMenu = useCallback(
      () {
        animationController.reverse().whenComplete(overlayPortalController.hide);
      },
      [overlayPortalController],
    );

    final showMenu = useCallback(
      () {
        overlayPortalController.show();
        animationController.forward();
      },
      [overlayPortalController],
    );

    return OverlayPortal(
      controller: overlayPortalController,
      overlayChildBuilder: (_) {
        final renderBox = context.findRenderObject()! as RenderBox;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: hideMenu,
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: followLink,
                offset: Offset(renderBox.size.width, renderBox.size.height + 6.0.s),
                followerAnchor: Alignment.topRight,
                child: ScaleTransition(
                  alignment: Alignment.topRight,
                  scale: scaleAnimation,
                  child: menuBuilder(hideMenu),
                ),
              ),
            ],
          ),
        );
      },
      child: GestureDetector(
        onTap: showMenu,
        child: CompositedTransformTarget(
          link: followLink,
          child: child,
        ),
      ),
    );
  }
}
