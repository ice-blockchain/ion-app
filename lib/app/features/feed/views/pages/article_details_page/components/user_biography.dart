// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/feed/views/components/user_info_menu/user_info_menu.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_about.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/user_info/user_info_summary.dart';

class UserBiography extends StatelessWidget {
  const UserBiography({required this.pubkey, super.key});

  final String pubkey;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: context.theme.appColors.onPrimaryAccent,
        borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
        border: Border.all(
          width: 1.0.s,
          color: context.theme.appColors.onTerararyFill,
        ),
      ),
      padding: EdgeInsets.all(
        12.0.s,
      ),
      child: Column(
        children: [
          UserInfo(
            pubkey: pubkey,
            trailing: UserInfoMenu(pubkey: pubkey),
          ),
          SizedBox(height: 12.0.s),
          ProfileAbout(pubkey: pubkey),
          SizedBox(height: 12.0.s),
          UserInfoSummary(pubkey: pubkey),
        ],
      ),
    );
  }
}