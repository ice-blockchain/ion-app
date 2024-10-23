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

  String getTitle(BuildContext context) {
    switch (this) {
      case CodeBlockType.plainText:
        return context.i18n.code_block_type_plain_text;
      case CodeBlockType.swift:
        return context.i18n.code_block_type_swift;
      case CodeBlockType.c:
        return context.i18n.code_block_type_c;
      case CodeBlockType.cPlusPlus:
        return context.i18n.code_block_type_c_plus_plus;
      case CodeBlockType.cSharp:
        return context.i18n.code_block_type_c_sharp;
      case CodeBlockType.css:
        return context.i18n.code_block_type_css;
      case CodeBlockType.java:
        return context.i18n.code_block_type_java;
      case CodeBlockType.javascript:
        return context.i18n.code_block_type_javascript;
      case CodeBlockType.python:
        return context.i18n.code_block_type_python;
      case CodeBlockType.dart:
        return context.i18n.code_block_type_dart;
    }
  }
}
