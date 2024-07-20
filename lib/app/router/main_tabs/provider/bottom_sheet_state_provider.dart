// import 'package:ice/app/router/main_tabs/components/tab_item.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'bottom_sheet_state_provider.g.dart';

// @Riverpod(keepAlive: true)
// class BottomSheetState extends _$BottomSheetState {
//   @override
//   Map<TabItem, bool> build() => {
//         for (final tab in TabItem.values)
//           if (tab != TabItem.main) tab: false,
//       };

//   void setSheetState(TabItem tab, {required bool isOpen}) {
//     state = {...state, tab: isOpen};
//   }

//   void closeCurrentSheet(TabItem currentTab) {
//     if (state[currentTab] ?? false) {
//       state = {...state, currentTab: false};
//     }
//   }

//   bool isSheetOpen(TabItem tab) => state[tab] ?? false;
// }
