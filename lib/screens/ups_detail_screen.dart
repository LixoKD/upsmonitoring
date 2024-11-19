import 'package:flutter/material.dart';
import '../models/ups_data.dart';

class UpsDetailScreen extends StatelessWidget {
  final UpsData upsData;

  const UpsDetailScreen({Key? key, required this.upsData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${upsData.upsName} Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("UPS Name: ${upsData.upsName}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Status: ${upsData.status}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Battery: ${upsData.batteryPercent}%", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Floor: ${upsData.floor}", style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
