// SPDX-License-Identifier: ice License 1.0

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

class IonIdentityClientTestPage extends ConsumerWidget {
  const IonIdentityClientTestPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ionClient = ref.watch(ionApiClientProvider).valueOrNull;
    if (ionClient == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return const DefaultTabController(
      length: 6,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'Register'),
                  Tab(text: 'Login'),
                  Tab(text: 'Users'),
                  Tab(text: 'Wallets'),
                  Tab(text: 'Recovery'),
                  Tab(text: 'Recover User'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _RegisterTab(),
                    _LoginTab(),
                    _UsersTab(),
                    _WalletsTab(),
                    _RecoveryTab(),
                    _RecoverUserTab(),
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
    final ionClient = ref.watch(ionApiClientProvider).requireValue;
    final usernameController = useTextEditingController(text: 'testauth1@mail.com');

    final registerResult = useState<RegisterUserResult?>(null);

    return Column(
      children: [
        SizedBox(height: 16.0.s),
        TextInput(controller: usernameController),
        SizedBox(height: 16.0.s),
        if (registerResult.value != null) ...[
          Text('$registerResult'),
          SizedBox(height: 16.0.s),
        ],
        Button(
          label: const Text('Register'),
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
    final ionClient = ref.watch(ionApiClientProvider).requireValue;
    final usernameController = useTextEditingController(text: 'testauth1@mail.com');

    final loginResult = useState<LoginUserResult?>(null);

    return ListView(
      children: [
        SizedBox(height: 16.0.s),
        TextInput(controller: usernameController),
        SizedBox(height: 16.0.s),
        if (loginResult.value != null) ...[
          Text('$loginResult'),
          SizedBox(height: 16.0.s),
        ],
        Button(
          label: const Text('Login'),
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
    final ionClient = ref.watch(ionApiClientProvider).requireValue;

    return StreamBuilder(
      stream: ionClient.authorizedUsers,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
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

class UserWalletsDialog extends ConsumerWidget {
  const UserWalletsDialog({
    required this.username,
    super.key,
  });

  final String username;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ionClient = ref.watch(ionApiClientProvider).requireValue;

    return SheetContent(
      body: FutureBuilder(
        future: ionClient(username: username).wallets.listWallets(),
        builder: (context, snapshot) {
          final isLoading = !snapshot.hasData;

          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = switch (snapshot.data) {
            ListWalletsSuccess(wallets: final wallets) => wallets,
            _ => <Wallet>[],
          };

          return ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListItem.text(
                title: Text(data[index].id),
                value: data[index].network,
              );
            },
          );
        },
      ),
    );
  }
}

class _WalletsTab extends HookConsumerWidget {
  const _WalletsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ionClient = ref.watch(ionApiClientProvider).requireValue;

    final walletNameController = useTextEditingController.fromValue(
      const TextEditingValue(text: 'My Wallet 1'),
    );

    return ListView(
      children: [
        SizedBox(height: 16.0.s),
        TextInput(controller: walletNameController),
        SizedBox(height: 16.0.s),
        Button(
          label: const Text('Create Wallet'),
          onPressed: () async {
            await ionClient(username: 'testauth1@mail.com').wallets.createWallet(
                  network: 'EthereumSepolia',
                  name: walletNameController.text,
                );
          },
        ),
      ],
    );
  }
}

class _RecoveryTab extends HookConsumerWidget {
  const _RecoveryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ionClient = ref.watch(ionApiClientProvider).requireValue;

    final usernameController = useTextEditingController.fromValue(
      const TextEditingValue(text: 'testauth1@mail.com'),
    );

    final resultState = useState<CreateRecoveryCredentialsResult?>(null);

    return ListView(
      children: [
        SizedBox(height: 16.0.s),
        TextInput(controller: usernameController),
        SizedBox(height: 16.0.s),
        Button(
          label: const Text('Create Recovery Credentials'),
          onPressed: () async {
            resultState.value =
                await ionClient(username: usernameController.text).auth.createRecoveryCredentials();
          },
        ),
        if (resultState.value != null) ...[
          SizedBox(height: 16.0.s),
          SelectableText('$resultState'),
        ],
      ],
    );
  }
}

class _RecoverUserTab extends HookConsumerWidget {
  const _RecoverUserTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ionClient = ref.watch(ionApiClientProvider).requireValue;

    final usernameController = useTextEditingController.fromValue(
      const TextEditingValue(text: 'my@mail.com'),
    );
    final credentialIdController = useTextEditingController();
    final recoveryKeyController = useTextEditingController();

    final resultState = useState<dynamic>(null);

    return ListView(
      children: [
        SizedBox(height: 16.0.s),
        TextInput(controller: usernameController, labelText: 'Username'),
        SizedBox(height: 16.0.s),
        TextInput(controller: credentialIdController, labelText: 'Credential ID'),
        SizedBox(height: 16.0.s),
        TextInput(controller: recoveryKeyController, labelText: 'Recovery Key'),
        SizedBox(height: 16.0.s),
        Button(
          label: const Text('Recover User'),
          onPressed: () async {
            resultState.value = await ionClient(username: usernameController.text).auth.recoverUser(
                  credentialId: credentialIdController.text,
                  recoveryKey: recoveryKeyController.text,
                );
          },
        ),
        SelectableText('$resultState'),
      ],
    );
  }
}
