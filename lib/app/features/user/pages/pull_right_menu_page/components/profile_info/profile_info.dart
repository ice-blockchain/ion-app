import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/components/profile_info/components/background_picture/background_picture.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/components/profile_info/components/profile_details/profile_details.dart';

class ProfileInfo extends HookWidget {
  const ProfileInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final detailsKey = GlobalKey();
    final bottomOverflow = useState<double>(30.0.s);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final renderBox = detailsKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          bottomOverflow.value = renderBox.size.height / 3;
        }
      },
    );

    return Container(
      margin: EdgeInsets.only(
        bottom: bottomOverflow.value + 20.0.s,
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          const BackgroundPicture(),
          Positioned(
            bottom: -bottomOverflow.value,
            left: 0,
            right: 0,
            child: ProfileDetails(key: detailsKey),
          ),
        ],
      ),
    );
  }
}
