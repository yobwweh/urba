import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/properties_controller.dart';

class PropertiesScreen extends GetView<PropertiesController> {
  const PropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PropertiesScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PropertiesScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
