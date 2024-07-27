import 'package:ice/app/features/wallets/domain/wallets_repository.dart';
import 'package:ice/app/services/storage/local_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockLocalStorage extends Mock implements LocalStorage {}

class MockWalletRepository extends Mock implements WalletsRepository {}
