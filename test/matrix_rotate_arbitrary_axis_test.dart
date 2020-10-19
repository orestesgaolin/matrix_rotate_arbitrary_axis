// import 'dart:math' as math;

import 'package:matrix_rotate_arbitrary_axis/matrix_rotate_arbitrary_axis.dart';
import 'package:test/test.dart';

void main() {
  group('constructor', () {
    // final pi = math.pi;
    final a = 0.0;
    final b = 0.0;
    final c = 0.0;
    // final u = 0.0;
    final v = 0.0;
    final w = 0.0;
    final theta = 0.0;

    test('should create identity matrix for u = 1', () {
      final u1 = 1.0;
      final rM = RotationMatrix(a, b, c, u1, v, w, theta);
      final m = rM.getMatrix();
      for (var i = 0; i < 4; i++) {
        for (var j = 0; j < 4; j++) {
          final index = m.index(i, j);
          if (j == i) {
            equals(m.storage[index], 1);
          } else {
            equals(m.storage[index], 0);
          }
        }
      }
    });
  });
}
