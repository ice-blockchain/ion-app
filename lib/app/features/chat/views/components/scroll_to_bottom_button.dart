import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ScrollToBottomButton extends StatelessWidget {
  const ScrollToBottomButton({
    required this.onTap,
    required this.isVisible,
    super.key,
  });

  final VoidCallback onTap;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
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
        child: isVisible
            ? GestureDetector(
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
                    borderRadius: BorderRadiusDirectional.circular(
                      20.0.s,
                    ),
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
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
