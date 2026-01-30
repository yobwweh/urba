import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/market_controller.dart';

class MarketScreen extends GetView<MarketController> {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MarketScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MarketScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
