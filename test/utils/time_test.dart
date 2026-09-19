import 'package:flutter_test/flutter_test.dart';
import 'package:be_right_bark/utils/time.dart';

void main() {
  test('should format timestamp with time and date', () {
    final dateTime = DateTime(2026, 6, 1, 10, 30);
    expect(formatTimestamp(dateTime), '10:30, 1 Jun');
  });

  test('should pad single digit hours with leading zero', () {
    final dateTime = DateTime(2026, 6, 1, 9, 5);
    expect(formatTimestamp(dateTime), '09:05, 1 Jun');
  });

  test('should handle midnight', () {
    final dateTime = DateTime(2026, 1, 15, 0, 0);
    expect(formatTimestamp(dateTime), '00:00, 15 Jan');
  });

  test('should handle end of day', () {
    final dateTime = DateTime(2026, 12, 25, 23, 59);
    expect(formatTimestamp(dateTime), '23:59, 25 Dec');
  });
}
