import 'package:ice/app/features/feed/views/pages/visibility_settings_modal/data/model/visibility_settings_options.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_visibility_option_provider.g.dart';

@riverpod
class SelectedVisibilityOptionNotifier extends _$SelectedVisibilityOptionNotifier {
  @override
  VisibilitySettingsOptions? build() {
    return VisibilitySettingsOptions.everyone;
  }

  set selectedOption(VisibilitySettingsOptions option) {
    state = option;
  }
}
