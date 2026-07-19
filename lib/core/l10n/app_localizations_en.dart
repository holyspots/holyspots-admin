import 'app_localizations.dart';

class AppLocalizationsEn implements AppLocalizations {
  // General
  @override String get appTitle => 'HolySpots';
  @override String get adminPanel => 'Admin Panel';
  @override String get login => 'Login';
  @override String get logout => 'Logout';
  @override String get save => 'Save';
  @override String get cancel => 'Cancel';
  @override String get add => 'Add';
  @override String get edit => 'Edit';
  @override String get delete => 'Delete';
  @override String get confirm => 'Confirm';
  @override String get yes => 'Yes';
  @override String get no => 'No';
  @override String get loading => 'Loading...';
  @override String get error => 'Error';
  @override String get success => 'Success';
  @override String get rememberMe => 'Remember me';
  @override String get order => 'Order';
  @override String get confirmDelete => 'Are you sure you want to delete';
  @override String get filter => 'Filter';
  @override String get apply => 'OK';

  // Login
  @override String get email => 'Email';
  @override String get password => 'Password';
  @override String get loginButton => 'Login';
  @override String get loginError => 'Invalid email or password';

  // Menu
  @override String get menuSpots => 'Spots';
  @override String get menuRegions => 'Regions';
  @override String get menuGuides => 'Guides';
  @override String get menuMaps => 'Maps';
  @override String get menuReviews => 'Reviews';
  @override String get menuPlaces => 'Places';
  @override String get menuDirections => 'Directions';

  // Regions
  @override String get regionName => 'Name';
  @override String get regionDescription => 'Description';
  @override String get regionPhoto => 'Photo';
  @override String get spotsCount => 'Spots';
  @override String get addRegion => 'Add region';
  @override String get editRegion => 'Edit region';
  @override String get deleteRegion => 'Delete region';
  @override String get selectRegion => 'Select region';

  // Spots
  @override String get spotName => 'Name';
  @override String get spotDescription => 'Description';
  @override String get spotPhoto => 'Main photo';
  @override String get spotPhotos => 'Photo gallery';
  @override String get spotAudios => 'Audio';
  @override String get spotAddress => 'Address';
  @override String get spotCoordinates => 'Coordinates';
  @override String get addSpot => 'Add spot';
  @override String get editSpot => 'Edit spot';
  @override String get deleteSpot => 'Delete spot';
  @override String get latitude => 'Latitude';
  @override String get longitude => 'Longitude';
  @override String get uploadPhoto => 'Upload photo';
  @override String get uploadAudio => 'Upload audio';
  @override String get noAudio => 'none';
  @override String get replaceFile => 'Replace';
  @override String get openingTimes => 'Opening times';
  @override String get addOpeningTime => 'Add';
  @override String get beaconId => 'Beacon Id';
  @override String get selectRegions => 'Regions';
  @override String get mapPreview => 'Map';

  // Days
  @override String get days => 'Days';
  @override String get monday => 'Monday';
  @override String get tuesday => 'Tuesday';
  @override String get wednesday => 'Wednesday';
  @override String get thursday => 'Thursday';
  @override String get friday => 'Friday';
  @override String get saturday => 'Saturday';
  @override String get sunday => 'Sunday';
  @override String get monShort => 'Mon';
  @override String get tueShort => 'Tue';
  @override String get wedShort => 'Wed';
  @override String get thuShort => 'Thu';
  @override String get friShort => 'Fri';
  @override String get satShort => 'Sat';
  @override String get sunShort => 'Sun';

  // Guides
  @override String get addGuide => 'Add guide';
  @override String get editGuide => 'Edit guide';
  @override String get deleteGuide => 'Delete guide';
  @override String get guideName => 'Name';
  @override String get guideDescription => 'Description';
  @override String get guidePhoto => 'Photo';
  @override String get guideSpots => 'Spots';
  @override String get addSpotToGuide => 'Add spot';

  // Maps
  @override String get addMap => 'Add map';
  @override String get editMap => 'Edit map';
  @override String get deleteMap => 'Delete map';
  @override String get mapName => 'Name';
  @override String get mapFile => 'File';
  @override String get mapFileSize => 'File size';

  // Reviews
  @override String get reviewsModeration => 'Reviews moderation';
  @override String get approved => 'Approved';
  @override String get unapproved => 'Unapproved';
  @override String get approveReview => 'Approve';
  @override String get deleteReview => 'Delete';
  @override String get reviewRating => 'Rating';
  @override String get reviewText => 'Text';
  @override String get reviewPhotos => 'Photos';
  @override String get fromDate => 'From';
  @override String get toDate => 'To';

  // Places
  @override String get addPlace => 'Add place';
  @override String get editPlace => 'Edit place';
  @override String get deletePlace => 'Delete place';
  @override String get placeName => 'Name';
  @override String get placeDescription => 'Description';
  @override String get placeAddress => 'Address';
  @override String get placeType => 'Type';
  @override String get placeTypeHotel => 'Hotel';
  @override String get placeTypeFood => 'Food';

  // Directions
  @override String get addDirection => 'Add direction';
  @override String get editDirection => 'Edit direction';
  @override String get deleteDirection => 'Delete direction';
  @override String get directionName => 'Name';
  @override String get directionDescription => 'Description';

  // Pagination
  @override String get page => 'Page';
  @override String get pageOf => 'of';
  @override String showing(int start, int end, int total) => 'Showing $start–$end of $total';

  // File drop zone
  @override String get dragFileHere => 'Drop file here';
  @override String get orClickToSelect => 'or click to select';
  @override String get allowedFormats => 'Allowed formats';

  // Confirm dialog
  @override String get confirmDeleteTitle => 'Confirm deletion';
  @override String confirmDeleteMessage(String item) => 'Delete "$item"?';
}
