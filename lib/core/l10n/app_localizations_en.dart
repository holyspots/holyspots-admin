import 'app_localizations.dart';

class AppLocalizationsEn implements AppLocalizations {
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

  @override String get email => 'Email';
  @override String get password => 'Password';
  @override String get loginButton => 'Login';
  @override String get loginError => 'Invalid email or password';

  @override String get menuCities => 'Cities';
  @override String get menuSpots => 'Spots';

  @override String get cityName => 'Name';
  @override String get cityDescription => 'Description';
  @override String get cityPhoto => 'Photo';
  @override String get spotsCount => 'Spots';
  @override String get addCity => 'Add city';
  @override String get editCity => 'Edit city';
  @override String get deleteCity => 'Delete city';
  @override String get selectCity => 'Select city';

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

  @override String get page => 'Page';
  @override String get pageOf => 'of';
  @override String showing(int start, int end, int total) => 'Showing $start–$end of $total';

  @override String get dragFileHere => 'Drop file here';
  @override String get orClickToSelect => 'or click to select';
  @override String get allowedFormats => 'Allowed formats';

  @override String get confirmDeleteTitle => 'Confirm deletion';
  @override String confirmDeleteMessage(String item) => 'Delete "$item"?';
}
