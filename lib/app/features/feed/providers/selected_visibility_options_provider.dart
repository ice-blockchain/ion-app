// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/feed/data/models/visibility_settings_options.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_visibility_options_provider.g.dart';

@riverpod
class SelectedVisibilityOptions extends _$SelectedVisibilityOptions {
  @override
  VisibilitySettingsOptions build() {
    return VisibilitySettingsOptions.everyone;
  }

  set selectedOption(VisibilitySettingsOptions option) {
    state = option;
  }
}
