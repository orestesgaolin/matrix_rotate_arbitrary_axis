// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
library matrix_rotate_arbitrary_axis;

import 'dart:math' as math;
// import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

/// Class building a rotation matrix for rotations about the line through (a, b, c)
/// parallel to [u, v, w] by the angle theta.
///
/// Original implementation in Java by Glenn Murray
/// available online on https://sites.google.com/site/glennmurray/Home/rotation-matrices-and-formulas
class RotationMatrix {
  static const TOLERANCE = 1E-9;
  Matrix4 matrix;

  num _m11;
  num _m12;
  num _m13;
  num _m14;
  num _m21;
  num _m22;
  num _m23;
  num _m24;
  num _m31;
  num _m32;
  num _m33;
  num _m34;

  /// Build a rotation matrix for rotations about the line through (a, b, c)
  /// parallel to [u, v, w] by the angle theta.
  ///
  /// [a] x-coordinate of a point on the line of rotation.
  /// [b] y-coordinate of a point on the line of rotation.
  /// [c] z-coordinate of a point on the line of rotation.
  /// [uUn] x-coordinate of the line's direction vector (unnormalized).
  /// [vUn] y-coordinate of the line's direction vector (unnormalized).
  /// [wUn] z-coordinate of the line's direction vector (unnormalized).
  /// [theta] The angle of rotation, in radians.
  RotationMatrix(num a, num b, num c, num uUn, num vUn, num wUn, num theta) {
    num l;
    assert((l = _longEnough(uUn, vUn, wUn)) > 0,
        'RotationMatrix: direction vector too short!');

    // In this instance we normalize the direction vector.
    num u = uUn / l;
    num v = vUn / l;
    num w = wUn / l;

    // Set some intermediate values.
    var u2 = u * u;
    var v2 = v * v;
    var w2 = w * w;
    num cosT = math.cos(theta);
    var oneMinusCosT = 1 - cosT;
    num sinT = math.sin(theta);

    // Build the matrix entries element by element.
    _m11 = u2 + (v2 + w2) * cosT;
    _m12 = u * v * oneMinusCosT - w * sinT;
    _m13 = u * w * oneMinusCosT + v * sinT;
    _m14 = (a * (v2 + w2) - u * (b * v + c * w)) * oneMinusCosT +
        (b * w - c * v) * sinT;

    _m21 = u * v * oneMinusCosT + w * sinT;
    _m22 = v2 + (u2 + w2) * cosT;
    _m23 = v * w * oneMinusCosT - u * sinT;
    _m24 = (b * (u2 + w2) - v * (a * u + c * w)) * oneMinusCosT +
        (c * u - a * w) * sinT;

    _m31 = u * w * oneMinusCosT - v * sinT;
    _m32 = v * w * oneMinusCosT + u * sinT;
    _m33 = w2 + (u2 + v2) * cosT;
    _m34 = (c * (u2 + v2) - w * (a * u + b * v)) * oneMinusCosT +
        (a * v - b * u) * sinT;
  }

  /// Multiply this [RotationMatrix] times the point (x, y, z, 1),
  /// representing a point P(x, y, z) in homogeneous coordinates.  The final
  /// coordinate, 1, is assumed.
  ///
  /// [x] The point's x-coordinate.
  /// [y] The point's y-coordinate.
  /// [z] The point's z-coordinate.
  ///
  /// Returns the product, in a [Vector3], representing the
  /// rotated point.
  Vector3 timesXYZ(num x, num y, num z) {
    final p = Vector3(0.0, 0.0, 0.0);

    p[0] = _m11 * x + _m12 * y + _m13 * z + _m14;
    p[1] = _m21 * x + _m22 * y + _m23 * z + _m24;
    p[2] = _m31 * x + _m32 * y + _m33 * z + _m34;

    return p;
  }

  /// Compute the rotated point from the formula given in the paper, as opposed
  /// to multiplying this matrix by the given point. Theoretically this should
  /// give the same answer as [timesXYZ]. For repeated
  /// calculations this will be slower than using [timesXYZ]
  /// because, in effect, it repeats the calculations done in the constructor.
  ///
  /// This method is static partly to emphasize that it does not
  /// mutate an instance of [RotationMatrix], even though it uses
  /// the same parameter names as the the constructor.
  ///
  /// [a] x-coordinate of a point on the line of rotation.
  /// [b] y-coordinate of a point on the line of rotation.
  /// [c] z-coordinate of a point on the line of rotation.
  /// [u] x-coordinate of the line's direction vector.  This direction
  ///          vector will be normalized.
  /// [v] y-coordinate of the line's direction vector.
  /// [w] z-coordinate of the line's direction vector.
  /// [x] The point's x-coordinate.
  /// [y] The point's y-coordinate.
  /// [z] The point's z-coordinate.
  /// [theta] The angle of rotation, in radians.
  ///
  /// Returns the product, in a [Vector3], representing the
  /// rotated point.
  static Vector3 rotPointFromFormula(num a, num b, num c, num u, num v, num w,
      num x, num y, num z, num theta) {
    // We normalize the direction vector.

    num l;
    if ((l = _longEnough(u, v, w)) < 0) {
      print('RotationMatrix direction vector too short');
      return null; // Don't bother.
    }
    // Normalize the direction vector.
    u = u / l; // Note that is not "this.u".
    v = v / l;
    w = w / l;
    // Set some intermediate values.
    var u2 = u * u;
    var v2 = v * v;
    var w2 = w * w;
    num cosT = math.cos(theta);
    var oneMinusCosT = 1 - cosT;
    num sinT = math.sin(theta);

    // Use the formula in the paper.
    final p = Vector3(0.0, 0.0, 0.0);
    p[0] = (a * (v2 + w2) - u * (b * v + c * w - u * x - v * y - w * z)) *
            oneMinusCosT +
        x * cosT +
        (-c * v + b * w - w * y + v * z) * sinT;

    p[1] = (b * (u2 + w2) - v * (a * u + c * w - u * x - v * y - w * z)) *
            oneMinusCosT +
        y * cosT +
        (c * u - a * w + w * x - u * z) * sinT;

    p[2] = (c * (u2 + v2) - w * (a * u + b * v - u * x - v * y - w * z)) *
            oneMinusCosT +
        z * cosT +
        (-b * u + a * v - v * x + u * y) * sinT;

    return p;
  }

  /// Check whether a vector's length is less than [TOLERANCE].
  ///
  /// [u] The vector's x-coordinate.
  /// [v] The vector's y-coordinate.
  /// [w] The vector's z-coordinate.
  ///
  /// Returns length = math.sqrt(u^2 + v^2 + w^2) if it is greater than
  /// [TOLERANCE], or -1 if not.
  static num _longEnough(num u, num v, num w) {
    num l = math.sqrt(u * u + v * v + w * w);
    if (l > TOLERANCE) {
      return l;
    } else {
      return -1;
    }
  }

  /// Get the resulting matrix.
  ///
  /// Returns The matrix as [Matrix4].
  Matrix4 getMatrix() {
    matrix ??= Matrix4.columns(
      Vector4(_m11, _m21, _m31, 0),
      Vector4(_m12, _m22, _m32, 0),
      Vector4(_m13, _m23, _m33, 0),
      Vector4(_m14, _m24, _m34, 1),
    );
    return matrix;
  }
}
