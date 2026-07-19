import '../models/localized_text.dart';
import '../models/geo_point.dart';
import '../models/region_model.dart';
import '../models/spot_model.dart';
import '../models/opening_time.dart';
import '../models/guide_model.dart';
import '../models/offline_map_model.dart';
import '../models/review_model.dart';
import '../models/place_model.dart';
import '../models/direction_model.dart';
import '../models/api_response.dart';

class MockData {
  // ============== REGIONS ==============
  static final regions = [
    Region(
      id: 'region-1',
      name: const LocalizedText(
        ru: 'Вриндаван',
        en: 'Vrindavan',
        hi: 'वृन्दावन',
      ),
      descr: const LocalizedText(
        ru: 'Священный город на берегу Ямуны, место явления Кришны',
        en: 'Sacred city on the banks of Yamuna, birthplace of Krishna',
        hi: 'यमुना के तट पर पवित्र शहर, कृष्ण का जन्मस्थान',
      ),
      mainPhoto: 'https://placeholder.com/vrindavan.jpg',
      order: 1,
      spotsCount: 25,
    ),
    Region(
      id: 'region-2',
      name: const LocalizedText(
        ru: 'Майапур',
        en: 'Mayapur',
        hi: 'मायापुर',
      ),
      descr: const LocalizedText(
        ru: 'Место явления Шри Чайтаньи Махапрабху',
        en: 'Birthplace of Sri Chaitanya Mahaprabhu',
        hi: 'श्री चैतन्य महाप्रभु का जन्मस्थान',
      ),
      mainPhoto: 'https://placeholder.com/mayapur.jpg',
      order: 2,
      spotsCount: 18,
    ),
    Region(
      id: 'region-3',
      name: const LocalizedText(
        ru: 'Джаганнатха Пури',
        en: 'Jagannatha Puri',
        hi: 'जगन्नाथ पुरी',
      ),
      descr: const LocalizedText(
        ru: 'Один из четырёх священных дхам, храм Джаганнатхи',
        en: 'One of the four sacred dhams, Jagannath temple',
        hi: 'चार पवित्र धामों में से एक, जगन्नाथ मंदिर',
      ),
      mainPhoto: 'https://placeholder.com/puri.jpg',
      order: 3,
      spotsCount: 12,
    ),
  ];

