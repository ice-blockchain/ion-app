// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';

class VideoTextPost extends HookWidget {
  const VideoTextPost({
    required this.textSpan,
    super.key,
  });

  final TextSpan textSpan;

  bool _isTextOneLine({
    required TextSpan text,
    required TextStyle style,
    required double maxWidth,
  }) {
    final textPainter = TextPainter(
      text: text,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return !textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final isTextExpanded = useState(false);

    final isOneLine = useMemoized(
      () {
        return _isTextOneLine(
          text: textSpan,
          style: context.theme.appTextThemes.body2.copyWith(color: Colors.white),
          maxWidth: MediaQuery.sizeOf(context).width,
        );
      },
      [
        textSpan,
        context.theme.appTextThemes.body2,
        MediaQuery.sizeOf(context).width,
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: isOneLine ? null : () => isTextExpanded.value = !isTextExpanded.value,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1,
                  child: child,
                ),
              );
            },
            child: isTextExpanded.value
                ? Text.rich(
                    textSpan,
                    key: const ValueKey('expanded'),
                  )
                : Text.rich(
                    textSpan,
                    key: const ValueKey('collapsed'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ),
      ],
    );
  }
}
