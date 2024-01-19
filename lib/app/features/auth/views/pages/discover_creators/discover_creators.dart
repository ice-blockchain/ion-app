import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/mocked_creators.dart';
import 'package:ice/app/shared/widgets/navigation_header/navigation_header.dart';
import 'package:ice/app/shared/widgets/search/search.dart';
import 'package:ice/app/shared/widgets/title_description_header/title_description_header.dart';
import 'package:ice/app/values/constants.dart';
import 'package:ice/generated/assets.gen.dart';

class DiscoverCreators extends HookConsumerWidget {
  const DiscoverCreators({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<String> searchText = useState('');

    final ValueNotifier<Set<User>> selectedCreatorsNotifier =
        useState<Set<User>>(<User>{});
    final Set<User> selectedCreators = selectedCreatorsNotifier.value;

    final List<User> filteredCreators = searchText.value.isEmpty
        ? creators
        : creators.where((User creator) {
            final String searchLower = searchText.value.toLowerCase().trim();
            final String nameLower = creator.name.toLowerCase();
            final String nicknameLower = creator.nickname.toLowerCase();
            return nameLower.contains(searchLower) ||
                nicknameLower.contains(searchLower);
          }).toList();

    return Scaffold(
      body: Container(
        width: double.infinity,
        color: context.theme.appColors.secondaryBackground,
        child: Stack(
          children: <Widget>[
            const NavigationHeader(title: ''),
            Padding(
              padding: const EdgeInsets.only(
                top: navigationHeaderHeight,
                left: kDefaultSidePadding,
                right: kDefaultSidePadding,
              ),
              child: Column(
                children: <Widget>[
                  const TitleDescription(
                    title: 'Discover creators',
                    description:
                        'Connect with visionaries and inspiring voices',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Search(
                      onTextChanged: (String value) => searchText.value = value,
                      onClearText: () {
                        searchText.value = '';
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCreators.length,
                      itemBuilder: (BuildContext context, int index) {
                        final User creator = filteredCreators[index];
                        final bool isSelected =
                            selectedCreators.contains(creator);

                        return InkWell(
                          onTap: () {
                            final Set<User> newSelectedCreators =
                                Set<User>.from(selectedCreators);
                            if (isSelected) {
                              newSelectedCreators.remove(creator);
                            } else {
                              newSelectedCreators.add(creator);
                            }
                            selectedCreatorsNotifier.value =
                                newSelectedCreators;
                          },
                          child: Container(
                            height: 66,
                            decoration: BoxDecoration(
                              color:
                                  context.theme.appColors.tertararyBackground,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            margin: const EdgeInsets.only(
                              bottom: 12,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultSidePadding,
                            ),
                            child: Row(
                              children: <Widget>[
                                if (creator.imageUrl != null &&
                                    creator.imageUrl!.isNotEmpty)
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.network(
                                      creator.imageUrl!,
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        creator.name,
                                        style: context
                                            .theme.appTextThemes.subtitle2
                                            .copyWith(
                                          color: context
                                              .theme.appColors.primaryText,
                                        ),
                                      ),
                                      if (creator.isVerified ?? false)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 4,
                                            top: 2,
                                          ),
                                          child: Image.asset(
                                            Assets.images.verifiedBadge.path,
                                            width: 16,
                                            height: 16,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: isSelected
                                      ? Image.asset(
                                          Assets.images.checkboxon.path,
                                        )
                                      : Image.asset(
                                          Assets.images.checkboxoff.path,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
