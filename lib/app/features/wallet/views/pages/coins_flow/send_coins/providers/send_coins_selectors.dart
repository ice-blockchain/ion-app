import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/providers/send_coins_form_provider.dart';

int? arrivalTimeSelector(WidgetRef ref) => ref.watch(
      sendCoinsFormControllerProvider.select((state) => state.arrivalTime),
    );
