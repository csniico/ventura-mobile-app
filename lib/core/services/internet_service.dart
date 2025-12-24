import 'package:connectivity_plus/connectivity_plus.dart';

class InternetService {
  // Singleton setup
  static final InternetService _instance = InternetService._internal();
  factory InternetService() => _instance;
  InternetService._internal();

  final Connectivity _connectivity = Connectivity();

  /// Returns true if the device is connected to mobile data, Wi-Fi, or Ethernet.
  Future<bool> isUserConnected() async {
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();

    return results.any((result) => result != ConnectivityResult.none);
  }
}