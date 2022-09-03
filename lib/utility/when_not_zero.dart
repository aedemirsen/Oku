import 'package:flutter/material.dart';

Future<Size> whenNotZero(Stream<Size> source) async {
  await for (Size value in source) {
    if (value.height > 0 && value.width > 0) {
      return value;
    }
  }
  return const Size(0, 0);
}
