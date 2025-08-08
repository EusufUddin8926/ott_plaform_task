import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show InternetAddress, SocketException;

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) return false;

    return await _hasInternet();
  }

  Future<bool> _hasInternet() async {
    if (kIsWeb) {
      try {
        final response = await http
            .get(Uri.parse("https://jsonplaceholder.typicode.com/posts/1"))
            .timeout(const Duration(seconds: 3));
        return response.statusCode == 200;
      } catch (_) {
        return false;
      }
    } else {
      try {
        final result = await InternetAddress.lookup('google.com')
            .timeout(const Duration(seconds: 3));
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        return false;
      }
    }
  }
}
