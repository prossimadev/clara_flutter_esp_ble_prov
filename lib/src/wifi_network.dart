/// Represents a WiFi network with its SSID and signal strength (RSSI)
class WifiNetwork {
  /// The SSID (name) of the WiFi network
  final String ssid;

  /// The RSSI (Received Signal Strength Indicator) in dBm
  /// Typical values range from -30 (excellent) to -90 (poor)
  final int rssi;

  WifiNetwork({required this.ssid, required this.rssi});

  /// Creates a WifiNetwork from a map received from the platform channel
  factory WifiNetwork.fromMap(Map<dynamic, dynamic> map) {
    return WifiNetwork(
      ssid: map['ssid'] as String,
      rssi: map['rssi'] as int,
    );
  }

  /// Converts this WifiNetwork to a map for platform channel communication
  Map<String, dynamic> toMap() {
    return {
      'ssid': ssid,
      'rssi': rssi,
    };
  }

  @override
  String toString() => 'WifiNetwork(ssid: $ssid, rssi: $rssi dBm)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WifiNetwork &&
          runtimeType == other.runtimeType &&
          ssid == other.ssid &&
          rssi == other.rssi;

  @override
  int get hashCode => ssid.hashCode ^ rssi.hashCode;
}
