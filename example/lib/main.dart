import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_esp_ble_prov/flutter_esp_ble_prov.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterEspBleProvPlugin = FlutterEspBleProv();

  final defaultPadding = 12.0;
  final defaultDevicePrefix = 'PROV';

  List<String> devices = [];
  List<WifiNetwork> networks = [];

  String selectedDeviceName = '';
  String selectedSsid = '';
  String feedbackMessage = '';

  final prefixController = TextEditingController(text: 'PROV_');
  final proofOfPossessionController = TextEditingController(text: 'abcd1234');
  final passphraseController = TextEditingController();

  Future scanBleDevices() async {
    final prefix = prefixController.text;
    final scannedDevices =
        await _flutterEspBleProvPlugin.scanBleDevices(prefix);
    setState(() {
      devices = scannedDevices;
    });
    pushFeedback('Success: scanned BLE devices');
  }

  Future scanWifiNetworks() async {
    final proofOfPossession = proofOfPossessionController.text;
    final scannedNetworks = await _flutterEspBleProvPlugin.scanWifiNetworks(
        selectedDeviceName, proofOfPossession);
    setState(() {
      networks = scannedNetworks;
    });
    pushFeedback('Success: scanned WiFi on $selectedDeviceName');
  }

  Future provisionWifi() async {
    final proofOfPossession = proofOfPossessionController.text;
    final passphrase = passphraseController.text;
    await _flutterEspBleProvPlugin.provisionWifi(
        selectedDeviceName, proofOfPossession, selectedSsid, passphrase);
    pushFeedback(
        'Success: provisioned WiFi $selectedDeviceName on $selectedSsid');
  }

  pushFeedback(String msg) {
    setState(() {
      feedbackMessage = '$feedbackMessage\n$msg';
    });
  }

  // Helper per ottenere l'icona in base all'intensità del segnale
  IconData _getSignalIcon(int rssi) {
    if (rssi >= -50) return Icons.signal_wifi_4_bar;
    if (rssi >= -60) return Icons.signal_wifi_4_bar;
    if (rssi >= -70) return Icons.network_wifi_3_bar;
    if (rssi >= -80) return Icons.network_wifi_2_bar;
    return Icons.network_wifi_1_bar;
  }

  // Helper per ottenere il colore in base all'intensità del segnale
  Color _getSignalColor(int rssi) {
    if (rssi >= -50) return Colors.green;
    if (rssi >= -60) return Colors.lightGreen;
    if (rssi >= -70) return Colors.orange;
    if (rssi >= -80) return Colors.deepOrange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ESP BLE Provisioning Example'),
          actions: [
            IconButton(
                icon: const Icon(Icons.bluetooth),
                onPressed: () async {
                  await scanBleDevices();
                }),
          ],
        ),
        bottomSheet: SafeArea(
          child: Container(
            width: double.infinity,
            color: Colors.black87,
            padding: EdgeInsets.all(defaultPadding),
            child: Text(
              feedbackMessage,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.green.shade600),
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text('Device Prefix'),
                        ),
                        Expanded(
                          child: TextField(
                            controller: prefixController,
                            decoration: const InputDecoration(
                                hintText: 'enter device prefix'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(defaultPadding),
                    child: const Text('BLE devices'),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(
                          devices[i],
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () async {
                          selectedDeviceName = devices[i];
                          await scanWifiNetworks();
                        },
                      );
                    },
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text('Proof of possession'),
                        ),
                        Expanded(
                          child: TextField(
                            controller: proofOfPossessionController,
                            decoration: const InputDecoration(
                                hintText: 'enter proof of possession string'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(defaultPadding),
                    child: const Text('WiFi networks'),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: networks.length,
                    itemBuilder: (context, i) {
                      final network = networks[i];
                      return ListTile(
                        title: Text(
                          network.ssid,
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Signal: ${network.rssi} dBm',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        trailing: Icon(
                          _getSignalIcon(network.rssi),
                          color: _getSignalColor(network.rssi),
                        ),
                        onTap: () async {
                          selectedSsid = network.ssid;
                          await provisionWifi();
                        },
                      );
                    },
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text('WiFi Passphrase'),
                        ),
                        Expanded(
                          child: TextField(
                            controller: passphraseController,
                            decoration: const InputDecoration(
                                hintText: 'enter passphrase'),
                            obscureText: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
