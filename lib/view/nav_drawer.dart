import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundry/utils/common/str_const.dart';
import 'package:laundry/utils/common/utilities.dart';
import 'package:laundry/utils/common/widget_helper.dart';
import 'package:laundry/utils/constant/assets_const.dart';
import 'package:laundry/view/add_customer_page.dart';

class NavDrawer extends StatelessWidget {
  late BuildContext _ctx;
  late var mobileNo = '';
  late var movieData;

  NavDrawer(this.movieData, this.mobileNo);

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return Drawer(
      child: _drawerView(),
    );
  }

  Widget _drawerView() {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(top: 50)),
            SizedBox(
                height: 140,
                width: 140,
                child: Image.asset(
                  AssetsConst.LOGO_IMG,
                )),
            const Padding(padding: EdgeInsets.only(top: 10)),
            getTxtAppColor(
                msg: StrConst.APP_NAME,
                fontSize: 17,
                fontWeight: FontWeight.bold),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(padding: EdgeInsets.only(top: 30)),
                _getDrawerItem("Home"),
                getDivider(),
                _getDrawerItem("Create Customer"),
                // getDivider(),
                // _getDrawerItem("Profile"),
                // getDivider(),
                // _getDrawerItem("Contact us"),
                // getDivider(),
                // _getDrawerItem("About us"),
                getDivider(),
                _getDrawerItem("Logout"),

                getDivider(),
                _getDrawerItem("Exit"),
                getDivider(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDrawerItem(String title) {
    return GestureDetector(
      onTap: () {
        _navigateOnNextScreen(title);
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 17.0, bottom: 17.0, left: 10.0, right: 3.0),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateOnNextScreen(String title) {
    switch (title) {
      case 'Home':
        return Navigator.of(_ctx).pop();
      case 'Create Customer':
        return navigationPush(_ctx, AddCustomerPage(movieData, mobileNo));
      case 'Logout':
        logout(_ctx);
        break;
      case 'Exit':
        onWillPop(_ctx);
        break;
    }
  }
}
