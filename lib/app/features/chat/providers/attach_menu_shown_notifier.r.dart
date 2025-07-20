import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'attach_menu_shown_notifier.r.g.dart';

///
/// Notifier to manage the visibility of the attachment menu in chat
///
@riverpod
class AttachMenuShown extends _$AttachMenuShown {
  @override
  bool build() {
    return false;
  }

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }

  void toggle() {
    state = !state;
  }
}
