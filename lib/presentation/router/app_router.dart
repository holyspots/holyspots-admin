import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/cities_screen.dart';
import '../screens/city_form_screen.dart';
import '../screens/spots_screen.dart';
import '../screens/spot_form_screen.dart';
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
        return '/cities';
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
          GoRoute(
            path: '/cities',
            builder: (context, state) => const CitiesScreen(),
          ),
          GoRoute(
            path: '/cities/new',
            builder: (context, state) => const CityFormScreen(),
          ),
          GoRoute(
            path: '/cities/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return CityFormScreen(cityId: id);
            },
          ),
          GoRoute(
            path: '/spots',
            builder: (context, state) => const SpotsScreen(),
          ),
          GoRoute(
            path: '/spots/new',
            builder: (context, state) {
              final cityId = state.uri.queryParameters['cityId'];
              return SpotFormScreen(cityId: cityId);
            },
          ),
          GoRoute(
            path: '/spots/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return SpotFormScreen(spotId: id);
            },
          ),
        ],
      ),
    ],
  );
});
