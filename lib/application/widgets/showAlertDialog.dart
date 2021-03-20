import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

showAlertDialog({
  @required BuildContext context,
  @required String title,
  @required String content,
  @required String defaultActionText,
  @required bool requiredCallback,
  String defaultCancelActionText,
  Function continueCallBack,
}) async {
  bool isWebOrAndroid;
  try {
    if (Platform.isIOS) {
      isWebOrAndroid = false;
    } else {
      isWebOrAndroid = true;
    }
  } catch (e) {
    isWebOrAndroid = true;
  }
  if (!isWebOrAndroid) {
    return await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                CupertinoDialogAction(
                    child: Text(defaultActionText),
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          if (requiredCallback) continueCallBack(true),
                        }),
                defaultCancelActionText != null
                    ? CupertinoDialogAction(
                        child: Text(defaultCancelActionText),
                        onPressed: () => {
                              Navigator.of(context).pop(),
                              if (requiredCallback) continueCallBack(false),
                            })
                    : SizedBox.shrink(),
              ],
            ));
  } else {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                    child: Text(defaultActionText),
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          if (requiredCallback) continueCallBack(true),
                        }),
                defaultCancelActionText != null
                    ? TextButton(
                        child: Text(defaultCancelActionText),
                        onPressed: () => {
                              Navigator.of(context).pop(),
                              if (requiredCallback) continueCallBack(false),
                            })
                    : SizedBox.shrink()
              ],
            ));
  }
}
