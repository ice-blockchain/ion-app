// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/wallets/views/utils/crypto_formatter.dart';

import '../../../../test_utils.dart';

void main() {
  group('formatCrypto', () {
    group('zero values', () {
      test('formats zero as 0.00', () {
        expect(formatCrypto(0), '0.00');
      });
    });

    group('values >= 10 (maximum 2 decimal places, minimum 2)', () {
      parameterizedGroup('large values formatting', [
        (value: 11.0, expected: '11.00'),
        (value: 100.0, expected: '100.00'),
        (value: 100.5, expected: '100.50'),
        (value: 100.55, expected: '100.55'),
        (value: 1000.0, expected: '1,000.00'),
        (value: 1000.12, expected: '1,000.12'),
        (value: 1000.123, expected: '1,000.12'),
        (value: 1234567.89, expected: '1,234,567.89'),
        (value: 1234567.999, expected: '1,234,568.99'),
        (value: 50.0, expected: '50.00'),
        (value: 99.99, expected: '99.99'),
        (value: 10.1, expected: '10.10'),
        (value: 999.999, expected: '1,000.00'),
      ], (t) {
        test('formatCrypto(${t.value}) returns ${t.expected}', () {
          expect(formatCrypto(t.value), t.expected);
        });
      });
    });

    group('values >= 1 and < 10 (maximum 6 decimal places)', () {
      parameterizedGroup('medium values formatting', [
        (value: 1.0, expected: '1.00'),
        (value: 1.5, expected: '1.50'),
        (value: 1.12, expected: '1.12'),
        (value: 1.123456, expected: '1.123456'),
        (value: 1.1234567, expected: '1.123456'),
        (value: 9.0, expected: '9.00'),
        (value: 9.99, expected: '9.99'),
        (value: 9.999999, expected: '9.999999'),
        (value: 5.123, expected: '5.123'),
        (value: 2.000001, expected: '2.000001'),
        (value: 2.0000001, expected: '2.00'),
        (value: 3.1415926, expected: '3.141592'),
      ], (t) {
        test('formatCrypto(${t.value}) returns ${t.expected}', () {
          expect(formatCrypto(t.value), t.expected);
        });
      });
    });

    group('values < 1 (maximum 6 decimal places)', () {
      parameterizedGroup('small values formatting', [
        (value: 0.1, expected: '0.10'),
        (value: 0.12, expected: '0.12'),
        (value: 0.123, expected: '0.123'),
        (value: 0.1234, expected: '0.1234'),
        (value: 0.12345, expected: '0.12345'),
        (value: 0.123456, expected: '0.123456'),
        (value: 0.1234567, expected: '0.123456'),
        (value: 0.001, expected: '0.001'),
        (value: 0.0001, expected: '0.0001'),
        (value: 0.00001, expected: '0.00001'),
        (value: 0.000001, expected: '0.000001'),
        (value: 0.0000001, expected: '0.00'),
        (value: 0.999999, expected: '0.999999'),
        (value: 0.5, expected: '0.50'),
      ], (t) {
        test('formatCrypto(${t.value}) returns ${t.expected}', () {
          expect(formatCrypto(t.value), t.expected);
        });
      });
    });

    group('with currency symbol', () {
      parameterizedGroup('currency formatting', [
        (value: 0.0, currency: 'BTC', expected: '0.00 BTC'),
        (value: 1.5, currency: 'ETH', expected: '1.50 ETH'),
        (value: 1000.12, currency: 'USD', expected: '1,000.12 USD'),
        (value: 0.00001, currency: 'SATS', expected: '0.00001 SATS'),
        (value: 0.0000119, currency: 'SATS', expected: '0.000011 SATS'),
        (value: 11.0, currency: 'DOGE', expected: '11.00 DOGE'),
        (value: 11.099999999, currency: 'DOGE', expected: '11.09 DOGE'),
        (value: 0.123456, currency: 'ADA', expected: '0.123456 ADA'),
      ], (t) {
        test('formatCrypto(${t.value}, ${t.currency}) returns ${t.expected}', () {
          expect(formatCrypto(t.value, t.currency), t.expected);
        });
      });

      test('null currency returns value without suffix', () {
        expect(formatCrypto(1.5), '1.50');
      });
    });

    group('boundary values', () {
      test('handles values exactly at boundaries', () {
        expect(formatCrypto(1), '1.00');
        expect(formatCrypto(10), '10.00');
        expect(formatCrypto(0.999999), '0.999999');
        expect(formatCrypto(0.9999999), '0.999999');
        expect(formatCrypto(10.000001), '10.00');
      });
    });

    group('edge cases', () {
      test('handles very small numbers correctly', () {
        expect(formatCrypto(1e-7), '0.00');
        expect(formatCrypto(1e-6), '0.000001');
        expect(formatCrypto(1.23e-6), '0.000001');
      });
    });
  });
}
