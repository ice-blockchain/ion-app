// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client_example/pages/wallet_transfer_requests/providers/wallet_transfer_requests_provider.r.dart';

class WalletTransferRequestsPage extends ConsumerStatefulWidget {
  const WalletTransferRequestsPage({
    required this.walletId,
    super.key,
  });

  final String walletId;

  @override
  ConsumerState<WalletTransferRequestsPage> createState() => _WalletTransferRequestsPageState();
}

class _WalletTransferRequestsPageState extends ConsumerState<WalletTransferRequestsPage> {
  String? _nextPageToken;

  @override
  Widget build(BuildContext context) {
    final transferRequestsAsyncValue = ref.watch(
      walletTransferRequestsProvider(widget.walletId, pageToken: _nextPageToken),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet Transfer Requests')),
      body: transferRequestsAsyncValue.when(
        data: (transferRequests) => _buildTransferRequestsList(transferRequests),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildTransferRequestsList(WalletTransferRequests transferRequests) {
    if (transferRequests.items.isEmpty) {
      return const Center(child: Text('No transfer requests found'));
    }
    return ListView.builder(
      itemCount: transferRequests.items.length + 1,
      itemBuilder: (context, index) {
        if (index == transferRequests.items.length) {
          return _buildLoadMoreButton(transferRequests.nextPageToken);
        }
        return _buildTransferRequestItem(transferRequests.items[index]);
      },
    );
  }

  Widget _buildTransferRequestItem(WalletTransferRequest request) {
    return ListTile(
      title: Text('ID: ${request.id}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status: ${request.status}'),
          Text('Network: ${request.network}'),
          Text('Date Requested: ${request.dateRequested}'),
        ],
      ),
      onTap: () {
        // TODO: Implement transfer request details view
      },
    );
  }

  Widget _buildLoadMoreButton(String? nextPageToken) {
    if (nextPageToken == null) {
      return const SizedBox.shrink();
    }
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _nextPageToken = nextPageToken;
        });
      },
      child: const Text('Load More'),
    );
  }
}
