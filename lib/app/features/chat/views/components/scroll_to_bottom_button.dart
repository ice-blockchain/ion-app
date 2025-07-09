// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScrollToBottomButton extends HookWidget {
  const ScrollToBottomButton({
    required this.scrollOffsetListener,
    required this.onTap,
    super.key,
  });
  static final _offsetThreshold = 16.s;

  final VoidCallback onTap;
  final ScrollOffsetListener scrollOffsetListener;

  @override
  Widget build(BuildContext context) {
    final totalScrollOffset = useState<double>(0);

    useOnInit(() {
      scrollOffsetListener.changes.listen(
        (offset) {
          totalScrollOffset.value += offset;
        },
      );
    });

    return PositionedDirectional(
      bottom: 16.0.s,
      end: 16.0.s,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: totalScrollOffset.value > _offsetThreshold
            ? _ScrollButton(
                onTap: onTap,
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _ScrollButton extends StatelessWidget {
  const _ScrollButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.0.s),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: context.theme.appColors.darkBlue.withValues(alpha: 0.05),
              blurRadius: 16.0.s,
              spreadRadius: 0.0.s,
              offset: Offset(-2.s, -2.s),
            ),
          ],
          color: context.theme.appColors.tertararyBackground,
          borderRadius: BorderRadiusDirectional.circular(20.0.s),
          border: Border.all(
            color: context.theme.appColors.onTerararyFill,
            width: 1.0.s,
          ),
        ),
        child: Assets.svg.iconArrowDown.icon(
          size: 24.0.s,
          color: context.theme.appColors.primaryAccent,
        ),
      ),
    );
  }
}
