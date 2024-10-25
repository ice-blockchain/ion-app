// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

enum CodeBlockType {
  plainText,
  swift,
  c,
  cPlusPlus,
  cSharp,
  css,
  java,
  javascript,
  python,
  dart;

  String getTitle(BuildContext context) => switch (this) {
        CodeBlockType.plainText => context.i18n.code_block_type_plain_text,
        CodeBlockType.swift => context.i18n.code_block_type_swift,
        CodeBlockType.c => context.i18n.code_block_type_c,
        CodeBlockType.cPlusPlus => context.i18n.code_block_type_c_plus_plus,
        CodeBlockType.cSharp => context.i18n.code_block_type_c_sharp,
        CodeBlockType.css => context.i18n.code_block_type_css,
        CodeBlockType.java => context.i18n.code_block_type_java,
        CodeBlockType.javascript => context.i18n.code_block_type_javascript,
        CodeBlockType.python => context.i18n.code_block_type_python,
        CodeBlockType.dart => context.i18n.code_block_type_dart,
      };
}
