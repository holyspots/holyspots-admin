import 'app_localizations.dart';

class AppLocalizationsRu implements AppLocalizations {
  // General
  @override String get appTitle => 'HolySpots';
  @override String get adminPanel => 'Админ-панель';
  @override String get login => 'Вход';
  @override String get logout => 'Выход';
  @override String get save => 'Сохранить';
  @override String get cancel => 'Отмена';
  @override String get add => 'Добавить';
  @override String get edit => 'Редактировать';
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
  @override String get filter => 'Фильтр';
  @override String get apply => 'OK';

  // Login
  @override String get email => 'Email';
  @override String get password => 'Пароль';
  @override String get loginButton => 'Войти';
  @override String get loginError => 'Неверный email или пароль';

  // Menu
  @override String get menuSpots => 'Места';
  @override String get menuRegions => 'Регионы';
  @override String get menuGuides => 'Гиды';
  @override String get menuMaps => 'Карты';
  @override String get menuReviews => 'Отзывы';
  @override String get menuPlaces => 'Заведения';
  @override String get menuDirections => 'Как добраться';

  // Regions
  @override String get regionName => 'Название';
  @override String get regionDescription => 'Описание';
  @override String get regionPhoto => 'Фото';
  @override String get spotsCount => 'Мест';
  @override String get addRegion => 'Добавить регион';
  @override String get editRegion => 'Редактировать регион';
  @override String get deleteRegion => 'Удалить регион';
  @override String get selectRegion => 'Выберите регион';

  // Spots
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
  @override String get replaceFile => 'Заменить файл';
  @override String get openingTimes => 'Время работы';
  @override String get addOpeningTime => 'Добавить';
  @override String get beaconId => 'Beacon Id';
  @override String get selectRegions => 'Регионы';
  @override String get mapPreview => 'Карта';

  // Days
  @override String get days => 'Дни';
  @override String get monday => 'Понедельник';
  @override String get tuesday => 'Вторник';
  @override String get wednesday => 'Среда';
  @override String get thursday => 'Четверг';
  @override String get friday => 'Пятница';
  @override String get saturday => 'Суббота';
  @override String get sunday => 'Воскресенье';
  @override String get monShort => 'Пн';
  @override String get tueShort => 'Вт';
  @override String get wedShort => 'Ср';
  @override String get thuShort => 'Чт';
  @override String get friShort => 'Пт';
  @override String get satShort => 'Сб';
  @override String get sunShort => 'Вс';

  // Guides
  @override String get addGuide => 'Добавить гид';
  @override String get editGuide => 'Редактировать гид';
  @override String get deleteGuide => 'Удалить гид';
  @override String get guideName => 'Название';
  @override String get guideDescription => 'Описание';
  @override String get guidePhoto => 'Фото';
  @override String get guideSpots => 'Места';
  @override String get addSpotToGuide => 'Добавить место';
  @override String get guideBio => 'О гиде';
  @override String get guidePhone => 'Телефон';

  // Maps
  @override String get addMap => 'Добавить карту';
  @override String get editMap => 'Редактировать карту';
  @override String get deleteMap => 'Удалить карту';
  @override String get mapName => 'Название';
  @override String get mapFile => 'Файл';
  @override String get mapFileSize => 'Размер файла';
  @override String get mapDescription => 'Описание';
  @override String get mapRegion => 'Регион';
  @override String get mapSize => 'Размер';
  @override String get mapVersion => 'Версия';
  @override String get uploadFile => 'Загрузить файл';

  // Reviews
  @override String get reviewsModeration => 'Модерация отзывов';
  @override String get approved => 'Одобренные';
  @override String get unapproved => 'Не одобренные';
  @override String get approveReview => 'Одобрить';
  @override String get deleteReview => 'Удалить';
  @override String get reviewRating => 'Оценка';
  @override String get reviewText => 'Текст';
  @override String get reviewPhotos => 'Фото';
  @override String get fromDate => 'С';
  @override String get toDate => 'По';
  @override String get reviewSpot => 'Место';
  @override String get reviewAuthor => 'Автор';
  @override String get reviewDate => 'Дата';
  @override String get reviewStatus => 'Статус';
  @override String get reviewAll => 'Все';
  @override String get reviewPending => 'Ожидают';
  @override String get reviewApproved => 'Одобренные';
  @override String get reviewApprove => 'Одобрить';

  // Places
  @override String get addPlace => 'Добавить заведение';
  @override String get editPlace => 'Редактировать заведение';
  @override String get deletePlace => 'Удалить заведение';
  @override String get placeName => 'Название';
  @override String get placeDescription => 'Описание';
  @override String get placeAddress => 'Адрес';
  @override String get placeType => 'Тип';
  @override String get placeTypeHotel => 'Отель';
  @override String get placeTypeFood => 'Еда';
  @override String get placePhoto => 'Фото';
  @override String get placePhone => 'Телефон';
  @override String get placeWebsite => 'Сайт';
  @override String get filterByRegion => 'По региону';
  @override String get allRegions => 'Все регионы';
  @override String get region => 'Регион';

  // Directions
  @override String get addDirection => 'Добавить маршрут';
  @override String get editDirection => 'Редактировать маршрут';
  @override String get deleteDirection => 'Удалить маршрут';
  @override String get directionName => 'Название';
  @override String get directionDescription => 'Описание';
  @override String get directionTitle => 'Заголовок';
  @override String get directionContent => 'Содержание';
  @override String get directionType => 'Тип';
  @override String get directionTypeBus => 'Автобус';
  @override String get directionTypeTrain => 'Поезд';
  @override String get directionTypePlane => 'Самолет';
  @override String get directionTypeWalk => 'Пешком';

  // Pagination
  @override String get page => 'Страница';
  @override String get pageOf => 'из';
  @override String showing(int start, int end, int total) => 'Показано $start–$end из $total';

  // File drop zone
  @override String get dragFileHere => 'Перетащите файл сюда';
  @override String get orClickToSelect => 'или нажмите для выбора';
  @override String get allowedFormats => 'Допустимые форматы';

  // Confirm dialog
  @override String get confirmDeleteTitle => 'Подтверждение удаления';
  @override String confirmDeleteMessage(String item) => 'Удалить «$item»?';
}
