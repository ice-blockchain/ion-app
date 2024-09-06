import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/services/ion_identity_client/ion_identity_client_provider.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/wallets/types/list_wallets_result.dart';

class IonIdentityClientTestPage extends StatelessWidget {
  const IonIdentityClientTestPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: 'Register'),
                  Tab(text: 'Login'),
                  Tab(text: 'Users'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _RegisterTab(),
                    _LoginTab(),
                    _UsersTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterTab extends HookConsumerWidget {
  const _RegisterTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ionClient = ref.watch(ionApiClientProvider);
    final usernameController = useTextEditingController(text: 'user1@mail.com');

    final registerResult = useState<RegisterUserResult?>(null);

    return Column(
      children: [
        SizedBox(height: 16.0.s),
        TextInput(
          controller: usernameController,
        ),
        SizedBox(height: 16.0.s),
        if (registerResult.value != null) ...[
          Text('$registerResult'),
          SizedBox(height: 16.0.s),
        ],
        Button(
          label: Text('Register'),
          onPressed: () async {
            registerResult.value =
                await ionClient(username: usernameController.text).auth.registerUser();
          },
        ),
      ],
    );
  }
}

class _LoginTab extends HookConsumerWidget {
  const _LoginTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ionClient = ref.watch(ionApiClientProvider);
    final usernameController = useTextEditingController(text: 'user1@mail.com');

    final loginResult = useState<LoginUserResult?>(null);

    return Column(
      children: [
        SizedBox(height: 16.0.s),
        TextInput(
          controller: usernameController,
        ),
        SizedBox(height: 16.0.s),
        if (loginResult.value != null) ...[
          Text('$loginResult'),
          SizedBox(height: 16.0.s),
        ],
        Button(
          label: Text('Login'),
          onPressed: () async {
            loginResult.value = await ionClient(username: usernameController.text).auth.loginUser();
          },
        ),
      ],
    );
  }
}

class _UsersTab extends ConsumerWidget {
  const _UsersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ionClient = ref.watch(ionApiClientProvider);

    return StreamBuilder(
      stream: ionClient.authorizedUsers,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final users = snapshot.data!.toList();

        return ListView.separated(
          itemCount: users.length,
          separatorBuilder: (_, __) => FeedListSeparator(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => showModalBottomSheet<void>(
                context: context,
                builder: (context) => UserWalletsDialog(username: users[index]),
              ),
              child: ListItem.textWithIcon(
                title: Text(users[index]),
                icon: GestureDetector(
                  onTap: () {
                    ionClient(username: users[index]).auth.logOut();
                  },
                  child: Assets.svg.iconMenuLogout.icon(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class UserWalletsDialog extends HookConsumerWidget {
  const UserWalletsDialog({
    required this.username,
    super.key,
  });

  final String username;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ionClient = ref.watch(ionApiClientProvider);

    final walletsFuture = useFuture(ionClient(username: username).wallets.listWallets());

    final isLoading = !walletsFuture.hasData;
    final data = switch (walletsFuture.data) {
      ListWalletsSuccess(wallets: final wallets) => wallets,
      _ => <Wallet>[],
    };

    return SheetContent(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListItem.text(
                  title: Text('${data[index].id}'),
                  value: data[index].network,
                );
              },
            ),
    );
  }
}
