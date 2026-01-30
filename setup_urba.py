import os

# --- CONFIGURATION DU PROJET ---
PROJECT_NAME = "urba"
LIB_DIR = "lib"
NATIVE_DIR = "native"

# Structure des dossiers globaux
CORE_DIRS = [
    "common",
    "utils",
    "routes",
    "services",
    "features",
]

# Liste des fonctionnalités du jeu
FEATURES = [
    "auth",
    "dashboard",
    "properties",
    "finance",
    "market",
]

# Structure interne d'une Feature (MVC + GetX)
FEATURE_SUBDIRS = [
    "bindings",
    "controllers",
    "models",
    "screens",
    "widgets",
]

# --- UTILITAIRES ---

def to_pascal_case(text):
    """Convertit snake_case en PascalCase (ex: auth -> Auth, user_profile -> UserProfile)"""
    return "".join(x.title() for x in text.split("_"))

def create_file(path, content):
    """Crée un fichier avec du contenu seulement s'il n'existe pas déjà."""
    if os.path.exists(path):
        print(f"⚠️  Existe déjà (ignoré) : {path}")
        return
    
    try:
        with open(path, "w", encoding="utf-8") as f:
            f.write(content.strip() + "\n")
        print(f"✅ Créé : {path}")
    except Exception as e:
        print(f"❌ Erreur lors de la création de {path}: {e}")

def create_dir(path):
    """Crée un dossier s'il n'existe pas."""
    if not os.path.exists(path):
        os.makedirs(path)

# --- TEMPLATES (BOILERPLATE) ---

def get_controller_template(feature_name):
    class_name = to_pascal_case(feature_name)
    return f"""
import 'package:get/get.dart';

class {class_name}Controller extends GetxController {{
  // TODO: Implement {class_name}Controller

  @override
  void onInit() {{
    super.onInit();
  }}

  @override
  void onReady() {{
    super.onReady();
  }}

  @override
  void onClose() {{
    super.onClose();
  }}
}}
"""

def get_binding_template(feature_name):
    class_name = to_pascal_case(feature_name)
    return f"""
import 'package:get/get.dart';
import '../controllers/{feature_name}_controller.dart';

class {class_name}Binding extends Bindings {{
  @override
  void dependencies() {{
    Get.lazyPut<{class_name}Controller>(
      () => {class_name}Controller(),
    );
  }}
}}
"""

def get_screen_template(feature_name):
    class_name = to_pascal_case(feature_name)
    return f"""
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/{feature_name}_controller.dart';

class {class_name}Screen extends GetView<{class_name}Controller> {{
  const {class_name}Screen({{Key? key}}) : super(key: key);

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(
        title: const Text('{class_name}Screen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          '{class_name}Screen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }}
}}
"""

TEMPLATE_APP_ROUTES = """
part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart or custom scripts.

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  // Ajoute tes routes ici
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
}
"""

TEMPLATE_APP_PAGES = """
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    // GetPage(
    //   name: _Paths.HOME,
    //   page: () => HomeScreen(),
    //   binding: HomeBinding(),
    // ),
  ];
}
"""

TEMPLATE_CONSTANTS = """
class AppConstants {
  static const String appName = "Urba";
  // Ajoute tes constantes globales ici
}
"""

# --- FONCTION PRINCIPALE ---

def main():
    print(f"🚀 Initialisation de l'architecture pour {PROJECT_NAME}...")

    # 1. Création du dossier Rust Native
    create_dir(NATIVE_DIR)
    create_file(os.path.join(NATIVE_DIR, ".gitkeep"), "")

    # 2. Création des dossiers core dans lib/
    for folder in CORE_DIRS:
        path = os.path.join(LIB_DIR, folder)
        create_dir(path)

    # 3. Génération des fichiers Core (Routes, Utils)
    create_file(os.path.join(LIB_DIR, "routes", "app_routes.dart"), TEMPLATE_APP_ROUTES)
    create_file(os.path.join(LIB_DIR, "routes", "app_pages.dart"), TEMPLATE_APP_PAGES)
    create_file(os.path.join(LIB_DIR, "utils", "constants.dart"), TEMPLATE_CONSTANTS)
    
    # Création d'un service Rust de base
    create_file(os.path.join(LIB_DIR, "services", "rust_bridge_service.dart"), 
                "class RustBridgeService {\n  // Future integration with Rust\n}")

    # 4. Génération des Features
    features_dir = os.path.join(LIB_DIR, "features")
    
    for feature in FEATURES:
        feature_path = os.path.join(features_dir, feature)
        create_dir(feature_path)

        # Création des sous-dossiers (bindings, controllers, etc.)
        for subdir in FEATURE_SUBDIRS:
            create_dir(os.path.join(feature_path, subdir))

        # --- Génération des fichiers spécifiques à la Feature ---
        
        # Controller
        create_file(
            os.path.join(feature_path, "controllers", f"{feature}_controller.dart"),
            get_controller_template(feature)
        )

        # Binding
        create_file(
            os.path.join(feature_path, "bindings", f"{feature}_binding.dart"),
            get_binding_template(feature)
        )

        # Screen
        create_file(
            os.path.join(feature_path, "screens", f"{feature}_screen.dart"),
            get_screen_template(feature)
        )

        # Models (Fichier vide mais présent)
        create_file(
            os.path.join(feature_path, "models", f"{feature}_model.dart"),
            f"class {to_pascal_case(feature)}Model {{\n  // TODO: Define model\n}}"
        )

    print("\n✨ Architecture Urba générée avec succès ! Bon code.")

if __name__ == "__main__":
    main()