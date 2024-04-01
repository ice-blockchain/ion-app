import 'package:flutter/material.dart';
import 'package:ice/app/features/feed/views/components/article_header/article_header.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'article header',
  type: ArticleHeader,
)
Widget plainArticleHeader(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      ArticleHeader(
        headerText: context.knobs.string(
          label: 'Article Header',
          initialValue:
              'Coinbase Launches USDC Yields for Global Customers Amid US Crackdown',
        ),
        isMainHeader: true,
      ),
      ArticleHeader(
        headerText: context.knobs.string(
          label: 'Article Header',
          initialValue:
              'In 22 years, AI will perform 50% of work tasks, These are the results of McKinsey study',
        ),
      ),
    ],
  );
}
