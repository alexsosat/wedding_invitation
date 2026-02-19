import "dart:math" as math;

import "package:flutter/material.dart";

/// A set of useful extensions for the [Color] class.
extension ColorExtension on Color {
  /// Returns a Color object from a hexadecimal string.
  ///
  /// String is in the format "aabbcc"
  /// or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final StringBuffer buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write("ff");
    }
    buffer.write(hexString.replaceFirst("#", ""));

    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Returns a String representation of the color in hexadecimal format.
  /// [leadingHashSign] adds a leading hash sign to the string.
  /// [alphaRadix] includes the alpha channel in the string.
  String toHex({bool leadingHashSign = true, bool alphaRadix = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${alphaRadix ? alpha.toRadixString(16).padLeft(2, '0') : ''}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  /// Darkens the color with the given integer percentage amount.
  /// Defaults to 10%.
  Color darken([int amount = 10]) {
    if (amount <= 0) {
      return this;
    }
    if (amount > 100) {
      return Colors.black;
    }
    final HSLColor hsl = HSLColor.fromColor(this);

    return hsl
        .withLightness(math.min(1, math.max(0, hsl.lightness - amount / 100)))
        .toColor();
  }

  /// Brightens the color with the given integer percentage amount.
  /// Defaults to 10%.
  Color brighten([int amount = 10]) {
    if (amount <= 0) {
      return this;
    }
    if (amount > 100) {
      return Colors.white;
    }
    final int operations = (255 * -(amount / 100)).round();
    final Color color = Color.fromARGB(
      alpha,
      math.max(0, math.min(255, red - operations)),
      math.max(0, math.min(255, green - operations)),
      math.max(0, math.min(255, blue - operations)),
    );

    return color;
  }

  /// Lightens the color with the given integer percentage amount.
  /// Defaults to 10%.
  Color lighten([int amount = 10]) {
    if (amount <= 0) {
      return this;
    }
    if (amount > 100) {
      return Colors.white;
    }
    // HSLColor returns saturation 1 for black, we want 0 instead to be able
    // lighten black color up along the grey scale from black.
    final HSLColor hsl = this == const Color(0xFF000000)
        ? HSLColor.fromColor(this).withSaturation(0)
        : HSLColor.fromColor(this);

    return hsl
        .withLightness(math.min(1, math.max(0, hsl.lightness + amount / 100)))
        .toColor();
  }
}
