import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../models/api_response.dart';
import '../models/city_model.dart';
import '../models/spot_model.dart';

class AdminApiClient {
  final Dio _dio;
  final String baseUrl;

  AdminApiClient(this.baseUrl, [String? authToken])
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            if (authToken != null) 'Authorization': 'Bearer $authToken',
          },
        ));

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Auth
  Future<ApiResponse<Map<String, dynamic>>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return ApiResponse.fromJson(response.data, (data) => data as Map<String, dynamic>);
    } on DioException catch (e) {
      return ApiResponse(success: false, error: e.message ?? 'Login failed');
    }
  }

  // Cities
  Future<List<City>> getCities({int page = 1, int limit = 100}) async {
    final response = await _dio.get('/cities', queryParameters: {
      'page': page,
      'limit': limit,
      'order_by': 'order',
      'order_dir': 'asc',
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as List)
          .map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(apiResponse.error ?? 'Failed to load cities');
  }

  Future<City> getCity(String id) async {
    final response = await _dio.get('/cities/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return City.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'City not found');
  }

  Future<City> createCity(CityInput input) async {
    final response = await _dio.post('/cities', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return City.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create city');
  }

  Future<City> updateCity(String id, CityInput input) async {
    final response = await _dio.put('/cities/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return City.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update city');
  }

  Future<void> deleteCity(String id) async {
    final response = await _dio.delete('/cities/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete city');
    }
  }

  Future<void> reorderCities(List<String> order) async {
    final response = await _dio.put('/cities/reorder', data: {
      'order': order,
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to reorder cities');
    }
  }

  // Spots
  Future<PaginatedResponse<Spot>> getSpots({String? cityId, int page = 1, int limit = 20}) async {
    final response = await _dio.get('/spots', queryParameters: {
      if (cityId != null) 'city_id': cityId,
      'page': page,
      'limit': limit,
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      final spots = (apiResponse.data as List)
          .map((e) => Spot.fromJson(e as Map<String, dynamic>))
          .toList();
      return PaginatedResponse(
        data: spots,
        pagination: apiResponse.pagination ?? Pagination(page: page, limit: limit, total: spots.length),
      );
    }
    throw Exception(apiResponse.error ?? 'Failed to load spots');
  }

  Future<Spot> getSpot(String id) async {
    final response = await _dio.get('/spots/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Spot.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Spot not found');
  }

  Future<Spot> createSpot(SpotInput input) async {
    final response = await _dio.post('/spots', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Spot.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create spot');
  }

  Future<Spot> updateSpot(String id, SpotInput input) async {
    final response = await _dio.put('/spots/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Spot.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update spot');
  }

  Future<void> deleteSpot(String id) async {
    final response = await _dio.delete('/spots/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete spot');
    }
  }

  // Files
  Future<String> uploadFile(PlatformFile file, {String folder = 'uploads'}) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        file.bytes!,
        filename: file.name,
      ),
      'folder': folder,
    });
    final response = await _dio.post('/files/upload', data: formData);
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as Map<String, dynamic>)['url'] as String? ?? '';
    }
    throw Exception(apiResponse.error ?? 'Upload failed');
  }
}