  // ============== SPOTS ==============
  static final spots = [
    Spot(
      id: 'spot-1',
      regionIds: ['region-1'],
      name: const LocalizedText(
        ru: 'Храм Кришны-Баларамы',
        en: 'Krishna Balarama Mandir',
        hi: 'कृष्ण-बलराम मंदिर',
      ),
      descr: const LocalizedText(
        ru: 'Этот великолепный храм был сооружён в 1975 году Его Божественной Милостью А. Ч. Бхактиведантой Свами Прабхупадой, ачарией-основателем ИСККОН',
        en: 'This magnificent temple was built in 1975 by His Divine Grace A.C. Bhaktivedanta Swami Prabhupada, the founder-acharya of ISKCON',
        hi: 'यह भव्य मंदिर 1975 में इस्कॉन के संस्थापक-आचार्य भक्तिवेदांत स्वामी प्रभुपाद द्वारा बनाया गया था',
      ),
      mainPhoto: 'https://placeholder.com/kb-temple.jpg',
      location: const GeoPoint(latitude: 27.5735, longitude: 77.6899),
      address: 'Raman Reti, Vrindavan, UP 281121',
      order: 1,
      photos: [
        'https://placeholder.com/kb1.jpg',
        'https://placeholder.com/kb2.jpg',
        'https://placeholder.com/kb3.jpg',
      ],
      audios: [
        const SpotAudio(file: 'kb-ru.mp3', lang: 'ru'),
        const SpotAudio(file: 'kb-en.mp3', lang: 'en'),
      ],
      openingTimes: [
        const OpeningTime(days: [0, 1, 2, 3, 4, 5, 6], startTime: '04:30', endTime: '13:00'),
        const OpeningTime(days: [0, 1, 2, 3, 4, 5, 6], startTime: '16:00', endTime: '20:45'),
      ],
      beaconId: 'f7826da6-4fa2-4e98-8024-bc5b71e0893e',
    ),
    Spot(
      id: 'spot-2',
      regionIds: ['region-1'],
      name: const LocalizedText(
        ru: 'Самадхи Шрилы Прабхупады',
        en: 'Srila Prabhupada Samadhi',
        hi: 'श्रील प्रभुपाद समाधि',
      ),
      descr: const LocalizedText(
        ru: 'Место упокоения основателя ИСККОН',
        en: 'Final resting place of ISKCON founder',
        hi: 'इस्कॉन संस्थापक का अंतिम विश्राम स्थल',
      ),
      mainPhoto: 'https://placeholder.com/samadhi.jpg',
      location: const GeoPoint(latitude: 27.5740, longitude: 77.6895),
      address: 'Krishna-Balaram Mandir, Vrindavan',
      order: 2,
      photos: [],
      audios: [],
      openingTimes: [
        const OpeningTime(days: [0, 1, 2, 3, 4, 5, 6], startTime: '00:00', endTime: '23:59'),
      ],
      beaconId: null,
    ),
    Spot(
      id: 'spot-3',
      regionIds: ['region-1'],
      name: const LocalizedText(
        ru: 'Исследовательский институт Вриндавана',
        en: 'Vrindavan Research Institute',
        hi: 'वृन्दावन अनुसंधान संस्थान',
      ),
      descr: const LocalizedText(
        ru: 'Библиотека и архив редких рукописей',
        en: 'Library and archive of rare manuscripts',
        hi: 'दुर्लभ पांडुलिपियों का पुस्तकालय और संग्रह',
      ),
      mainPhoto: 'https://placeholder.com/vri.jpg',
      location: const GeoPoint(latitude: 27.5800, longitude: 77.6700),
      address: 'Vrindavan Research Institute, Vrindavan',
      order: 3,
      photos: [],
      audios: [],
      openingTimes: [
        const OpeningTime(days: [0, 1, 2, 3, 4, 5], startTime: '10:00', endTime: '17:00'),
      ],
      beaconId: null,
    ),
    Spot(
      id: 'spot-4',
      regionIds: ['region-2'],
      name: const LocalizedText(
        ru: 'Храм Ведического Планетария',
        en: 'Temple of the Vedic Planetarium',
        hi: 'वैदिक तारामंडल का मंदिर',
      ),
      descr: const LocalizedText(
        ru: 'Грандиозный храм ИСККОН в Майапуре',
        en: 'Grand ISKCON temple in Mayapur',
        hi: 'मायापुर में भव्य इस्कॉन मंदिर',
      ),
      mainPhoto: 'https://placeholder.com/tovp.jpg',
      location: const GeoPoint(latitude: 23.4230, longitude: 88.3880),
      address: 'ISKCON Mayapur, Nadia, WB 741313',
      order: 1,
      photos: [],
      audios: [],
      openingTimes: [
        const OpeningTime(days: [0, 1, 2, 3, 4, 5, 6], startTime: '04:30', endTime: '21:00'),
      ],
      beaconId: null,
    ),
  ];

  // ============== GUIDES ==============
  static final guides = [
    Guide(
      id: 'guide-1',
      name: const LocalizedText(
        ru: 'Рам Прасад',
        en: 'Ram Prasad',
        hi: 'राम प्रसाद',
      ),
      bio: const LocalizedText(
        ru: 'Опытный гид по Вриндавану с 15-летним стажем',
        en: 'Experienced Vrindavan guide with 15 years of experience',
        hi: '15 वर्षों के अनुभव के साथ अनुभवी वृन्दावन गाइड',
      ),
      photo: 'https://placeholder.com/guide-ram.jpg',
      phone: '+91 9876543210',
      whatsapp: '+91 9876543210',
      telegram: '@ramprasad',
      order: 1,
      spotIds: ['spot-1', 'spot-2', 'spot-3'],
      spotsCount: 3,
    ),
    Guide(
      id: 'guide-2',
      name: const LocalizedText(
        ru: 'Шьям Сундар',
        en: 'Shyam Sundar',
        hi: 'श्याम सुंदर',
      ),
      bio: const LocalizedText(
        ru: 'Специалист по Говардхан парикраме',
        en: 'Specialist in Govardhan Parikrama',
        hi: 'गोवर्धन परिक्रमा विशेषज्ञ',
      ),
      photo: 'https://placeholder.com/guide-shyam.jpg',
      phone: '+91 9876543211',
      whatsapp: '+91 9876543211',
      order: 2,
      spotIds: [],
      spotsCount: 0,
    ),
  ];

