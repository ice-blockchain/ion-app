import 'package:flutter_test/flutter_test.dart';
import 'package:ice/app/services/storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TestEnum { one, two, three }

const testKey = 'testKey';
const testStringValue = 'testValue';
const testBoolValue = true;
const testDoubleValue = 1.5;
const testEnumValue = TestEnum.two;

void main() {
  late LocalStorage localStorage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    localStorage = LocalStorage(prefs);
  });

  group('LocalStorage', () {
    test('setBool() and getBool()', () {
      localStorage.setBool(key: testKey, value: testBoolValue);

      expect(localStorage.getBool(testKey), testBoolValue);
    });

    test('getBool() returns null when key not found', () {
      expect(
        localStorage.getBool(testKey),
        null,
      );
    });

    test('setDouble() and getDouble()', () {
      localStorage.setDouble(testKey, testDoubleValue);

      expect(localStorage.getDouble(testKey), testDoubleValue);
    });

    test('getDouble() returns null when key not found', () {
      expect(
        localStorage.getDouble(testKey),
        null,
      );
    });

    test('setString() and getString()', () {
      localStorage.setString(testKey, testStringValue);

      expect(
        localStorage.getString(testKey),
        testStringValue,
      );
    });

    test('setEnum() and getEnum()', () {
      localStorage.setEnum(testKey, testEnumValue);

      expect(
        localStorage.getEnum(
          testKey,
          TestEnum.values,
        ),
        testEnumValue,
      );
    });

    test('getEnum() returns null when key not found', () {
      expect(
        localStorage.getEnum(
          testKey,
          TestEnum.values,
        ),
        null,
      );
    });

    test('getEnum() returns null when value is invalid', () {
      localStorage.setString(testKey, 'invalid');

      expect(
        localStorage.getEnum(
          testKey,
          TestEnum.values,
        ),
        null,
      );
    });
  });
}
