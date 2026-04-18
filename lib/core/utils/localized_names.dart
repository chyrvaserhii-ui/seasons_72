import 'package:flutter/material.dart';

import '../models/season_models.dart';

/// Helpers to pick the correct localized string from our models, based on
/// the app's current locale. We keep models raw (with both EN and UK
/// fields) and localize at the widget layer.
extension LocalizedMicroSeason on MicroSeason {
  String localizedName(Locale locale) {
    return locale.languageCode == 'uk' ? nameUk : nameEn;
  }

  String localizedDescription(Locale locale) {
    return locale.languageCode == 'uk' ? descriptionUk : descriptionEn;
  }
}

extension LocalizedMeta on MetaSeason {
  String localizedName(Locale locale) {
    return locale.languageCode == 'uk' ? nameUk : nameEn;
  }
}

extension LocalizedSekki on Sekki {
  String localizedName(Locale locale) {
    return locale.languageCode == 'uk' ? nameUk : nameEn;
  }
}
