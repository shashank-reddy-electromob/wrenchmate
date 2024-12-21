import 'dart:developer';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateService {
  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      // Initialize Firebase Remote Config
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10), // Fetch timeout
        minimumFetchInterval: Duration.zero, // Force a fresh fetch
      ));
      await remoteConfig.fetchAndActivate();

      // Get the minimum required version
      String minimumRequiredVersion =
          remoteConfig.getString('minimum_required_version');

      // Get the current app version
      final packageInfo = await PackageInfo.fromPlatform();
      log('the current version of app is ${packageInfo.version.toString()}');
      log('the minimum version of app is ${minimumRequiredVersion.toString()}');

      String currentVersion = packageInfo.version;

      // Compare versions
      if (_isVersionOutdated(currentVersion, minimumRequiredVersion)) {
        _showForceUpdateDialog(context);
      }
    } catch (e) {
      print('Failed to fetch remote config: $e');
    }
  }

  static bool _isVersionOutdated(String currentVersion, String minimumVersion) {
    List<int> currentParts = currentVersion.split('.').map(int.parse).toList();
    List<int> minimumParts = minimumVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < minimumParts.length; i++) {
      if (i >= currentParts.length || currentParts[i] < minimumParts[i]) {
        return true;
      } else if (currentParts[i] > minimumParts[i]) {
        return false;
      }
    }
    return false;
  }

  static void _showForceUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent user from dismissing the dialog by tapping outside
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false, // Disable the back button
          child: AlertDialog(
            title: Text('Update Required'),
            content: Text(
              'A new version of this app is available. Please update to continue.',
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final packageInfo = await PackageInfo.fromPlatform();
                  final packageName = packageInfo.packageName;

                  final appStoreUrl = Platform.isIOS
                      ? 'https://apps.apple.com/app/$packageName' // Replace with your iOS App Store URL
                      : 'https://play.google.com/store/apps/details?id=$packageName'; // Android Play Store URL

                  if (await canLaunch(appStoreUrl)) {
                    await launch(appStoreUrl);
                  } else {
                    throw 'Could not launch $appStoreUrl';
                  }
                },
                child: Text('UPDATE NOW'),
              ),
            ],
          ),
        );
      },
    );
  }
}
