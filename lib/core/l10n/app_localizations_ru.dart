import 'app_localizations.dart';

class AppLocalizationsRu implements AppLocalizations {
  @override String get appTitle => 'HolySpots';
  @override String get adminPanel => 'Панель администратора';
  @override String get login => 'Вход';
  @override String get logout => 'Выйти';
  @override String get save => 'Сохранить';
  @override String get cancel => 'Отмена';
  @override String get add => 'Добавить';
  @override String get edit => 'Изменить';
  @override String get delete => 'Удалить';
  @override String get confirm => 'Подтвердить';
  @override String get yes => 'Да';
  @override String get no => 'Нет';
  @override String get loading => 'Загрузка...';
  @override String get error => 'Ошибка';
  @override String get success => 'Успешно';
  @override String get rememberMe => 'Запомнить меня';
  @override String get order => 'Порядок';
  @override String get confirmDelete => 'Вы уверены, что хотите удалить';

  @override String get email => 'Email';
  @override String get password => 'Пароль';
  @override String get loginButton => 'Войти';
  @override String get loginError => 'Неверный логин или пароль';

  @override String get menuCities => 'Города';
  @override String get menuSpots => 'Места';

  @override String get cityName => 'Название';
  @override String get cityDescription => 'Описание';
  @override String get cityPhoto => 'Фото';
  @override String get spotsCount => 'Мест';
  @override String get addCity => 'Добавить город';
  @override String get editCity => 'Редактировать город';
  @override String get deleteCity => 'Удалить город';
  @override String get selectCity => 'Выберите город';

  @override String get spotName => 'Название';
  @override String get spotDescription => 'Описание';
  @override String get spotPhoto => 'Главное фото';
  @override String get spotPhotos => 'Галерея фото';
  @override String get spotAudios => 'Аудио';
  @override String get spotAddress => 'Адрес';
  @override String get spotCoordinates => 'Координаты';
  @override String get addSpot => 'Добавить место';
  @override String get editSpot => 'Редактировать место';
  @override String get deleteSpot => 'Удалить место';
  @override String get latitude => 'Широта';
  @override String get longitude => 'Долгота';
  @override String get uploadPhoto => 'Загрузить фото';
  @override String get uploadAudio => 'Загрузить аудио';
  @override String get noAudio => 'нет';
  @override String get replaceFile => 'Заменить';

  @override String get page => 'Страница';
  @override String get pageOf => 'из';
  @override String showing(int start, int end, int total) => 'Показано $start–$end из $total';

  @override String get dragFileHere => 'Перетащите файл сюда';
  @override String get orClickToSelect => 'или нажмите для выбора';
  @override String get allowedFormats => 'Допустимые форматы';

  @override String get confirmDeleteTitle => 'Подтверждение удаления';
  @override String confirmDeleteMessage(String item) => 'Удалить "$item"?';
}
