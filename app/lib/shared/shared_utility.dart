import "package:flutter/material.dart";
import "package:intl/intl.dart";

class SharedUtility {
  static String formatViewDateTime(DateTime dateTime, DateTime now) {
    final target = dateTime.toLocal();
    final current = now.toLocal();

    final todayStart = DateTime(current.year, current.month, current.day);

    late final String format;

    if (target.isBefore(todayStart)) {
      format = "yyyy/MM/dd HH:mm";
    } else {
      format = "HH:mm";
    }

    return DateFormat(format).format(target);
  }

  static const String nullText = "N/A";
  static String onlyNumberAlphabet(String text) {
    return text.replaceAll(RegExp(r"[^a-zA-Z0-9]"), "");
  }
}

extension ColorString on String {
  Color toColor() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write("ff");
    buffer.write(replaceFirst("#", ""));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension ColorToHex on Color {
  String toHex({bool includeAlpha = false}) {
    return '#${(includeAlpha ? toARGB32() : (toARGB32() & 0xFFFFFF)).toRadixString(16).padLeft(includeAlpha ? 8 : 6, '0').toUpperCase()}';
  }
}

class EnvVariables {
  static const String supabaseUrl = String.fromEnvironment("SUPABASE_URL");
  static const String supabaseKey = String.fromEnvironment("SUPABASE_KEY");
}

const defaultCardSeedColor = Colors.black;
