import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundry/utils/common/widget_helper.dart';

showAlertDialog({BuildContext? ctx, String? title, String? msg}) => showDialog(
    context: ctx!,
    builder: (_) => AlertDialog(
          title: getTxtBlackColor(msg: title!, fontWeight: FontWeight.bold),
          content: getTxt(msg: msg!),
        ));

showSingleClickDialog(
        {required BuildContext ctx,
        required String title,
        required String msg,
        okClick}) =>
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: getTxtBlackColor(msg: title, fontWeight: FontWeight.bold),
            content: getTxt(msg: msg),
            actions: [FlatButton(child: const Text("OK"), onPressed: okClick)]);
      },
    );

showTwoClickDialog(
        {required BuildContext ctx,
        required String title,
        required String msg,
        okClick,
        cancelClick}) =>
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: getTxtBlackColor(msg: title, fontWeight: FontWeight.bold),
            content: getTxt(msg: msg),
            actions: [
              FlatButton(child: getTxt(msg: 'OK'), onPressed: okClick),
              FlatButton(child: getTxt(msg: 'Cancel'), onPressed: cancelClick),
            ]);
      },
    );
