import 'dart:convert';

import 'package:medace_app/core/constants/preferences_name.dart';
import 'package:medace_app/core/env.dart';

class LocalizationLocalStorage {
  Future<Map<String, dynamic>> getLocalization() {
    var cached = preferences.getString(PreferencesName.localizationLocal);
    return Future.value(jsonDecode(cached!));
  }

  void saveLocalizationLocal(Map<String, dynamic> localizationRepository) {
    String json = jsonEncode(localizationRepository);

    String? cachedApp = preferences.getString(PreferencesName.localizationLocal);

    cachedApp ??= '';

    cachedApp = '';

    cachedApp = json;

    preferences.setString(PreferencesName.localizationLocal, cachedApp);
  }
}
