import 'package:ice/generated/assets.gen.dart';

enum NftLayoutType {
  list,
  grid;

  AssetGenImage get iconAsset {
    return switch (this) {
      NftLayoutType.grid => Assets.images.icons.iconBlockGrid,
      NftLayoutType.list => Assets.images.icons.iconBlockList,
    };
  }
}
