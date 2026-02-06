import "package:freezed_annotation/freezed_annotation.dart";

part "shared_card_model.freezed.dart";
part "shared_card_model.g.dart";

@freezed
abstract class CardSuit with _$CardSuit {
  const factory CardSuit({
    required int id,
    required String name,
    required String value,
  }) = _Suit;

  factory CardSuit.fromJson(Map<String, Object?> json) =>
      _$CardSuitFromJson(json);
}

@freezed
abstract class CardNumber with _$CardNumber {
  const factory CardNumber({
    required int id,
    required String name,
    required int value,
  }) = _CardNumber;

  factory CardNumber.fromJson(Map<String, Object?> json) =>
      _$CardNumberFromJson(json);
}

@freezed
abstract class CardCode with _$CardCode {
  const factory CardCode({
    required int id,
    required CardSuit suit,
    required CardNumber number,
  }) = _CardCode;

  factory CardCode.fromJson(Map<String, Object?> json) =>
      _$CardCodeFromJson(json);
}
