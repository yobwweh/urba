import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/finance_controller.dart';

class FinanceScreen extends GetView<FinanceController> {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FinanceScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'FinanceScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
