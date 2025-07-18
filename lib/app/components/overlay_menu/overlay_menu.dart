// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/overlay_menu/hooks/use_hide_on_scroll.dart';
import 'package:ion/app/extensions/extensions.dart';

class OverlayMenu extends HookWidget {
  const OverlayMenu({
    required this.child,
    required this.menuBuilder,
    this.onOpen,
    this.onClose,
    this.scrollController,
    super.key,
  });

  final Widget child;
  final Widget Function(VoidCallback closeMenu) menuBuilder;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final overlayPortalController = useMemoized(OverlayPortalController.new);
    final followLink = useMemoized(LayerLink.new);
    final animationController = useAnimationController(duration: const Duration(milliseconds: 400));
    final scaleAnimation = CurvedAnimation(parent: animationController, curve: Curves.easeOutBack);

    useHideOnScroll(context, overlayPortalController, scrollController);

    final hideMenu = useCallback(
      () {
        animationController.reverse().whenComplete(() {
          overlayPortalController.hide();
          onClose?.call();
        });
      },
      [overlayPortalController],
    );

    final showMenu = useCallback(
      () {
        overlayPortalController.show();
        animationController.forward();
        onOpen?.call();
      },
      [overlayPortalController],
    );

    return OverlayPortal(
      controller: overlayPortalController,
      overlayChildBuilder: (_) {
        final renderBox = context.findRenderObject()! as RenderBox;

        final dir = Directionality.of(context);
        final globalOffset = renderBox.localToGlobal(Offset.zero);
        final maxMenuWidth = 300.0.s;
        final shouldAlignStart = globalOffset.dx + renderBox.size.width < maxMenuWidth;
        final offset = shouldAlignStart
            ? Offset(0, renderBox.size.height + 6.0.s)
            : Offset(renderBox.size.width, renderBox.size.height + 6.0.s);
        final anchorAlignment =
            (shouldAlignStart ? AlignmentDirectional.topStart : AlignmentDirectional.topEnd)
                .resolve(dir);

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: hideMenu,
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: followLink,
                offset: offset,
                followerAnchor: anchorAlignment,
                showWhenUnlinked: false,
                child: ScaleTransition(
                  alignment: anchorAlignment,
                  scale: scaleAnimation,
                  child: IntrinsicWidth(child: menuBuilder(hideMenu)),
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
