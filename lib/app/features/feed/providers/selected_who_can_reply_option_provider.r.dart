// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_who_can_reply_option_provider.r.g.dart';

@riverpod
class SelectedWhoCanReplyOption extends _$SelectedWhoCanReplyOption {
  @override
  WhoCanReplySettingsOption build() {
    return const WhoCanReplySettingsOption.everyone();
  }

  set option(WhoCanReplySettingsOption option) {
    state = option;
  }
}
