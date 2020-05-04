# matrix_rotate_arbitrary_axis

Library to generate rotation matrix around arbitrary axis.

Original implementation of `RotationMatrix` class (`matrix_rotate_arbitrary_axis.dart`) by [Glenn Murray](https://sites.google.com/site/glennmurray/Home/rotation-matrices-and-formulas).

## Usage

If you want to apply rotation matrix to canvas in Flutter you can just call:

```dart
// Build a rotation matrix for rotations about the line through (a, b, c)  parallel to [u, v, w] by the angle theta. 
final rotationMatrix = RotationMatrix(a, b, c, u, v, w, angleInRadians);
final matrix = rotationMatrix.getMatrix();
canvas.transform(matrix2);
```

The parameters are:

 - [a] x-coordinate of a point on the line of rotation.
 - [b] y-coordinate of a point on the line of rotation.
 - [c] z-coordinate of a point on the line of rotation.
 - [uUn] x-coordinate of the line's direction vector (unnormalized).
 - [vUn] y-coordinate of the line's direction vector (unnormalized).
 - [wUn] z-coordinate of the line's direction vector (unnormalized).
 - [theta] The angle of rotation, in radians.