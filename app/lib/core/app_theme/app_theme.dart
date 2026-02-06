import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class AppThemeBase {
  static TextTheme textTheme(Color color) {
    return GoogleFonts.zenKakuGothicAntiqueTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          fontSize: 57.0,
          fontWeight: FontWeight.normal,
          color: color,
        ),
        displayMedium: TextStyle(
          fontSize: 45.0,
          fontWeight: FontWeight.normal,
          color: color,
        ),
        displaySmall: TextStyle(
          fontSize: 36.0,
          fontWeight: FontWeight.normal,
          color: color,
        ),
        headlineLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.normal,
          color: color,
        ),
        headlineMedium: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.normal,
          color: color,
        ),
        headlineSmall: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.normal,
          color: color,
        ),

        titleLarge: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: color,
        ),
        titleMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: color,
        ),
        titleSmall: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: color,
        ),

        bodyLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: color,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          color: Color(0xFFBBBBBB),
        ),
        bodySmall: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
          color: Color(0xFF888888),
        ),

        labelLarge: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        labelMedium: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
          color: color,
        ),
        labelSmall: TextStyle(
          fontSize: 11.0,
          fontWeight: FontWeight.normal,
          color: Color(0xFFBBBBBB),
        ),
      ),
    );
  }
}

class AppDarkTheme {
  static const Color textColor = Color(0xFFF0F0F0);
  static final TextTheme textTheme = AppThemeBase.textTheme(textColor);
  static final IconThemeData iconThemeData = IconThemeData(color: textColor);
  static final TextStyle buttonTextStyle = textTheme.labelLarge!;
  static final Color buttonBackGroundColor = Color(0xFF000000);

  static const ColorScheme colorScheme = ColorScheme.dark(
    surface: Color(0xFF1F1F1F),
    onSurface: Color(0xFFF0F0F0),

    primary: Color(0xFF000000),
    onPrimary: Color(0xFFFFFFFF),

    secondary: Color(0xFF222222),
    onSecondary: Color(0xFFFFFFFF),

    tertiary: Color(0xFF333333),
    onTertiary: Color(0xFFFFFFFF),

    error: Color(0xFFCF6679),
    onError: Color(0xFFFFFFFF),

    primaryContainer: Color(0xFF1A1A1A),
    onPrimaryContainer: Color(0xFFFFFFFF),

    secondaryContainer: Color(0xFF2F2F2F),
    onSecondaryContainer: Color(0xFFF0F0F0),

    tertiaryContainer: Color(0xFF444444),
    onTertiaryContainer: Color(0xFFF0F0F0),

    errorContainer: Color(0xFF9A1E2B),
    onErrorContainer: Color(0xFFFFDEDE),

    onSurfaceVariant: Color(0xFFBBBBBB),

    outline: Color(0xFF444444),
    shadow: Colors.black,
    inverseSurface: Color(0xFFF0F0F0),
    onInverseSurface: Color(0xFF101010),
    inversePrimary: Color(0xFFFFFFFF),
  );
  static final ProgressIndicatorThemeData progressIndicatorThemeData =
      ProgressIndicatorThemeData(color: textColor);
  static final IconButtonThemeData iconButtonThemeData = IconButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStatePropertyAll(buttonTextStyle),
      backgroundColor: WidgetStatePropertyAll(buttonBackGroundColor),
      iconColor: WidgetStatePropertyAll(iconThemeData.color),
    ),
  );
  static final ThemeData darkTheme = ThemeData(
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.secondaryContainer,
      contentTextStyle: textTheme.bodySmall,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.outline, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    progressIndicatorTheme: progressIndicatorThemeData,
    iconTheme: iconThemeData,
    brightness: Brightness.dark,

    colorScheme: colorScheme,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF101010),
      foregroundColor: Color(0xFFF0F0F0),
      titleTextStyle: textTheme.titleLarge,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: buttonBackGroundColor,
      foregroundColor: Color(0xFFFFFFFF),
      extendedTextStyle: buttonTextStyle,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonBackGroundColor,
        foregroundColor: Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFFF0F0F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    cardTheme: CardThemeData(color: Color(0xFF1F1F1F)),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color.fromARGB(255, 39, 39, 39),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Color(0xFFBBBBBB), width: 1.0),
      ),
      labelStyle: TextStyle(color: Color(0xFFBBBBBB)),
      hintStyle: TextStyle(color: Color(0xFF888888)),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Color(0xFFBBBBBB),
      inactiveTrackColor: Color(0xFF444444),
      thumbColor: Color(0xFFF0F0F0),
      overlayColor: Color(0xFFF0F0F0).withAlpha(122),
    ),
    dividerColor: Color(0xFF444444),
    listTileTheme: ListTileThemeData(
      tileColor: Color(0xFF1F1F1F),
      textColor: Color(0xFFF0F0F0),
      titleTextStyle: textTheme.titleLarge,
      subtitleTextStyle: textTheme.bodyMedium,
    ),
  );
}
