import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:laundry/utils/constant/color_const.dart';
import 'package:laundry/utils/sp/sp_manager.dart';
import 'package:laundry/view/home_page_screen.dart';
import 'package:laundry/view/login_page.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme:
              ThemeData().colorScheme.copyWith(secondary: ColorConst.APP_COLOR),
          // accentColor: ColorConst.APP_COLOR,
          // accentColorBrightness: Brightness.light,
          primaryColor: ColorConst.APP_COLOR,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      //AppTheme.lightTheme,
      home: FutureBuilder(
        future: SPManager.getMobileNo(),
        builder: (context, snap) {
          String? mobileNo = snap.data as String?;
          return mobileNo == null || mobileNo.isEmpty
              ? LoginPage()
              : HomePageScreen(mobileNo);
        },
      ),
    );
  }
}
