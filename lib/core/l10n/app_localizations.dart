import 'package:flutter/material.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_en.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('ru'),
    Locale('en'),
  ];

  // General
  String get appTitle;
  String get adminPanel;
  String get login;
  String get logout;
  String get save;
  String get cancel;
  String get add;
  String get edit;
  String get delete;
  String get confirm;
  String get yes;
  String get no;
  String get loading;
  String get error;
  String get success;
  String get rememberMe;
  String get order;
  String get confirmDelete;

  // Login
  String get email;
  String get password;
  String get loginButton;
  String get loginError;

  // Menu
  String get menuCities;
  String get menuSpots;

  // Cities
  String get cityName;
  String get cityDescription;
  String get cityPhoto;
  String get spotsCount;
  String get addCity;
  String get editCity;
  String get deleteCity;
  String get selectCity;

  // Spots
  String get spotName;
  String get spotDescription;
  String get spotPhoto;
  String get spotPhotos;
  String get spotAudios;
  String get spotAddress;
  String get spotCoordinates;
  String get addSpot;
  String get editSpot;
  String get deleteSpot;
  String get latitude;
  String get longitude;
  String get uploadPhoto;
  String get uploadAudio;
  String get noAudio;
  String get replaceFile;

  // Pagination
  String get page;
  String get pageOf;
  String showing(int start, int end, int total);

  // File drop zone
  String get dragFileHere;
  String get orClickToSelect;
  String get allowedFormats;

  // Confirm dialog
  String get confirmDeleteTitle;
  String confirmDeleteMessage(String item);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ru', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return AppLocalizationsEn();
      case 'ru':
      default:
        return AppLocalizationsRu();
    }
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
