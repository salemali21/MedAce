import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'languages_response.g.dart';

@JsonSerializable()
@immutable
class LanguagesResponse {
  LanguagesResponse({
    required this.code,
    required this.nativeName,
    required this.translatedName,
    required this.defaultLocale,
    required this.countryFlagUrl,
  });

  factory LanguagesResponse.fromJson(Map<String, dynamic> json) => _$LanguagesResponseFromJson(json);

  final String code;
  @JsonKey(name: 'native_name')
  final String nativeName;
  @JsonKey(name: 'translated_name')
  final String translatedName;
  @JsonKey(name: 'default_locale')
  final String defaultLocale;
  @JsonKey(name: 'country_flag_url')
  final String countryFlagUrl;

  Map<String, dynamic> toJson() => _$LanguagesResponseToJson(this);
}
