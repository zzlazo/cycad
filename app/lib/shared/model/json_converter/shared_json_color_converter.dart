import "package:flutter/material.dart";
import "package:json_annotation/json_annotation.dart";

import "../../shared_utility.dart";

class SharedJsonColorConverter implements JsonConverter<Color, String> {
  const SharedJsonColorConverter();

  @override
  Color fromJson(String json) {
    return json.toColor();
  }

  @override
  String toJson(Color object) {
    return object.toHex();
  }
}
