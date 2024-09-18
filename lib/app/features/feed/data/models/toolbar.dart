import 'package:ice/generated/assets.gen.dart';

enum ToolbarType {
  post,
  article;

  List<ToolbarButtonType> get buttons {
    switch (this) {
      case ToolbarType.post:
        return [
          ToolbarButtonType.gallery,
          ToolbarButtonType.poll,
          ToolbarButtonType.font,
          ToolbarButtonType.spacer,
          ToolbarButtonType.send,
        ];
      case ToolbarType.article:
        return [
          ToolbarButtonType.gallery,
          ToolbarButtonType.font,
          ToolbarButtonType.spacer,
          ToolbarButtonType.send,
        ];
    }
  }
}

enum ToolbarButtonType {
  gallery,
  poll,
  font,
  spacer,
  send;

  String? get iconAsset {
    switch (this) {
      case ToolbarButtonType.gallery:
        return Assets.svg.iconGalleryOpen;
      case ToolbarButtonType.poll:
        return Assets.svg.iconPostPoll;
      case ToolbarButtonType.font:
        return Assets.svg.iconPostRegulartextOff;
      case ToolbarButtonType.send:
        return Assets.svg.sendbuttonDisabled;
      case ToolbarButtonType.spacer:
        return null;
    }
  }
}
