// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ScrollToBottomButton extends HookWidget {
  const ScrollToBottomButton({
    required this.scrollController,
    required this.onTap,
    super.key,
  });
  static final _offsetThreshold = 16.s;

  final VoidCallback onTap;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final isVisible = useState(false);

    useEffect(() {
      void listener() {
        isVisible.value = scrollController.offset > _offsetThreshold;
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    });

    return PositionedDirectional(
      bottom: 16.0.s,
      end: 16.0.s,
      child: AnimatedSwitcher(
        duration: 300.milliseconds,
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: isVisible.value
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
        padding: EdgeInsets.all(8.s),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: context.theme.appColors.darkBlue.withValues(alpha: 0.05),
              blurRadius: 16.s,
              offset: Offset(-2.s, -2.s),
            ),
          ],
          color: context.theme.appColors.tertararyBackground,
          borderRadius: BorderRadiusDirectional.circular(20.s),
          border: Border.all(
            color: context.theme.appColors.onTerararyFill,
            width: 1.s,
          ),
        ),
        child: Assets.svg.iconArrowDown.icon(
          size: 24.s,
          color: context.theme.appColors.primaryAccent,
        ),
      ),
    );
  }
}
