// SPDX-License-Identifier: ice License 1.0

import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class PreferEdgeInsetsDirectionalRule extends DartLintRule {
  const PreferEdgeInsetsDirectionalRule() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_edge_insets_directional',
    problemMessage:
        'Prefer EdgeInsetsDirectional.only/fromSTEB instead of EdgeInsets.only/fromLTRB for RTL support.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final typeName = node.constructorName.type.toSource();
      final constructorName = node.constructorName.name?.name;
      if (typeName == 'EdgeInsets' &&
          (constructorName == 'only' || constructorName == 'fromLTRB')) {
        reporter.atNode(
          node,
          _code,
        );
      }
    });
  }
}
