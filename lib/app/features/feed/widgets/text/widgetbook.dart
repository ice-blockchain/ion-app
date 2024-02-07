import 'package:flutter/material.dart';
import 'package:ice/app/features/feed/widgets/text/article_header.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'article header',
  type: ArticleHeader,
)
Widget plainArticleHeader(BuildContext context) {
  return const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      ArticleHeader(
        headerText:
            'Coinbase Launches USDC Yields for Global Customers Amid US Crackdown',
        main: true,
      ),
      ArticleHeader(
        headerText:
            'In 22 years, AI will perform 50% of work tasks, These are the results of McKinsey study',
      ),
    ],
  );
}
