import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api/admin_api_client.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/api_response.dart';
import '../../data/models/city_model.dart';
import '../../data/models/spot_model.dart';
import 'auth_provider.dart';

// API Client provider
final apiClientProvider = Provider<AdminApiClient?>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config == null || config.isMockMode) return null;
  return AdminApiClient(config.apiUrl!, config.authToken);
});

// Cities
final citiesProvider = FutureProvider<List<City>>((ref) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.getCities();
  }
  final client = ref.watch(apiClientProvider);
  return client!.getCities();
});

final cityDetailProvider = FutureProvider.family<City, String>((ref, id) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    final city = MockData.getCity(id);
    if (city == null) throw Exception('City not found');
    return city;
  }
  final client = ref.watch(apiClientProvider);
  return client!.getCity(id);
});

// Spots
final spotsProvider = FutureProvider.family<PaginatedResponse<Spot>, SpotQuery>((ref, query) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.getSpots(cityId: query.cityId, page: query.page, limit: query.limit);
  }
  final client = ref.watch(apiClientProvider);
  return client!.getSpots(cityId: query.cityId, page: query.page, limit: query.limit);
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

// Selected filters state
final selectedCityIdProvider = StateProvider<String?>((ref) => null);
