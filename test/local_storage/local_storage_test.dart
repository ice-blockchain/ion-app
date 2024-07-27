import 'package:flutter_test/flutter_test.dart';
import 'package:ice/app/services/storage/local_storage.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

enum TestEnum { one, two, three }

const testKey = 'testKey';
const testStringValue = 'testValue';
const testBoolValue = true;
const testDoubleValue = 1.5;
final testEnumValue = TestEnum.two;

void main() {
  late LocalStorage localStorage;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    localStorage = LocalStorage(mockPrefs);
  });

  group('LocalStorage', () {
    test('setBool() calls SharedPreferences.setBool', () async {
      when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);

      await localStorage.setBool(key: testKey, value: testBoolValue);

      verify(() => mockPrefs.setBool(testKey, testBoolValue)).called(1);
    });

    test('getBool() returns correct value', () {
      when(() => mockPrefs.getBool(testKey)).thenReturn(testBoolValue);

      expect(localStorage.getBool(testKey), testBoolValue);
    });

    test('getBool() returns default value when key not found', () {
      when(() => mockPrefs.getBool(testKey)).thenReturn(null);

      expect(localStorage.getBool(testKey, defaultValue: !testBoolValue), !testBoolValue);
    });

    test('setDouble() calls SharedPreferences.setDouble', () async {
      when(() => mockPrefs.setDouble(any(), any())).thenAnswer((_) async => true);

      await localStorage.setDouble(testKey, testDoubleValue);

      verify(() => mockPrefs.setDouble(testKey, testDoubleValue)).called(1);
    });

    test('getDouble() returns correct value', () {
      when(() => mockPrefs.getDouble(testKey)).thenReturn(testDoubleValue);

      expect(localStorage.getDouble(testKey), testDoubleValue);
    });

    test('getDouble() returns default value when key not found', () {
      when(() => mockPrefs.getDouble(testKey)).thenReturn(null);

      expect(localStorage.getDouble(testKey, defaultValue: 0.0), 0.0);
    });

    test('setString() calls SharedPreferences.setString', () async {
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

      await localStorage.setString(testKey, testStringValue);

      verify(() => mockPrefs.setString(testKey, testStringValue)).called(1);
    });

    test('getString() returns correct value', () {
      when(() => mockPrefs.getString(testKey)).thenReturn(testStringValue);

      expect(localStorage.getString(testKey), testStringValue);
    });

    test('setEnum() calls SharedPreferences.setString with correct value', () async {
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

      await localStorage.setEnum(testKey, testEnumValue);

      verify(() => mockPrefs.setString(testKey, testEnumValue.name)).called(1);
    });

    test('getEnum() returns correct enum value', () {
      when(() => mockPrefs.getString(testKey)).thenReturn(testEnumValue.name);

      expect(
        localStorage.getEnum(
          testKey,
          TestEnum.values,
          defaultValue: TestEnum.one,
        ),
        testEnumValue,
      );
    });

    test('getEnum() returns default value when key not found', () {
      when(() => mockPrefs.getString(testKey)).thenReturn(null);

      expect(
        localStorage.getEnum(testKey, TestEnum.values, defaultValue: TestEnum.one),
        TestEnum.one,
      );
    });

    test('getEnum() returns default value when value is invalid', () {
      when(() => mockPrefs.getString(testKey)).thenReturn('invalid');

      expect(
        localStorage.getEnum(testKey, TestEnum.values, defaultValue: TestEnum.one),
        TestEnum.one,
      );
    });
  });
}
