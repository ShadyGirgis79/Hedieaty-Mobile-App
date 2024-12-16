
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class Internet{
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> waitForInternetConnection() async {
    // Wait for the connection to be restored
    while (true) {
      bool isConnected = await checkInternetConnection();
      if (isConnected) {
        break;
      }
      await Future.delayed(const Duration(seconds: 2)); // Check every 2 seconds
    }
  }

  void showLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(), // Show loading spinner
        );
      },
    );
  }
}