import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:journalmax/pages/SyncPage.dart';
import 'package:journalmax/widgets/XSnackBar.dart';

Stream<int> uploadDataToDrive(BuildContext context) async* {
  yield 100;
}

Stream<int> downloadDataToDrive(BuildContext context) async* {
  yield 100;
}

Future<bool> networkAvailable(
    BuildContext context, bool mobileDataAllowed) async {
  final ConnectivityResult connectionType =
      (await Connectivity().checkConnectivity()).toList()[0];
  if (connectionType == ConnectivityResult.wifi ||
      connectionType == ConnectivityResult.vpn) {
    return true;
  }
  if (connectionType == ConnectivityResult.mobile) {
    if (mobileDataAllowed) {
      return true;
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const UseWifiAlert();
          });
    }
  }
  if (connectionType == ConnectivityResult.none) {
    showSnackBar("Internet connection not available", context);
  }
  return false;
}
