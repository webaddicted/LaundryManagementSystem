import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundry/data/bean/add_customer_bean.dart';
import 'package:laundry/utils/common/widget_helper.dart';

class HomeItemWidget extends StatelessWidget {
  final List<AddCustomerBean> dataBean;
  final onTap;
  final longPress;

  HomeItemWidget({required this.dataBean, this.onTap, this.longPress});

  @override
  Widget build(BuildContext context) {
    return _createUi();
  }

  Widget _createUi() {
    return ListView.builder(
        itemCount: dataBean == null ? 0 : dataBean.length,
        itemBuilder: (BuildContext context, int index) {
          return taskRow(context, dataBean[index]);
        });
  }

  Widget taskRow(BuildContext context, AddCustomerBean customerInfo) {
    return InkWell(
      onLongPress: () => longPress(customerInfo),
      // splashColor: Col,
      onTap: () => onTap(customerInfo), //nextScreen(context, screenName),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 3, right: 3, top: 5, bottom: 5),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                  backgroundColor: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)],
                  radius: 35.0,
                  child: getTxtWhiteColor(
                      msg: customerInfo.name![0].toUpperCase(),
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              const Padding(padding: EdgeInsets.only(left: 8)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 3),
                    getTxtBlackColor(
                        msg: customerInfo.name!,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    const SizedBox(height: 3),
                    getTxtGreyColor(
                        msg: 'Rate : ${customerInfo.rate}', fontSize: 15),
                    const SizedBox(height: 3),
                    getTxtGreyColor(
                        msg: 'Contact no : ${customerInfo.mobileNo}',
                        fontSize: 15),
                    const SizedBox(height: 3),
                    Align(
                      alignment: Alignment.centerRight,
                      child: getTxtGreyColor(
                          msg: '${customerInfo.date}', fontSize: 15),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
