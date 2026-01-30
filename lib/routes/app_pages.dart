import 'package:get/get.dart';

// Imports des features générées
import '../features/dashboard/bindings/dashboard_binding.dart';
import '../features/dashboard/screens/dashboard_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // On définit le Dashboard comme page de démarrage pour l'instant
  static const INITIAL = Routes.DASHBOARD;

  static final routes = [
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    // Tu pourras décommenter et ajouter les autres routes (Auth, Properties...) ici
  ];
}