import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> upsData = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUPSData();
  }

  Future<void> fetchUPSData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse('http://192.168.56.1:3001/ups'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          upsData = data.map((item) => {
            'name': item['ups_name'],
            'status': item['status'],
            'percentage': item['battery_percent'],
            'floor': item['floor'],
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load UPS data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  void navigateBackToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void showUPSDetails(BuildContext context, String upsName, String status, int percentage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(upsName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status: $status'),
              Text('Battery Level: $percentage%'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget buildFloorSection(BuildContext context, String floor, List<Map<String, dynamic>> upsList) {
    return Card(
      elevation: 5,
      child: ExpansionTile(
        title: Text('Floor $floor'),
        children: upsList.map((ups) {
          return ListTile(
            leading: Icon(
              ups['status'] == 'Operational'
                  ? Icons.battery_charging_full
                  : Icons.battery_alert,
              color: ups['status'] == 'Operational' ? Colors.green : Colors.orange,
            ),
            title: Text(ups['name']),
            subtitle: Text(ups['status']),
            trailing: Text('${ups['percentage']}%'),
            onTap: () {
              showUPSDetails(context, ups['name'], ups['status'], ups['percentage']);
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> floorWiseUPSData = {};
    
    for (var ups in upsData) {
      final floor = ups['floor'];
      if (!floorWiseUPSData.containsKey(floor)) {
        floorWiseUPSData[floor] = [];
      }
      floorWiseUPSData[floor]!.add(ups);
    }

    List<Widget> floorWidgets = floorWiseUPSData.keys.map((floor) {
      return buildFloorSection(context, floor, floorWiseUPSData[floor]!);
    }).toList();

    // Add the logout button to the end of the list
    floorWidgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ElevatedButton(
          onPressed: () => navigateBackToLogin(context),
          child: const Text('Logout'),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('UPS Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : ListView.builder(
                    itemCount: floorWidgets.length,
                    itemBuilder: (context, index) => floorWidgets[index],
                  ),
      ),
    );
  }
}
