// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class TextEditorTypingListener {
  TextEditorTypingListener({
    required this.controller,
    required this.focusNode,
    required this.context,
    required this.ref,
  });

  final QuillController controller;
  final FocusNode focusNode;
  final BuildContext context;
  final WidgetRef ref;
  Timer? _debounce;
  String? previousText;
  int? _lastCursorPosition;

  void initialize() {
    controller.addListener(editorListener);
    focusNode.addListener(_focusListener);
  }

  void dispose() {
    controller.removeListener(editorListener);
    focusNode.removeListener(_focusListener);
    _debounce?.cancel();
  }

  @protected
  void editorListener() {
    final cursorIndex = controller.selection.baseOffset;
    final text = controller.document.toPlainText();

    final isBackspace = previousText != null && text.length < previousText!.length;
    final cursorMoved = _lastCursorPosition != null && _lastCursorPosition != cursorIndex;

    previousText = text;
    _lastCursorPosition = cursorIndex;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1), () {
      onTextChanged(text, cursorIndex, isBackspace, cursorMoved);
    });
  }

  void _focusListener() {
    if (!focusNode.hasFocus) {
      onFocusLost();
    }
  }

  void triggerListener() {
    editorListener();
  }

  bool isWordBoundary(String char) {
    return char == ' ' || char == '\n' || isPunctuation(char);
  }

  bool isPunctuation(String char) {
    const regularPunctuation = '.,;:!?()[]{}"\'\\/\\`~=+<>*&^%_-|';
    const specialQuotes = '\u2018\u2019\u201C\u201D\u2032\u2035\u00B4\u0060\u00AB\u00BB';
    return regularPunctuation.contains(char) || specialQuotes.contains(char);
  }

  void onTextChanged(String text, int cursorIndex, bool isBackspace, bool cursorMoved);
  void onFocusLost();
}
