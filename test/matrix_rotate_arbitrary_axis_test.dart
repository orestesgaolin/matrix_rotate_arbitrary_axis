import 'package:matrix_rotate_arbitrary_axis/matrix_rotate_arbitrary_axis.dart';
import 'package:test/test.dart';

void main() {
  group('constructor', () {
    final a = 0.0;
    final b = 0.0;
    final c = 0.0;
    final v = 0.0;
    final w = 0.0;
    final theta = 0.0;

    test('should create identity matrix for u = 1', () {
      final u1 = 1.0;
      final rM = RotationMatrix(a, b, c, u1, v, w, theta);
      final m = rM.matrix;
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

    test('should rotate matrix for theta = pi/2', () {
      final u1 = 1.0;
      final theta = 3.1415 / 2;
      final rM = RotationMatrix(a, b, c, u1, v, w, theta);
      final m = rM.matrix;
      assert(m[5] > 0 && m[5] < 0.0001);
      assert(m[6] > 0.999 && m[6] < 1.0);
      assert(m[9] > -1 && m[9] < -0.999);
    });
  });
}
