// SPDX-License-Identifier: ice License 1.0

part of '../../messaging_bottom_bar_initial.dart';

final double moreContentHeight = 206.0.s;

class _MoreContentView extends StatelessWidget {
  const _MoreContentView();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: moreContentHeight,
      width: double.infinity,
      color: context.theme.appColors.secondaryBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Assets.svg.walletChatPhotos.icon(
                    size: 48.0.s,
                  ),
                  SizedBox(width: 8.0.s),
                  Text(
                    context.i18n.common_photos,
                    style: context.theme.appTextThemes.body2,
                  ),
                ],
              ),
              Column(
                children: [
                  Assets.svg.walletChatCamera.icon(
                    size: 48.0.s,
                  ),
                  SizedBox(width: 8.0.s),
                  Text(
                    context.i18n.common_camera,
                    style: context.theme.appTextThemes.body2,
                  ),
                ],
              ),
              Column(
                children: [
                  Assets.svg.walletChatIonpay.icon(
                    size: 48.0.s,
                  ),
                  SizedBox(width: 8.0.s),
                  Text(
                    context.i18n.common_ion_pay,
                    style: context.theme.appTextThemes.body2,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30.0.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Assets.svg.walletChatPerson.icon(
                    size: 48.0.s,
                  ),
                  SizedBox(width: 8.0.s),
                  Text(
                    context.i18n.common_profile,
                    style: context.theme.appTextThemes.body2,
                  ),
                ],
              ),
              Column(
                children: [
                  Assets.svg.walletChatDocument.icon(
                    size: 48.0.s,
                  ),
                  SizedBox(width: 8.0.s),
                  Text(
                    context.i18n.common_document,
                    style: context.theme.appTextThemes.body2,
                  ),
                ],
              ),
              Column(
                children: [
                  Assets.svg.walletChatPoll.icon(
                    size: 48.0.s,
                  ),
                  SizedBox(width: 8.0.s),
                  Text(
                    context.i18n.common_poll,
                    style: context.theme.appTextThemes.body2,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
