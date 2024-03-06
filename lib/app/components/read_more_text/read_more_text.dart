import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class ReadMoreText extends HookWidget {
  const ReadMoreText(
    this.text, {
    super.key,
    this.maxLines = 3,
  });

  final int maxLines;
  final String text;

  static String get ellipsis => '\u2026';
  static String get lineSeparator => '\u2028';

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> showMore = useState(true);
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);

    final TextAlign textAlign = defaultTextStyle.textAlign ?? TextAlign.start;
    final TextDirection textDirection = Directionality.of(context);
    final TextScaler textScaler = MediaQuery.textScalerOf(context);
    final Locale? locale = Localizations.maybeLocaleOf(context);

    final TapGestureRecognizer gestureRecognizer = useMemoized(
      () => TapGestureRecognizer()
        ..onTap = () {
          showMore.value = !showMore.value;
        },
      <Object?>[],
    );

    final TextSpan link = TextSpan(
      text:
          ' ${showMore.value ? context.i18n.common_show_more : context.i18n.common_show_less}',
      recognizer: gestureRecognizer,
      style: context.theme.appTextThemes.body2
          .copyWith(color: context.theme.appColors.primaryAccent),
    );

    final TextSpan delimiter = TextSpan(
      text: showMore.value ? ellipsis : '',
      recognizer: gestureRecognizer,
    );

    final Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        // Create a TextSpan with data
        final TextSpan text = TextSpan(text: this.text);

        // Layout and measure link
        final TextPainter textPainter = TextPainter(
          text: link,
          textAlign: textAlign,
          textDirection: textDirection,
          textScaler: textScaler,
          maxLines: maxLines,
          locale: locale,
        );
        textPainter.layout(maxWidth: maxWidth);
        final Size linkSize = textPainter.size;

        // Layout and measure delimiter
        textPainter.text = delimiter;
        textPainter.layout(maxWidth: maxWidth);
        final Size delimiterSize = textPainter.size;

        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final Size textSize = textPainter.size;

        // Get the endIndex of data
        bool linkLongerThanLine = false;
        int endIndex;

        if (linkSize.width < maxWidth) {
          final double readMoreSize = linkSize.width + delimiterSize.width;
          final TextPosition pos = textPainter.getPositionForOffset(
            Offset(
              textDirection == TextDirection.rtl
                  ? readMoreSize
                  : textSize.width - readMoreSize,
              textSize.height,
            ),
          );
          endIndex = textPainter.getOffsetBefore(pos.offset) ?? 0;
        } else {
          final TextPosition pos = textPainter.getPositionForOffset(
            textSize.bottomLeft(Offset.zero),
          );
          endIndex = pos.offset;
          linkLongerThanLine = true;
        }

        late final TextSpan textSpan;

        late final String textData;

        if (textPainter.didExceedMaxLines) {
          textData = showMore.value
              ? this.text.substring(0, endIndex) +
                  (linkLongerThanLine ? lineSeparator : '')
              : this.text;
          textSpan = TextSpan(
            text: textData,
            children: <TextSpan>[delimiter, link],
            style: context.theme.appTextThemes.body2
                .copyWith(color: context.theme.appColors.primaryText),
          );
        } else {
          textData = this.text;
          textSpan = TextSpan(
            text: textData,
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SizeTransition(
              sizeFactor: animation,
              axisAlignment: -1,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Text.rich(
            key: ValueKey<String>(textData),
            textSpan,
            textAlign: textAlign,
            textDirection: textDirection,
            softWrap: true,
            overflow: TextOverflow.clip,
            textScaler: textScaler,
          ),
        );
      },
    );
    return result;
  }
}
