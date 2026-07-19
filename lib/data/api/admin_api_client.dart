import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../models/api_response.dart';
import '../models/region_model.dart';
import '../models/spot_model.dart';
import '../models/guide_model.dart';
import '../models/offline_map_model.dart';
import '../models/review_model.dart';
import '../models/place_model.dart';
import '../models/direction_model.dart';

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

  // ================== AUTH ==================

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

  // ================== REGIONS ==================

  Future<List<Region>> getRegions({int page = 1, int limit = 100}) async {
    final response = await _dio.get('/regions', queryParameters: {
      'page': page,
      'limit': limit,
      'order_by': 'order',
      'order_dir': 'asc',
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as List)
          .map((e) => Region.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(apiResponse.error ?? 'Failed to load regions');
  }

  Future<Region> getRegion(String id) async {
    final response = await _dio.get('/regions/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Region.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Region not found');
  }

  Future<Region> createRegion(RegionInput input) async {
    final response = await _dio.post('/regions', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Region.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create region');
  }

  Future<Region> updateRegion(String id, RegionInput input) async {
    final response = await _dio.put('/regions/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Region.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update region');
  }

  Future<void> deleteRegion(String id) async {
    final response = await _dio.delete('/regions/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete region');
    }
  }

  Future<void> reorderRegions(List<String> order) async {
    final response = await _dio.post('/regions/reorder', data: {
      'order': order,
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to reorder regions');
    }
  }

  // ================== SPOTS ==================

  Future<PaginatedResponse<Spot>> getSpots({String? regionId, int page = 1, int limit = 20}) async {
    final response = await _dio.get('/spots', queryParameters: {
      if (regionId != null) 'region_id': regionId,
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

  // ================== GUIDES ==================

  Future<List<Guide>> getGuides() async {
    final response = await _dio.get('/guides');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as List)
          .map((e) => Guide.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(apiResponse.error ?? 'Failed to load guides');
  }

  Future<Guide> getGuide(String id) async {
    final response = await _dio.get('/guides/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Guide.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Guide not found');
  }

  Future<Guide> createGuide(GuideInput input) async {
    final response = await _dio.post('/guides', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Guide.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create guide');
  }

  Future<Guide> updateGuide(String id, GuideInput input) async {
    final response = await _dio.put('/guides/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Guide.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update guide');
  }

  Future<void> deleteGuide(String id) async {
    final response = await _dio.delete('/guides/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete guide');
    }
  }

  Future<void> reorderGuides(List<String> order) async {
    final response = await _dio.post('/guides/reorder', data: {
      'order': order,
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to reorder guides');
    }
  }

  // ================== MAPS ==================

  Future<List<OfflineMap>> getMaps() async {
    final response = await _dio.get('/maps');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as List)
          .map((e) => OfflineMap.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(apiResponse.error ?? 'Failed to load maps');
  }

  Future<OfflineMap> getMap(String id) async {
    final response = await _dio.get('/maps/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return OfflineMap.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Map not found');
  }

  Future<OfflineMap> createMap(OfflineMapInput input) async {
    final response = await _dio.post('/maps', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return OfflineMap.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create map');
  }

  Future<OfflineMap> updateMap(String id, OfflineMapInput input) async {
    final response = await _dio.put('/maps/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return OfflineMap.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update map');
  }

  Future<void> deleteMap(String id) async {
    final response = await _dio.delete('/maps/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete map');
    }
  }

  // ================== REVIEWS ==================

  Future<PaginatedResponse<Review>> getReviews(ReviewQuery query) async {
    final response = await _dio.get('/reviews', queryParameters: query.toQueryParams());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      final reviews = (apiResponse.data as List)
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList();
      return PaginatedResponse(
        data: reviews,
        pagination: apiResponse.pagination ?? Pagination(page: query.page, limit: query.limit, total: reviews.length),
      );
    }
    throw Exception(apiResponse.error ?? 'Failed to load reviews');
  }

  Future<void> approveReview(String id) async {
    final response = await _dio.post('/reviews/$id/approve');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to approve review');
    }
  }

  Future<void> deleteReview(String id) async {
    final response = await _dio.delete('/reviews/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete review');
    }
  }

  // ================== PLACES ==================

  Future<List<Place>> getPlaces({String? regionId, PlaceType? type}) async {
    final response = await _dio.get('/places', queryParameters: {
      if (regionId != null) 'region_id': regionId,
      if (type != null) 'type': type == PlaceType.hotel ? 'hotel' : 'food',
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as List)
          .map((e) => Place.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(apiResponse.error ?? 'Failed to load places');
  }

  Future<Place> getPlace(String id) async {
    final response = await _dio.get('/places/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Place.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Place not found');
  }

  Future<Place> createPlace(PlaceInput input) async {
    final response = await _dio.post('/places', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Place.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create place');
  }

  Future<Place> updatePlace(String id, PlaceInput input) async {
    final response = await _dio.put('/places/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Place.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update place');
  }

  Future<void> deletePlace(String id) async {
    final response = await _dio.delete('/places/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete place');
    }
  }

  // ================== DIRECTIONS ==================

  Future<List<Direction>> getDirections({String? regionId}) async {
    final response = await _dio.get('/directions', queryParameters: {
      if (regionId != null) 'region_id': regionId,
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as List)
          .map((e) => Direction.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(apiResponse.error ?? 'Failed to load directions');
  }

  Future<Direction> getDirection(String id) async {
    final response = await _dio.get('/directions/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Direction.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Direction not found');
  }

  Future<Direction> createDirection(DirectionInput input) async {
    final response = await _dio.post('/directions', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Direction.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create direction');
  }

  Future<Direction> updateDirection(String id, DirectionInput input) async {
    final response = await _dio.put('/directions/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Direction.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update direction');
  }

  Future<void> deleteDirection(String id) async {
    final response = await _dio.delete('/directions/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete direction');
    }
  }

  // ================== FILES ==================

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

  Future<void> deleteFile(String filename) async {
    final response = await _dio.delete('/files/$filename');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete file');
    }
  }
}
