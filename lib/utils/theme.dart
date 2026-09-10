import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff5d621c),
      surfaceTint: Color(0xff5d621c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffe3e892),
      onPrimaryContainer: Color(0xff464a03),
      secondary: Color(0xff5f6044),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffe4e5c1),
      onSecondaryContainer: Color(0xff47492e),
      tertiary: Color(0xff3c6659),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbeecdb),
      onTertiaryContainer: Color(0xff234e42),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffcfaec),
      onSurface: Color(0xff1c1c14),
      onSurfaceVariant: Color(0xff47483b),
      outline: Color(0xff787869),
      outlineVariant: Color(0xffc9c7b6),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313128),
      inversePrimary: Color(0xffc6cc79),
      primaryFixed: Color(0xffe3e892),
      onPrimaryFixed: Color(0xff1b1d00),
      primaryFixedDim: Color(0xffc6cc79),
      onPrimaryFixedVariant: Color(0xff464a03),
      secondaryFixed: Color(0xffe4e5c1),
      onSecondaryFixed: Color(0xff1b1d07),
      secondaryFixedDim: Color(0xffc8c9a6),
      onSecondaryFixedVariant: Color(0xff47492e),
      tertiaryFixed: Color(0xffbeecdb),
      onTertiaryFixed: Color(0xff002018),
      tertiaryFixedDim: Color(0xffa3d0c0),
      onTertiaryFixedVariant: Color(0xff234e42),
      surfaceDim: Color(0xffdcdace),
      surfaceBright: Color(0xfffcfaec),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f4e7),
      surfaceContainer: Color(0xfff1eee1),
      surfaceContainerHigh: Color(0xffebe8db),
      surfaceContainerHighest: Color(0xffe5e3d6),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff353900),
      surfaceTint: Color(0xff5d621c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff6c7129),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff36381f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6e6f51),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff103d32),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4b7568),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcfaec),
      onSurface: Color(0xff11120a),
      onSurfaceVariant: Color(0xff37372b),
      outline: Color(0xff535346),
      outlineVariant: Color(0xff6e6e60),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313128),
      inversePrimary: Color(0xffc6cc79),
      primaryFixed: Color(0xff6c7129),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff545912),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6e6f51),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff55573b),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4b7568),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff325d50),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc9c7ba),
      surfaceBright: Color(0xfffcfaec),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f4e7),
      surfaceContainer: Color(0xffebe8db),
      surfaceContainerHigh: Color(0xffdfddd0),
      surfaceContainerHighest: Color(0xffd4d2c5),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff2b2f00),
      surfaceTint: Color(0xff5d621c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff484d05),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2c2e15),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff494b30),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff023328),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff265144),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcfaec),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff2c2d21),
      outlineVariant: Color(0xff4a4a3d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313128),
      inversePrimary: Color(0xffc6cc79),
      primaryFixed: Color(0xff484d05),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff323500),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff494b30),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff33341b),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff265144),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff0b3a2e),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbbb9ad),
      surfaceBright: Color(0xfffcfaec),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f1e4),
      surfaceContainer: Color(0xffe5e3d6),
      surfaceContainerHigh: Color(0xffd7d5c8),
      surfaceContainerHighest: Color(0xffc9c7ba),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc6cc79),
      surfaceTint: Color(0xffc6cc79),
      onPrimary: Color(0xff303300),
      primaryContainer: Color(0xff464a03),
      onPrimaryContainer: Color(0xffe3e892),
      secondary: Color(0xffc8c9a6),
      onSecondary: Color(0xff303219),
      secondaryContainer: Color(0xff47492e),
      onSecondaryContainer: Color(0xffe4e5c1),
      tertiary: Color(0xffa3d0c0),
      onTertiary: Color(0xff08372c),
      tertiaryContainer: Color(0xff234e42),
      onTertiaryContainer: Color(0xffbeecdb),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff13140c),
      onSurface: Color(0xffe5e3d6),
      onSurfaceVariant: Color(0xffc9c7b6),
      outline: Color(0xff929182),
      outlineVariant: Color(0xff47483b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e3d6),
      inversePrimary: Color(0xff5d621c),
      primaryFixed: Color(0xffe3e892),
      onPrimaryFixed: Color(0xff1b1d00),
      primaryFixedDim: Color(0xffc6cc79),
      onPrimaryFixedVariant: Color(0xff464a03),
      secondaryFixed: Color(0xffe4e5c1),
      onSecondaryFixed: Color(0xff1b1d07),
      secondaryFixedDim: Color(0xffc8c9a6),
      onSecondaryFixedVariant: Color(0xff47492e),
      tertiaryFixed: Color(0xffbeecdb),
      onTertiaryFixed: Color(0xff002018),
      tertiaryFixedDim: Color(0xffa3d0c0),
      onTertiaryFixedVariant: Color(0xff234e42),
      surfaceDim: Color(0xff13140c),
      surfaceBright: Color(0xff3a3a31),
      surfaceContainerLowest: Color(0xff0e0f08),
      surfaceContainerLow: Color(0xff1c1c14),
      surfaceContainer: Color(0xff202018),
      surfaceContainerHigh: Color(0xff2a2a22),
      surfaceContainerHighest: Color(0xff35352c),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffdce28d),
      surfaceTint: Color(0xffc6cc79),
      onPrimary: Color(0xff252800),
      primaryContainer: Color(0xff909649),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffdedfbb),
      onSecondary: Color(0xff25270f),
      secondaryContainer: Color(0xff929373),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffb8e6d5),
      onTertiary: Color(0xff002c22),
      tertiaryContainer: Color(0xff6e9a8b),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff13140c),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdfddcc),
      outline: Color(0xffb4b3a2),
      outlineVariant: Color(0xff929182),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e3d6),
      inversePrimary: Color(0xff474c04),
      primaryFixed: Color(0xffe3e892),
      onPrimaryFixed: Color(0xff111200),
      primaryFixedDim: Color(0xffc6cc79),
      onPrimaryFixedVariant: Color(0xff353900),
      secondaryFixed: Color(0xffe4e5c1),
      onSecondaryFixed: Color(0xff111201),
      secondaryFixedDim: Color(0xffc8c9a6),
      onSecondaryFixedVariant: Color(0xff36381f),
      tertiaryFixed: Color(0xffbeecdb),
      onTertiaryFixed: Color(0xff00150f),
      tertiaryFixedDim: Color(0xffa3d0c0),
      onTertiaryFixedVariant: Color(0xff103d32),
      surfaceDim: Color(0xff13140c),
      surfaceBright: Color(0xff45453c),
      surfaceContainerLowest: Color(0xff070803),
      surfaceContainerLow: Color(0xff1e1e16),
      surfaceContainer: Color(0xff282820),
      surfaceContainerHigh: Color(0xff33332a),
      surfaceContainerHighest: Color(0xff3e3e35),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff0f69f),
      surfaceTint: Color(0xffc6cc79),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffc2c876),
      onPrimaryContainer: Color(0xff0b0c00),
      secondary: Color(0xfff2f2cd),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffc4c5a2),
      onSecondaryContainer: Color(0xff0b0c00),
      tertiary: Color(0xffcbfae9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff9fccbc),
      onTertiaryContainer: Color(0xff000e09),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff13140c),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff3f1df),
      outlineVariant: Color(0xffc5c3b3),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e3d6),
      inversePrimary: Color(0xff474c04),
      primaryFixed: Color(0xffe3e892),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffc6cc79),
      onPrimaryFixedVariant: Color(0xff111200),
      secondaryFixed: Color(0xffe4e5c1),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc8c9a6),
      onSecondaryFixedVariant: Color(0xff111201),
      tertiaryFixed: Color(0xffbeecdb),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa3d0c0),
      onTertiaryFixedVariant: Color(0xff00150f),
      surfaceDim: Color(0xff13140c),
      surfaceBright: Color(0xff515147),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff202018),
      surfaceContainer: Color(0xff313128),
      surfaceContainerHigh: Color(0xff3c3c33),
      surfaceContainerHighest: Color(0xff47473e),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
