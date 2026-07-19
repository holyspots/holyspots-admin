import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/regions_screen.dart';
import '../screens/region_form_screen.dart';
import '../screens/spots_screen.dart';
import '../screens/spot_form_screen.dart';
import '../screens/guides_screen.dart';
import '../screens/guide_form_screen.dart';
import '../screens/maps_screen.dart';
import '../screens/map_form_screen.dart';
import '../screens/reviews_screen.dart';
import '../screens/places_screen.dart';
import '../screens/place_form_screen.dart';
import '../screens/directions_screen.dart';
import '../screens/direction_form_screen.dart';
import '../widgets/main_layout.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoginRoute) {
        return '/login';
      }

      if (isAuthenticated && isLoginRoute) {
        return '/spots'; // Spots is first tab per mockup
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          // Spots
          GoRoute(
            path: '/spots',
            builder: (context, state) => const SpotsScreen(),
          ),
          GoRoute(
            path: '/spots/new',
            builder: (context, state) {
              final regionId = state.uri.queryParameters['regionId'];
              return SpotFormScreen(regionId: regionId);
            },
          ),
          GoRoute(
            path: '/spots/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return SpotFormScreen(spotId: id);
            },
          ),

          // Regions
          GoRoute(
            path: '/regions',
            builder: (context, state) => const RegionsScreen(),
          ),
          GoRoute(
            path: '/regions/new',
            builder: (context, state) => const RegionFormScreen(),
          ),
          GoRoute(
            path: '/regions/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return RegionFormScreen(regionId: id);
            },
          ),

          // Guides
          GoRoute(
            path: '/guides',
            builder: (context, state) => const GuidesScreen(),
          ),
          GoRoute(
            path: '/guides/new',
            builder: (context, state) => const GuideFormScreen(),
          ),
          GoRoute(
            path: '/guides/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return GuideFormScreen(guideId: id);
            },
          ),

          // Maps
          GoRoute(
            path: '/maps',
            builder: (context, state) => const MapsScreen(),
          ),
          GoRoute(
            path: '/maps/new',
            builder: (context, state) => const MapFormScreen(),
          ),
          GoRoute(
            path: '/maps/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return MapFormScreen(mapId: id);
            },
          ),

          // Reviews
          GoRoute(
            path: '/reviews',
            builder: (context, state) => const ReviewsScreen(),
          ),

          // Places
          GoRoute(
            path: '/places',
            builder: (context, state) => const PlacesScreen(),
          ),
          GoRoute(
            path: '/places/new',
            builder: (context, state) => const PlaceFormScreen(),
          ),
          GoRoute(
            path: '/places/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return PlaceFormScreen(placeId: id);
            },
          ),

          // Directions
          GoRoute(
            path: '/directions',
            builder: (context, state) => const DirectionsScreen(),
          ),
          GoRoute(
            path: '/directions/new',
            builder: (context, state) => const DirectionFormScreen(),
          ),
          GoRoute(
            path: '/directions/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return DirectionFormScreen(directionId: id);
            },
          ),
        ],
      ),
    ],
  );
});
