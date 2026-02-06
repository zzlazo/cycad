import "package:flutter/material.dart";
import "package:json_annotation/json_annotation.dart";

import "../../shared_utility.dart";

class SharedJsonTextStyleConverter
    implements JsonConverter<TextStyle, Map<String, dynamic>> {
  const SharedJsonTextStyleConverter();

  @override
  TextStyle fromJson(Map<String, dynamic> json) {
    return TextStyle(
      color: (json["color"] as String?)?.toColor(),
      fontSize: (json["fontSize"] as num?)?.toDouble(),
      fontWeight: _parseFontWeight(json["fontWeight"] as String?),
    );
  }

  @override
  Map<String, dynamic> toJson(TextStyle object) {
    return {
      "color": object.color?.toHex(),
      "fontSize": object.fontSize,
      "fontWeight": object.fontWeight?.toString().split(".").last,
    };
  }

  FontWeight? _parseFontWeight(String? weight) {
    if (weight == null) return null;
    return FontWeight.values.firstWhere(
      (w) => w.toString().contains(weight),
      orElse: () => FontWeight.normal,
    );
  }
}
