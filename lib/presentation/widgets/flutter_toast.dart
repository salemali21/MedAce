import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> showFlutterToast({
  required String title,
  ToastGravity? gravity,
}) async {
  await Fluttertoast.showToast(
    msg: title,
    toastLength: Toast.LENGTH_SHORT,
    gravity: gravity ?? ToastGravity.CENTER,
    backgroundColor: Colors.grey,
    fontSize: 14.0,
  );
}
