// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

String encodeArticleContent(QuillController controller) {
  return jsonEncode(controller.document.toDelta().toJson());
}

QuillController decodeArticleContent(String encodedContent) {
  final decodedJson = jsonDecode(encodedContent);

  if (decodedJson is List<dynamic>) {
    final delta = Delta.fromJson(decodedJson);
    return QuillController(
      document: Document.fromDelta(delta),
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
    );
  } else {
    throw const FormatException('Invalid content format for Quill Delta');
  }
}
