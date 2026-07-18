import '../models/localized_text.dart';
import '../models/geo_point.dart';
import '../models/city_model.dart';
import '../models/spot_model.dart';
import '../models/api_response.dart';

class MockData {
  static final cities = [
    City(
      id: 'city-1',
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
    City(
      id: 'city-2',
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
    City(
      id: 'city-3',
      name: const LocalizedText(
        ru: 'Пури',
        en: 'Puri',
        hi: 'पुरी',
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

  static final spots = [
    Spot(
      id: 'spot-1',
      cityId: 'city-1',
      name: const LocalizedText(
        ru: 'Храм Кришна-Баларам',
        en: 'Krishna-Balaram Temple',
        hi: 'कृष्ण-बलराम मंदिर',
      ),
      descr: const LocalizedText(
        ru: 'Главный храм ИСККОН во Вриндаване, основан в 1975 году',
        en: 'Main ISKCON temple in Vrindavan, founded in 1975',
        hi: 'वृन्दावन में मुख्य इस्कॉन मंदिर, 1975 में स्थापित',
      ),
      mainPhoto: 'https://placeholder.com/kb-temple.jpg',
      location: const GeoPoint(latitude: 27.5833, longitude: 77.6833),
      address: 'Raman Reti, Vrindavan, UP 281121',
      order: 1,
      photos: [
        'https://placeholder.com/kb1.jpg',
        'https://placeholder.com/kb2.jpg',
      ],
      audios: [
        const SpotAudio(file: 'kb-ru.mp3', lang: 'ru'),
        const SpotAudio(file: 'kb-en.mp3', lang: 'en'),
      ],
    ),
    Spot(
      id: 'spot-2',
      cityId: 'city-1',
      name: const LocalizedText(
        ru: 'Банке Бихари',
        en: 'Banke Bihari Temple',
        hi: 'बांके बिहारी मंदिर',
      ),
      descr: const LocalizedText(
        ru: 'Один из самых почитаемых храмов Вриндавана',
        en: 'One of the most revered temples of Vrindavan',
        hi: 'वृन्दावन के सबसे पूजनीय मंदिरों में से एक',
      ),
      mainPhoto: 'https://placeholder.com/banke-bihari.jpg',
      location: const GeoPoint(latitude: 27.5814, longitude: 77.6589),
      address: 'Banke Bihari Temple Rd, Vrindavan',
      order: 2,
      photos: [],
      audios: [],
    ),
    Spot(
      id: 'spot-3',
      cityId: 'city-2',
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
    ),
  ];

  static List<City> getCities() {
    return cities;
  }

  static City? getCity(String id) {
    return cities.where((c) => c.id == id).firstOrNull;
  }

  static PaginatedResponse<Spot> getSpots({String? cityId, int page = 1, int limit = 20}) {
    final filtered = cityId != null
        ? spots.where((s) => s.cityId == cityId).toList()
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
}
