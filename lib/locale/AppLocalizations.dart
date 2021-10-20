import 'package:booking_system_flutter/locale/LanguageAr.dart';
import 'package:booking_system_flutter/locale/LanguageEn.dart';
import 'package:booking_system_flutter/locale/LanguageHi.dart';
import 'package:booking_system_flutter/locale/Languages.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'LanguagesAf.dart';
import 'LanguagesDe.dart';
import 'LanguagesEs.dart';
import 'LanguagesFr.dart';
import 'LanguagesGu.dart';
import 'LanguagesId.dart';
import 'LanguagesNl.dart';
import 'LanguagesPt.dart';
import 'LanguagesSq.dart';
import 'LanguagesTr.dart';
import 'LanguagesVi.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'ar':
        return LanguageAr();
      case 'hi':
        return LanguageHi();
      case 'gu':
        return LanguageGu();
      case 'af':
        return LanguageAf();
      case 'nl':
        return LanguageNl();
      case 'fr':
        return LanguageFr();
      case 'de':
        return LanguageDe();
      case 'id':
        return LanguageId();
      case 'es':
        return LanguageEs();
      case 'tr':
        return LanguageTr();
      case 'vi':
        return LanguageVi();
      case 'pt':
        return LanguagePt();
      case 'sq':
        return LanguageSq();

      default:
        return LanguageEn();
    }
  }

  @override
  bool isSupported(Locale locale) => LanguageDataModel.languages().contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}
