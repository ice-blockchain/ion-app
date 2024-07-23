import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/position_controller.dart';

class FadeOnScroll extends HookWidget {
  const FadeOnScroll({
    super.key,
    required this.child,
    required this.positionController,
    this.zeroOpacityOffset = 0,
    this.fullOpacityOffset = 100,
  }) : assert(zeroOpacityOffset >= 0 && fullOpacityOffset >= 0,
            'Both zeroOpacityOffset and fullOpacityOffset must be positive');

  final Widget child;

  final double zeroOpacityOffset;

  final double fullOpacityOffset;

  final PositionController positionController;

  double _calculateOpacity(double offset) {
    print(offset);
    // fade in
    if (zeroOpacityOffset < fullOpacityOffset) {
      if (offset < zeroOpacityOffset) {
        return 0;
      } else if (offset > fullOpacityOffset) {
        return 1;
      } else {
        return (offset - zeroOpacityOffset) / (fullOpacityOffset - zeroOpacityOffset);
      }
    }
    // fade out
    else if (zeroOpacityOffset > fullOpacityOffset) {
      if (offset > zeroOpacityOffset) {
        return 0;
      } else if (offset < fullOpacityOffset) {
        return 1;
      } else {
        return 1 - (offset - fullOpacityOffset) / (zeroOpacityOffset - fullOpacityOffset);
      }
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final opacity = useState<double>(_calculateOpacity(positionController.position));

    useEffect(() {
      void setOpacity() => opacity.value = _calculateOpacity(positionController.position);
      positionController.addListener(setOpacity);
      return () => positionController.removeListener(setOpacity);
    }, []);

    return Opacity(
      opacity: opacity.value,
      child: child,
    );
  }
}
