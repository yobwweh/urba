import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urba/services/rust_bridge/generated/lib.dart';
import '../../properties/models/properties_model.dart';

class DashboardController extends GetxController {
  final RxDouble balance = 10000.0.obs;
  final RxList<PropertyModel> properties = <PropertyModel>[].obs;
  final RxDouble currentGlobalIncome = 0.0.obs;
  final RxDouble prestigeMultiplier = 1.0.obs;

  Timer? _gameTimer;

  @override
  void onInit() {
    super.onInit();
    _initGame();
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }

  Future<void> _initGame() async {
    await _loadFromDisk();
    await _handleOfflineEarnings(); 
    _startGameLoop();
  }

  // --- LOGIQUE RUST ---

  Future<void> _tick() async {
    final ownedProperties = properties.where((p) => p.isOwned).toList();

    debugPrint("🎮 Tick - Propriétés possédées: ${ownedProperties.length}");
    for (var p in ownedProperties) {
      debugPrint("  - ${p.name}: qty=${p.quantity}, level=${p.level}, income=${p.incomePerSecond}");
    }

    if (ownedProperties.isEmpty) return;

    final rustInput = ownedProperties.map((p) => PropertyData(
      baseIncome: p.incomePerSecond,
      quantity: p.quantity,
      level: p.level,
    )).toList();

    try {
      // Calcul du revenu via Rust
      final double totalTickIncome = await calculateTotalIncome(
        properties: rustInput, 
        globalPrestige: prestigeMultiplier.value,
      );

      debugPrint("💰 Revenu calculé par Rust: $totalTickIncome");

      balance.value += totalTickIncome;
      currentGlobalIncome.value = totalTickIncome;
      
      // Sauvegarde du timestamp pour le calcul hors-ligne
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_timestamp', DateTime.now().millisecondsSinceEpoch);
      
    } catch (e) {
      debugPrint("Erreur Tick Rust : $e");
      // Fallback: calculer le revenu en Dart si Rust n'est pas disponible
      try {
        double fallback = 0.0;
        for (var p in ownedProperties) {
          final levelMultiplier = math.pow(1.10, p.level).toDouble();
          fallback += p.incomePerSecond * (p.quantity.toDouble()) * levelMultiplier;
        }
        fallback *= prestigeMultiplier.value;
        debugPrint("⚠️ Fallback Dart revenu: $fallback");
        balance.value += fallback;
        currentGlobalIncome.value = fallback;
      } catch (e2) {
        debugPrint("Erreur fallback Dart: $e2");
      }
    }
  }

  Future<void> _handleOfflineEarnings() async {
    final prefs = await SharedPreferences.getInstance();
    final lastTime = prefs.getInt('last_timestamp');
    
    if (lastTime != null) {
      final secondsAway = (DateTime.now().millisecondsSinceEpoch - lastTime) ~/ 1000;

      if (secondsAway > 10) {
        final rustInput = properties.where((p) => p.isOwned).map((p) => PropertyData(
          baseIncome: p.incomePerSecond,
          quantity: p.quantity,
          level: p.level,
        )).toList();

        final gain = await calculateOfflineEarnings(
          properties: rustInput,
          globalPrestige: prestigeMultiplier.value,
          secondsAway: secondsAway,
        );

        balance.value += gain;
        Get.snackbar("Bon retour !", "Gain hors-ligne : ${gain.toStringAsFixed(2)} \$",
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  // --- ACTIONS ---

  void buyProperty(PropertyModel property) {
    if (balance.value >= property.price) {
      balance.value -= property.price;
      int index = properties.indexOf(property);
      
      if (properties[index].isOwned) {
        properties[index].quantity += 1;
      } else {
        properties[index].isOwned = true;
        properties[index].quantity = 1;
      }
      
      properties.refresh();
      _saveToDisk();
      debugPrint("🛒 Achat: ${property.name} — owned=${properties[index].isOwned}, qty=${properties[index].quantity}");
    }
  }

  void upgradeProperty(PropertyModel property) {
    double upgradeCost = property.price * 0.5 * (property.level + 1);

    if (balance.value >= upgradeCost) {
      balance.value -= upgradeCost;
      int index = properties.indexOf(property);
      properties[index].level += 1;
      
      properties.refresh();
      _saveToDisk();
    }
  }

  // --- PERSISTANCE ---

  Future<void> _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('balance', balance.value);
    await prefs.setDouble('prestige', prestigeMultiplier.value);
    List<String> propsJson = properties.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList('properties', propsJson);
  }

  Future<void> _loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    balance.value = prefs.getDouble('balance') ?? 10000.0;
    prestigeMultiplier.value = prefs.getDouble('prestige') ?? 1.0;

    List<String>? savedProps = prefs.getStringList('properties');
    if (savedProps != null && savedProps.isNotEmpty) {
      properties.value = savedProps.map((item) => PropertyModel.fromJson(jsonDecode(item))).toList();
    } else {
      _loadMockData();
    }
  }

  void _startGameLoop() {
    const interval = Duration(seconds: 1);
    debugPrint("⏱️ Démarrage boucle de jeu (interval: ${interval.inSeconds}s)");
    _gameTimer = Timer.periodic(interval, (_) => _tick());
  }

  void _loadMockData() {
    properties.assignAll([
      PropertyModel(id: '1', name: 'Appartement T1', price: 5000, incomePerSecond: 15),
      PropertyModel(id: '2', name: 'Boulangerie', price: 15000, incomePerSecond: 50),
    ]);
  }
}