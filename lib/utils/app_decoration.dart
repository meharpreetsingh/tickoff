import 'package:flutter/material.dart';
import 'constants/app_dimen.dart';

/// Common decorations and styling helpers
class AppDecoration {
  /// Card decoration
  static BoxDecoration cardDecoration({
    Color? color,
    double? borderRadius,
    BoxBorder? border,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius ?? AppDimen.radiusLg),
      border: border,
    );
  }

  /// Container decoration with shadow
  static BoxDecoration containerWithShadow({
    Color? color,
    double? borderRadius,
    double elevation = AppDimen.elevationMd,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius ?? AppDimen.radiusLg),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: elevation,
          offset: Offset(0, elevation / 2),
        ),
      ],
    );
  }

  /// Button decoration
  static BoxDecoration buttonDecoration({
    Color? backgroundColor,
    double? borderRadius,
    BoxBorder? border,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius ?? AppDimen.radiusMd),
      border: border,
    );
  }

  /// Circle decoration
  static BoxDecoration circleDecoration({
    required Color color,
    BoxBorder? border,
  }) {
    return BoxDecoration(color: color, shape: BoxShape.circle, border: border);
  }

  /// Gradient decoration
  static BoxDecoration gradientDecoration({
    required List<Color> colors,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    double? borderRadius,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: begin ?? Alignment.topLeft,
        end: end ?? Alignment.bottomRight,
        colors: colors,
      ),
      borderRadius: BorderRadius.circular(borderRadius ?? AppDimen.radiusLg),
    );
  }

  /// Input field decoration
  static InputDecoration inputDecoration({
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isDense = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isDense: isDense,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimen.radiusMd),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimen.radiusMd),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimen.radiusMd),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimen.paddingMd,
        vertical: AppDimen.paddingMd,
      ),
    );
  }

  /// Divider decoration
  static BoxDecoration dividerDecoration({
    required Color color,
    double height = 1.0,
  }) {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(color: color, width: height),
      ),
    );
  }

  /// Border decoration
  static BoxDecoration borderDecoration({
    required Color color,
    double width = 1.0,
    double? borderRadius,
  }) {
    return BoxDecoration(
      border: Border.all(color: color, width: width),
      borderRadius: BorderRadius.circular(borderRadius ?? AppDimen.radiusMd),
    );
  }
}
