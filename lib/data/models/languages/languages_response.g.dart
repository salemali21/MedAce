// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'languages_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguagesResponse _$LanguagesResponseFromJson(Map<String, dynamic> json) =>
    LanguagesResponse(
      code: json['code'] as String,
      nativeName: json['native_name'] as String,
      translatedName: json['translated_name'] as String,
      defaultLocale: json['default_locale'] as String,
      countryFlagUrl: json['country_flag_url'] as String,
    );

Map<String, dynamic> _$LanguagesResponseToJson(LanguagesResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'native_name': instance.nativeName,
      'translated_name': instance.translatedName,
      'default_locale': instance.defaultLocale,
      'country_flag_url': instance.countryFlagUrl,
    };
