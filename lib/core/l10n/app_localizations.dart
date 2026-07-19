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
  String get filter;
  String get apply;

  // Login
  String get email;
  String get password;
  String get loginButton;
  String get loginError;

  // Menu
  String get menuSpots;
  String get menuRegions;
  String get menuGuides;
  String get menuMaps;
  String get menuReviews;
  String get menuPlaces;
  String get menuDirections;

  // Regions
  String get regionName;
  String get regionDescription;
  String get regionPhoto;
  String get spotsCount;
  String get addRegion;
  String get editRegion;
  String get deleteRegion;
  String get selectRegion;

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
  String get openingTimes;
  String get addOpeningTime;
  String get beaconId;
  String get selectRegions;
  String get mapPreview;

  // Days
  String get days;
  String get monday;
  String get tuesday;
  String get wednesday;
  String get thursday;
  String get friday;
  String get saturday;
  String get sunday;
  String get monShort;
  String get tueShort;
  String get wedShort;
  String get thuShort;
  String get friShort;
  String get satShort;
  String get sunShort;

  // Guides
  String get addGuide;
  String get editGuide;
  String get deleteGuide;
  String get guideName;
  String get guideDescription;
  String get guidePhoto;
  String get guideSpots;
  String get addSpotToGuide;
  String get guideBio;
  String get guidePhone;

  // Maps
  String get addMap;
  String get editMap;
  String get deleteMap;
  String get mapName;
  String get mapFile;
  String get mapFileSize;
  String get mapDescription;
  String get mapRegion;
  String get mapSize;
  String get mapVersion;
  String get uploadFile;

  // Reviews
  String get reviewsModeration;
  String get approved;
  String get unapproved;
  String get approveReview;
  String get deleteReview;
  String get reviewRating;
  String get reviewText;
  String get reviewPhotos;
  String get fromDate;
  String get toDate;
  String get reviewSpot;
  String get reviewAuthor;
  String get reviewDate;
  String get reviewStatus;
  String get reviewAll;
  String get reviewPending;
  String get reviewApproved;
  String get reviewApprove;

  // Places
  String get addPlace;
  String get editPlace;
  String get deletePlace;
  String get placeName;
  String get placeDescription;
  String get placeAddress;
  String get placeType;
  String get placeTypeHotel;
  String get placeTypeFood;
  String get placePhoto;
  String get placePhone;
  String get placeWebsite;
  String get filterByRegion;
  String get allRegions;
  String get region;

  // Directions
  String get addDirection;
  String get editDirection;
  String get deleteDirection;
  String get directionName;
  String get directionDescription;
  String get directionTitle;
  String get directionContent;
  String get directionType;
  String get directionTypeBus;
  String get directionTypeTrain;
  String get directionTypePlane;
  String get directionTypeWalk;

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
