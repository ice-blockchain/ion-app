import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_nft/components/providers/send_nft_form_provider.dart';

int? arrivalTimeSelector(WidgetRef ref) => ref.watch(
      sendNftFormControllerProvider.select((state) => state.arrivalTime),
    );
