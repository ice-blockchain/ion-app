// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/container_skeleton.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/contacts/contacts_list_item.dart';

class ContactsListLoader extends StatelessWidget {
  const ContactsListLoader({
    required this.footer,
    super.key,
  });

  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContainerSkeleton(
          width: MediaQuery.sizeOf(context).width - ScreenSideOffset.defaultSmallMargin * 2,
          height: 16.0.s,
          margin: EdgeInsets.symmetric(vertical: 16.0.s),
        ),
        SizedBox(
          height: ContactsListItem.height,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSideOffset.defaultSmallMargin,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 12.0.s);
            },
            itemBuilder: (BuildContext context, int index) {
              final size = 54.0.s;
              return ContainerSkeleton(
                width: size,
                height: size,
                margin: EdgeInsets.symmetric(
                  vertical: (ContactsListItem.height - size) / 2,
                  horizontal: (ContactsListItem.width - size) / 2,
                ),
              );
            },
          ),
        ),
        footer,
      ],
    );
  }
}
