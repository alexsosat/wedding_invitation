import "package:flex_color_scheme/flex_color_scheme.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade the package to version 8.4.0.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class AppTheme {
  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseTextTheme = ThemeData(brightness: brightness).textTheme;

    return GoogleFonts.instrumentSansTextTheme(baseTextTheme).copyWith(
      titleLarge: GoogleFonts.cormorantGaramond(
        textStyle: baseTextTheme.titleLarge,
      ),
      titleMedium: GoogleFonts.cormorantGaramond(
        textStyle: baseTextTheme.titleMedium,
      ),
      titleSmall: GoogleFonts.cormorantGaramond(
        textStyle: baseTextTheme.titleSmall,
      ),
    );
  }

  /// The FlexColorScheme defined light mode ThemeData.
  static ThemeData light(BuildContext context) => FlexThemeData.light(
        textTheme: _buildTextTheme(Brightness.light),
        // Using FlexColorScheme built-in FlexScheme enum based colors
        scheme: FlexScheme.gold,
        // Input color modifiers.
        swapLegacyOnMaterial3: true,
        // Surface color adjustments.
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 20,
        // Convenience direct styling properties.
        appBarStyle: FlexAppBarStyle.background,
        bottomAppBarElevation: 1,
        // Component theme configurations for light mode.
        subThemesData: const FlexSubThemesData(
          interactionEffects: true,
          tintedDisabledControls: true,
          blendOnLevel: 20,
          blendOnColors: true,
          useM2StyleDividerInM3: true,
          thickBorderWidth: 2,
          elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
          elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
          outlinedButtonOutlineSchemeColor: SchemeColor.primary,
          toggleButtonsBorderSchemeColor: SchemeColor.primary,
          segmentedButtonSchemeColor: SchemeColor.primary,
          segmentedButtonBorderSchemeColor: SchemeColor.primary,
          unselectedToggleIsColored: true,
          sliderValueTinted: true,
          inputDecoratorSchemeColor: SchemeColor.primary,
          inputDecoratorIsFilled: true,
          inputDecoratorBackgroundAlpha: 15,
          inputDecoratorBorderType: FlexInputBorderType.outline,
          inputDecoratorRadius: 10,
          inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
          chipRadius: 10,
          popupMenuRadius: 6,
          popupMenuElevation: 6,
          alignedDropdown: true,
          appBarScrolledUnderElevation: 8,
          drawerWidth: 280,
          drawerIndicatorSchemeColor: SchemeColor.primary,
          bottomNavigationBarMutedUnselectedLabel: false,
          bottomNavigationBarMutedUnselectedIcon: false,
          menuRadius: 6,
          menuElevation: 6,
          menuBarRadius: 0,
          menuBarElevation: 1,
          searchBarElevation: 1,
          searchViewElevation: 1,
          searchUseGlobalShape: true,
          navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
          navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
          navigationBarIndicatorSchemeColor: SchemeColor.primary,
          navigationBarElevation: 2,
          navigationBarHeight: 70,
          navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
          navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
          navigationRailUseIndicator: true,
          navigationRailIndicatorSchemeColor: SchemeColor.primary,
          navigationRailIndicatorOpacity: 1,
        ),
        // ColorScheme seed generation configuration for light mode.
        keyColors: const FlexKeyColors(
          useTertiary: true,
          keepPrimary: true,
          keepTertiary: true,
        ),
        tones: FlexSchemeVariant.chroma.tones(Brightness.light),
        // Direct ThemeData properties.
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      );

  /// The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark(BuildContext context) => FlexThemeData.dark(
        // Using FlexColorScheme built-in FlexScheme enum based colors.
        scheme: FlexScheme.gold,
        textTheme: _buildTextTheme(Brightness.dark),

        // Input color modifiers.
        swapLegacyOnMaterial3: true,
        // Surface color adjustments.
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 30,
        // Convenience direct styling properties.
        appBarStyle: FlexAppBarStyle.background,
        bottomAppBarElevation: 2,
        // Component theme configurations for dark mode.
        subThemesData: const FlexSubThemesData(
          interactionEffects: true,
          tintedDisabledControls: true,
          blendOnLevel: 40,
          blendOnColors: true,
          useM2StyleDividerInM3: true,
          thickBorderWidth: 2,
          elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
          elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
          outlinedButtonOutlineSchemeColor: SchemeColor.primary,
          toggleButtonsBorderSchemeColor: SchemeColor.primary,
          segmentedButtonSchemeColor: SchemeColor.primary,
          segmentedButtonBorderSchemeColor: SchemeColor.primary,
          unselectedToggleIsColored: true,
          sliderValueTinted: true,
          inputDecoratorSchemeColor: SchemeColor.primary,
          inputDecoratorIsFilled: true,
          inputDecoratorBackgroundAlpha: 22,
          inputDecoratorBorderType: FlexInputBorderType.outline,
          inputDecoratorRadius: 10,
          chipRadius: 10,
          popupMenuRadius: 6,
          popupMenuElevation: 6,
          alignedDropdown: true,
          drawerWidth: 280,
          drawerIndicatorSchemeColor: SchemeColor.primary,
          bottomNavigationBarMutedUnselectedLabel: false,
          bottomNavigationBarMutedUnselectedIcon: false,
          menuRadius: 6,
          menuElevation: 6,
          menuBarRadius: 0,
          menuBarElevation: 1,
          searchBarElevation: 1,
          searchViewElevation: 1,
          searchUseGlobalShape: true,
          navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
          navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
          navigationBarIndicatorSchemeColor: SchemeColor.primary,
          navigationBarElevation: 2,
          navigationBarHeight: 70,
          navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
          navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
          navigationRailUseIndicator: true,
          navigationRailIndicatorSchemeColor: SchemeColor.primary,
          navigationRailIndicatorOpacity: 1,
        ),
        // ColorScheme seed configuration setup for dark mode.
        keyColors: const FlexKeyColors(
          useTertiary: true,
          keepPrimary: true,
        ),
        tones: FlexSchemeVariant.chroma.tones(Brightness.dark),
        // Direct ThemeData properties.
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      );
}
