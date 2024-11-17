// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reply_data_notifier.g.dart';

@riverpod
class ReplyDataNotifier extends _$ReplyDataNotifier {
  @override
  String build() {
    return '';
  }

  set text(String newValue) {
    state = newValue;
  }

  void clear() {
    state = '';
  }
}
