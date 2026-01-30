import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../properties/models/properties_model.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Urba - Gestion'),
        centerTitle: true,
        actions: [
          // Affichage de l'argent en temps réel
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Obx(() => Text(
                    "${controller.balance.value.toStringAsFixed(0)} \$",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Marché Immobilier",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Liste des propriétés
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.properties.length,
                    itemBuilder: (context, index) {
                      final prop = controller.properties[index];
                      return _buildPropertyCard(prop);
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard(PropertyModel prop) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          prop.isOwned ? Icons.check_circle : Icons.home_work,
          color: prop.isOwned ? Colors.green : Colors.grey,
          size: 40,
        ),
        title: Text(prop.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Revenu: ${prop.incomePerSecond}\$/sec"),
        trailing: prop.isOwned
            ? const Text("ACQUIS", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
            : ElevatedButton(
                onPressed: () => controller.buyProperty(prop),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                child: Text("Acheter ${prop.price.toStringAsFixed(0)}\$"),
              ),
      ),
    );
  }
}