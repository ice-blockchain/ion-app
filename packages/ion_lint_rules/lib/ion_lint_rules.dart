// SPDX-License-Identifier: ice License 1.0

import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:ion_lint_rules/rules/prefer_alignment_directional.dart';
import 'package:ion_lint_rules/rules/prefer_border_directional.dart';
import 'package:ion_lint_rules/rules/prefer_border_radius_directional.dart';
import 'package:ion_lint_rules/rules/prefer_edge_insets_directional.dart';
import 'package:ion_lint_rules/rules/prefer_positioned_directional.dart';

// This is the entrypoint of our custom linter
PluginBase createPlugin() => _CustomLinter();

/// A plugin class is used to list all the assists/lints defined by a plugin.
class _CustomLinter extends PluginBase {
  /// We list all the custom warnings/infos/errors
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const PreferEdgeInsetsDirectionalRule(),
        const PreferAlignmentDirectionalRule(),
        const PreferBorderRadiusDirectionalRule(),
        const PreferPositionedDirectionalRule(),
        const PreferBorderDirectionalRule(),
      ];
}
