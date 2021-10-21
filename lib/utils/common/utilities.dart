import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundry/utils/common/widget_helper.dart';

//  {START PAGE NAVIGATION}
void navigationPush(BuildContext context, StatefulWidget route) {
  Navigator.push(context, MaterialPageRoute(
    builder: (context) {
      return route;
    },
  ));
}

void navigationRemoveAllPush(BuildContext context, StatefulWidget route) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => route,
    ),
    (route) => false,
  );
}

void navigationPop(BuildContext context, StatefulWidget route) {
  Navigator.pop(context, MaterialPageRoute(builder: (context) {
    return route;
  }));
}

void navigationStateLessPush(BuildContext context, StatelessWidget route) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return route;
  }));
}

void navigationStateLessPop(BuildContext context, StatelessWidget route) {
  Navigator.pop(context, MaterialPageRoute(builder: (context) {
    return route;
  }));
}

//  {END PAGE NAVIGATION}


Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}
delay({double durationSec = 1, required Function click}) {
  int sec = (durationSec * 1000).toInt();
  Future.delayed(Duration(milliseconds: sec), () {
    click();
  });
}

void showSnackBar(BuildContext? context, String message) async {
  try {
    var snackBar = SnackBar(
      content: getTxtWhiteColor(msg: message),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
//    action: SnackBarAction(
//        label: "Undo",
//        onPressed: () {
//          logDubug(message + " undo");
//        }),
    );
    Scaffold.of(context!).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(snackBar);
  } catch (e) {
    print('object ' + e.toString());
  }
}
