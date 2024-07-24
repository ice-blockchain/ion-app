import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FadeOnScroll extends HookWidget {
  const FadeOnScroll({
    super.key,
    required this.child,
    required this.positionNotifier,
    this.zeroOpacityOffset = 0,
    this.fullOpacityOffset = 100,
  }) : assert(zeroOpacityOffset >= 0 && fullOpacityOffset >= 0,
            'Both zeroOpacityOffset and fullOpacityOffset must be positive');

  final Widget child;

  final double zeroOpacityOffset;

  final double fullOpacityOffset;

  final ValueNotifier<double> positionNotifier;

  double _calculateOpacity(double offset) {
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
    final opacity = useState<double>(_calculateOpacity(positionNotifier.value));

    useEffect(() {
      void setOpacity() => opacity.value = _calculateOpacity(positionNotifier.value);
      positionNotifier.addListener(setOpacity);
      return () => positionNotifier.removeListener(setOpacity);
    }, []);

    return Opacity(
      opacity: opacity.value,
      child: child,
    );
  }
}