  // ============== OFFLINE MAPS ==============
  static final maps = [
    OfflineMap(
      id: 'map-1',
      name: const LocalizedText(
        ru: 'Вриндаван',
        en: 'Vrindavan',
        hi: 'वृन्दावन',
      ),
      descr: const LocalizedText(
        ru: 'Офлайн карта Вриндавана с достопримечательностями',
        en: 'Offline map of Vrindavan with attractions',
        hi: 'आकर्षणों के साथ वृन्दावन का ऑफ़लाइन नक्शा',
      ),
      fileUrl: 'https://maps.example.com/vrindavan.mbtiles',
      sizeBytes: 50331648, // 48 MB
      version: '2.1',
      regionId: 'region-1',
    ),
    OfflineMap(
      id: 'map-2',
      name: const LocalizedText(
        ru: 'Ангкор Ват',
        en: 'Angkor Wat',
        hi: 'अंगकोर वाट',
      ),
      descr: const LocalizedText(
        ru: 'Офлайн карта храмового комплекса Ангкор',
        en: 'Offline map of Angkor temple complex',
        hi: 'अंगकोर मंदिर परिसर का ऑफ़लाइन नक्शा',
      ),
      fileUrl: 'https://maps.example.com/angkor_wat.mbtiles',
      sizeBytes: 63963136, // 61 MB
      version: '1.5',
      regionId: null,
    ),
    OfflineMap(
      id: 'map-3',
      name: const LocalizedText(
        ru: 'Джаганнатха Пури',
        en: 'Jagannatha Puri',
        hi: 'जगन्नाथ पुरी',
      ),
      descr: const LocalizedText(
        ru: 'Офлайн карта Пури с храмами и пляжами',
        en: 'Offline map of Puri with temples and beaches',
        hi: 'मंदिरों और समुद्र तटों के साथ पुरी का ऑफ़लाइन नक्शा',
      ),
      fileUrl: 'https://maps.example.com/puri.mbtiles',
      sizeBytes: 36700160, // 35 MB
      version: '1.0',
      regionId: 'region-3',
    ),
  ];

  // ============== REVIEWS ==============
  static final reviews = [
    Review(
      id: 'review-1',
      spotId: 'spot-1',
      spotName: 'Храм Кришны-Баларамы',
      authorName: 'Рамачандра дас',
      createdAt: DateTime(2026, 7, 12),
      rating: 5,
      text: 'Удивительное по силе место. Обязательно приходите на утреннее арати.',
      photos: ['https://placeholder.com/review1-1.jpg', 'https://placeholder.com/review1-2.jpg'],
      isApproved: false,
    ),
    Review(
      id: 'review-2',
      spotId: 'spot-2',
      spotName: 'Холм Говардхан',
      authorName: 'Радха деви даси',
      createdAt: DateTime(2026, 7, 10),
      rating: 3,
      text: 'Парикрама 21 км — берите воду и выходите рано утром.',
      photos: [],
      isApproved: false,
    ),
    Review(
      id: 'review-3',
      spotId: 'spot-4',
      spotName: 'Храм Господа Джаганнатха',
      authorName: 'Кришна прем дас',
      createdAt: DateTime(2026, 7, 8),
      rating: 2,
      text: 'Иностранцев внутрь не пускают, смотрели снаружи.',
      photos: [],
      isApproved: false,
    ),
    Review(
      id: 'review-4',
      spotId: 'spot-1',
      spotName: 'Храм Кришны-Баларамы',
      authorName: 'Гопи деви даси',
      createdAt: DateTime(2026, 7, 5),
      rating: 5,
      text: 'Прекрасный храм! Рекомендую посетить.',
      photos: [],
      isApproved: true,
    ),
  ];

