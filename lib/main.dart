import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';

// ✅ IMPORT CORRECT : Pointe vers le fichier de génération du bridge
import 'services/rust_bridge/generated/frb_generated.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // ✅ INITIALISATION : On utilise la classe générée
    await RustLib.init(); 
    debugPrint("✅ Rust Engine initialisé avec succès.");
  } catch (e) {
    debugPrint("❌ Erreur d'initialisation Rust : $e");
    // Optionnel : Tu peux décider de lancer l'app quand même ou d'afficher une erreur
  }

  runApp(const UrbaApp());
}

class UrbaApp extends StatelessWidget {
  const UrbaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Urba',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => const Scaffold(
          body: Center(child: Text("Route introuvable")),
        ),
      ),
    );
  }
}