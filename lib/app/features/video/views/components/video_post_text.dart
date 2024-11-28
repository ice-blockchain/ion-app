// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';

class VideoTextPost extends HookWidget {
  const VideoTextPost({
    required this.text,
    super.key,
  });

  final String text;

  bool _isTextOneLine({
    required String text,
    required TextStyle style,
    required double maxWidth,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
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
          text: text,
          style: context.theme.appTextThemes.body2.copyWith(color: Colors.white),
          maxWidth: MediaQuery.sizeOf(context).width,
        );
      },
      [
        text,
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
                ? Text(
                    text,
                    key: const ValueKey('expanded'),
                    style: context.theme.appTextThemes.body2.copyWith(
                      color: Colors.white,
                    ),
                  )
                : Text(
                    text,
                    key: const ValueKey('collapsed'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.theme.appTextThemes.body2.copyWith(
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