  // ============== PLACES ==============
  static final places = [
    Place(
      id: 'place-1',
      regionId: 'region-1',
      type: PlaceType.hotel,
      name: const LocalizedText(
        ru: 'МВТ Гестхаус и Ресторан',
        en: 'MVT Guesthouse & Restaurant',
        hi: 'एमवीटी गेस्टहाउस और रेस्टोरेंट',
      ),
      descr: const LocalizedText(
        ru: 'Приятное и довольно роскошное место при ISKCON. Бронировать лучше заранее.',
        en: 'Pleasant and quite luxurious place at ISKCON. Better to book in advance.',
        hi: 'इस्कॉन में सुखद और काफी शानदार जगह। अग्रिम बुकिंग बेहतर है।',
      ),
      mainPhoto: 'https://placeholder.com/mvt.jpg',
      address: const LocalizedText(
        ru: 'Бхактиведанта Свами Марг, Вриндаван, UP 281121',
        en: 'Bhaktivedanta Swami Marg, Vrindavan, UP 281121',
        hi: 'भक्तिवेदांत स्वामी मार्ग, वृन्दावन, UP 281121',
      ),
      phone: '+91 565 2540021',
      website: 'https://iskconvrindavan.com',
      lat: 27.5738,
      lng: 77.6897,
    ),
    Place(
      id: 'place-2',
      regionId: 'region-1',
      type: PlaceType.hotel,
      name: const LocalizedText(
        ru: 'Бхакти Дхама',
        en: 'Bhakti Dhama',
        hi: 'भक्ति धाम',
      ),
      descr: const LocalizedText(
        ru: 'Гостиница для паломников',
        en: 'Pilgrim guesthouse',
        hi: 'तीर्थयात्रियों के लिए गेस्टहाउस',
      ),
      mainPhoto: 'https://placeholder.com/bhakti-dhama.jpg',
      address: const LocalizedText(
        ru: 'Вриндаван',
        en: 'Vrindavan',
        hi: 'वृन्दावन',
      ),
    ),
    Place(
      id: 'place-3',
      regionId: 'region-1',
      type: PlaceType.food,
      name: const LocalizedText(
        ru: 'Кешав Кофе Хаус',
        en: 'Keshav Coffee House',
        hi: 'केशव कॉफ़ी हाउस',
      ),
      descr: const LocalizedText(
        ru: 'Кафе с вегетарианским меню',
        en: 'Cafe with vegetarian menu',
        hi: 'शाकाहारी मेनू वाला कैफ़े',
      ),
      mainPhoto: 'https://placeholder.com/keshav-coffee.jpg',
      address: const LocalizedText(
        ru: 'Рядом с Лой Базаром, Вриндаван',
        en: 'Near Loi Bazaar, Vrindavan',
        hi: 'लोई बाज़ार के पास, वृन्दावन',
      ),
    ),
    Place(
      id: 'place-4',
      regionId: 'region-1',
      type: PlaceType.food,
      name: const LocalizedText(
        ru: 'Рам Свитс',
        en: 'Ram Sweets',
        hi: 'राम स्वीट्स',
      ),
      descr: const LocalizedText(
        ru: 'Традиционные индийские сладости',
        en: 'Traditional Indian sweets',
        hi: 'पारंपरिक भारतीय मिठाइयाँ',
      ),
      mainPhoto: 'https://placeholder.com/ram-sweets.jpg',
      address: const LocalizedText(
        ru: 'Главный рынок, Вриндаван',
        en: 'Main Market, Vrindavan',
        hi: 'मुख्य बाज़ार, वृन्दावन',
      ),
    ),
  ];

