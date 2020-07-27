import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:h_pad/states/common/ProfileChangeNotifier.dart';

import 'application.dart';

// 加载 语言
class LoadJson {
  static Map<dynamic, dynamic> zh;
  static Map<dynamic, dynamic> en; // English map

  static Future init() async {
    String enJsonContent = await rootBundle.loadString("locale/i18n_en.json");
    en = json.decode(enJsonContent);
    String cnJsonContent = await rootBundle.loadString("locale/i18n_cn.json");
    zh = json.decode(cnJsonContent);
  }
}

class Translations {
  Translations(Locale locale) {
    this.locale = locale;
    if (locale.languageCode == 'zh') {
      _localizedValues = LoadJson.zh;
    } else if (locale.languageCode == 'en') {
      _localizedValues = LoadJson.en;
    } else {
      _localizedValues = LoadJson.zh;
    }
  }

  Locale locale;
  static Map<dynamic, dynamic> _localizedValues;
  static Map<dynamic, dynamic> _localizedValuesEn; // English map

  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

//  String text(String key) {
//    print("----------------${_localizedValues}");
//
//    if (_localizedValues != null) {
//      return _localizedValues[key] ?? '*$key';
//    }
//  }
  String text(String key) {
    try {
      String value = _localizedValues[key];
      if (value == null || value.isEmpty) {
        return englishText(key);
      } else {
        return value;
      }
    } catch (e) {
      return englishText(key);
    }
  }

  String englishText(String key) {
    List keys = key.split('.');
    dynamic result = _localizedValues;
    if (result != null) {
      if (keys.length > 1) {
        for (int i = 0; i < keys.length; i++) {
          result = result[keys[i]];
        }
        return result;
      } else {
        return _localizedValues[key] ?? '** $key not found';
      }
    }
    return _localizedValuesEn[key] ?? '** $key not found';
  }

  static Future<Translations> load(Locale locale) async {
    if (locale.languageCode == 'zh') {
      _localizedValues = LoadJson.zh;
    } else if (locale.languageCode == 'en') {
      _localizedValues = LoadJson.en;
    } else {
      _localizedValues = LoadJson.zh;
    }
    Translations translations = new Translations(locale);
    // String jsonContent = await rootBundle.loadString("locale/i18n_${locale.languageCode}.json");
    // _localizedValues = json.decode(jsonContent);
    // String enJsonContent = await rootBundle.loadString("locale/i18n_en.json");
    // _localizedValuesEn = json.decode(enJsonContent);
    return translations;
  }

  get currentLanguage => locale.languageCode;
}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  /// 改这里是为了不硬编码支持的语言
  @override
  bool isSupported(Locale locale) {
    return applic.supportedLanguages.contains(locale.languageCode);
  }

  @override
  Future<Translations> load(Locale locale) async {
    // print('初始化语言');
    String lang = LocaleModel().locale;
    if (lang == null) {
      lang = 'zh';
    }
    Locale initLocal = new Locale(lang, '');
    return Translations.load(initLocal);
  }

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}

/// Delegate类的实现，每次选择一种新的语言时，强制初始化一个新的Translations类
class SpecificLocalizationDelegate extends LocalizationsDelegate<Translations> {
  final Locale overriddenLocale;

  const SpecificLocalizationDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => overriddenLocale != null;

  @override
  Future<Translations> load(Locale locale) {
    print('更改。。。。。。。。。。。。。。。');
    return Translations.load(overriddenLocale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<Translations> old) => true;
}
