import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api/admin_api_client.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/api_response.dart';
import '../../data/models/region_model.dart';
import '../../data/models/spot_model.dart';
import '../../data/models/guide_model.dart';
import '../../data/models/offline_map_model.dart';
import '../../data/models/review_model.dart';
import '../../data/models/place_model.dart';
import '../../data/models/direction_model.dart';
import 'auth_provider.dart';

// API Client provider
final apiClientProvider = Provider<AdminApiClient?>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config == null || config.isMockMode) return null;
  return AdminApiClient(config.apiUrl!, config.authToken);
});

// ================== REGIONS ==================

final regionsProvider = FutureProvider<List<Region>>((ref) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.getRegions();
  }
  final client = ref.watch(apiClientProvider);
  return client!.getRegions();
});

final regionDetailProvider = FutureProvider.family<Region, String>((ref, id) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    final region = MockData.getRegion(id);
    if (region == null) throw Exception('Region not found');
    return region;
  }
  final client = ref.watch(apiClientProvider);
  return client!.getRegion(id);
});

// ================== SPOTS ==================

final spotsProvider = FutureProvider.family<PaginatedResponse<Spot>, SpotQuery>((ref, query) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.getSpots(regionId: query.regionId, page: query.page, limit: query.limit);
  }
  final client = ref.watch(apiClientProvider);
  return client!.getSpots(regionId: query.regionId, page: query.page, limit: query.limit);
});

final spotDetailProvider = FutureProvider.family<Spot, String>((ref, id) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    final spot = MockData.getSpot(id);
    if (spot == null) throw Exception('Spot not found');
    return spot;
  }
  final client = ref.watch(apiClientProvider);
  return client!.getSpot(id);
});

// ================== GUIDES ==================

final guidesProvider = FutureProvider<List<Guide>>((ref) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.getGuides();
  }
  final client = ref.watch(apiClientProvider);
  return client!.getGuides();
});

final guideDetailProvider = FutureProvider.family<Guide, String>((ref, id) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    final guide = MockData.getGuide(id);
    if (guide == null) throw Exception('Guide not found');
    return guide;
  }
  final client = ref.watch(apiClientProvider);
  return client!.getGuide(id);
});

// ================== MAPS ==================

final mapsProvider = FutureProvider<List<OfflineMap>>((ref) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.getMaps();
  }
  final client = ref.watch(apiClientProvider);
  return client!.getMaps();
});

final mapDetailProvider = FutureProvider.family<OfflineMap, String>((ref, id) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    final map = MockData.getMap(id);
    if (map == null) throw Exception('Map not found');
    return map;
  }
  final client = ref.watch(apiClientProvider);
  return client!.getMap(id);
});

// ================== REVIEWS ==================

final reviewsProvider = FutureProvider.family<PaginatedResponse<Review>, ReviewQuery>((ref, query) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.getReviews(
      isApproved: query.isApproved,
      fromDate: query.fromDate,
      toDate: query.toDate,
      page: query.page,
      limit: query.limit,
    );
  }
  final client = ref.watch(apiClientProvider);
  return client!.getReviews(query);
});

// ================== PLACES ==================

final placesProvider = FutureProvider.family<List<Place>, String?>((ref, regionId) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.getPlaces(regionId: regionId);
  }
  final client = ref.watch(apiClientProvider);
  return client!.getPlaces(regionId: regionId);
});

final placeDetailProvider = FutureProvider.family<Place, String>((ref, id) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    final place = MockData.getPlace(id);
    if (place == null) throw Exception('Place not found');
    return place;
  }
  final client = ref.watch(apiClientProvider);
  return client!.getPlace(id);
});

// ================== DIRECTIONS ==================

final directionsProvider = FutureProvider.family<List<Direction>, String?>((ref, regionId) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.getDirections(regionId: regionId);
  }
  final client = ref.watch(apiClientProvider);
  return client!.getDirections(regionId: regionId);
});

final directionDetailProvider = FutureProvider.family<Direction, String>((ref, id) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    final direction = MockData.getDirection(id);
    if (direction == null) throw Exception('Direction not found');
    return direction;
  }
  final client = ref.watch(apiClientProvider);
  return client!.getDirection(id);
});

// ================== FILTERS STATE ==================

final selectedRegionIdProvider = StateProvider<String?>((ref) => null);

// Review filters
final reviewApprovalFilterProvider = StateProvider<bool?>((ref) => null); // null = all, false = unapproved, true = approved
final reviewFromDateProvider = StateProvider<DateTime?>((ref) => null);
final reviewToDateProvider = StateProvider<DateTime?>((ref) => null);