  // ============== DIRECTIONS ==============
  static final directions = [
    Direction(
      id: 'dir-1',
      regionId: 'region-1',
      type: DirectionType.train,
      order: 1,
      title: const LocalizedText(
        ru: 'Поездом из Дели',
        en: 'By train from Delhi',
        hi: 'दिल्ली से ट्रेन द्वारा',
      ),
      content: const LocalizedText(
        ru: 'Самый простой и безопасный способ — поезд с железнодорожной станции Нью-Дели до Матхуры, далее авто-рикша до Вриндавана (около 15 км).',
        en: 'The easiest and safest way is a train from New Delhi Railway Station to Mathura, then auto-rickshaw to Vrindavan (about 15 km).',
        hi: 'सबसे आसान और सुरक्षित तरीका नई दिल्ली रेलवे स्टेशन से मथुरा तक ट्रेन है, फिर वृन्दावन के लिए ऑटो-रिक्शा (लगभग 15 किमी)।',
      ),
    ),
    Direction(
      id: 'dir-2',
      regionId: 'region-1',
      type: DirectionType.bus,
      order: 2,
      title: const LocalizedText(
        ru: 'Такси из аэропорта Дели',
        en: 'Taxi from Delhi Airport',
        hi: 'दिल्ली हवाई अड्डे से टैक्सी',
      ),
      content: const LocalizedText(
        ru: 'Такси из аэропорта Дели до Вриндавана занимает 3–4 часа в зависимости от трафика. Можно забронировать через приложения Uber или Ola.',
        en: 'Taxi from Delhi Airport to Vrindavan takes 3-4 hours depending on traffic. Can be booked through Uber or Ola apps.',
        hi: 'दिल्ली हवाई अड्डे से वृन्दावन तक टैक्सी 3-4 घंटे लेती है जो ट्रैफ़िक पर निर्भर करता है। Uber या Ola ऐप के माध्यम से बुक किया जा सकता है।',
      ),
    ),
  ];

  // ============== HELPER METHODS ==============

  static List<Region> getRegions() => regions;

  static Region? getRegion(String id) {
    return regions.where((r) => r.id == id).firstOrNull;
  }

  static PaginatedResponse<Spot> getSpots({String? regionId, int page = 1, int limit = 20}) {
    final filtered = regionId != null
        ? spots.where((s) => s.regionIds.contains(regionId)).toList()
        : spots;

    final start = (page - 1) * limit;
    final end = start + limit > filtered.length ? filtered.length : start + limit;
    final pageSpots = start < filtered.length ? filtered.sublist(start, end) : <Spot>[];

    return PaginatedResponse(
      data: pageSpots,
      pagination: Pagination(page: page, limit: limit, total: filtered.length),
    );
  }

  static Spot? getSpot(String id) {
    return spots.where((s) => s.id == id).firstOrNull;
  }

  static List<Guide> getGuides() => guides;

  static Guide? getGuide(String id) {
    return guides.where((g) => g.id == id).firstOrNull;
  }

  static List<OfflineMap> getMaps() => maps;

  static OfflineMap? getMap(String id) {
    return maps.where((m) => m.id == id).firstOrNull;
  }

  static PaginatedResponse<Review> getReviews({
    bool? isApproved,
    DateTime? fromDate,
    DateTime? toDate,
    int page = 1,
    int limit = 20,
  }) {
    var filtered = reviews.toList();

    if (isApproved != null) {
      filtered = filtered.where((r) => r.isApproved == isApproved).toList();
    }
    if (fromDate != null) {
      filtered = filtered.where((r) => r.createdAt.isAfter(fromDate) || r.createdAt.isAtSameMomentAs(fromDate)).toList();
    }
    if (toDate != null) {
      filtered = filtered.where((r) => r.createdAt.isBefore(toDate) || r.createdAt.isAtSameMomentAs(toDate)).toList();
    }

    final start = (page - 1) * limit;
    final end = start + limit > filtered.length ? filtered.length : start + limit;
    final pageReviews = start < filtered.length ? filtered.sublist(start, end) : <Review>[];

    return PaginatedResponse(
      data: pageReviews,
      pagination: Pagination(page: page, limit: limit, total: filtered.length),
    );
  }

  static List<Place> getPlaces({String? regionId, PlaceType? type}) {
    var filtered = places.toList();
    if (regionId != null) {
      filtered = filtered.where((p) => p.regionId == regionId).toList();
    }
    if (type != null) {
      filtered = filtered.where((p) => p.type == type).toList();
    }
    return filtered;
  }

  static Place? getPlace(String id) {
    return places.where((p) => p.id == id).firstOrNull;
  }

  static List<Direction> getDirections({String? regionId}) {
    if (regionId != null) {
      return directions.where((d) => d.regionId == regionId).toList();
    }
    return directions;
  }

  static Direction? getDirection(String id) {
    return directions.where((d) => d.id == id).firstOrNull;
  }
}
