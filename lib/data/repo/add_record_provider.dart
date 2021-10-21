import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laundry/data/bean/add_report_bean.dart';
import 'package:laundry/utils/constant/api_const.dart';

class AddRecordProvider with ChangeNotifier {
  late List<AddReportBean> _reportListRespo;

  AddRecordProvider() {
    _reportListRespo = [];
  }

  List<AddReportBean> get getReports => _reportListRespo;

  Future<List<AddReportBean>> fetchReports(
      String mobileNo, String custMobileNo) async {
    var fetchdoc = await FirebaseFirestore.instance
        .collection(ApiConst.FIRESTORE_COLL_USERS +
            "/$mobileNo/" +
            ApiConst.FIRESTORE_CUSTOMER +
            "/$custMobileNo/" +
            ApiConst.FIRESTORE_REPORT)
        .withConverter<AddReportBean>(
      fromFirestore: (snapshots, _) =>
          AddReportBean.fromJson(snapshots.data()!),
      toFirestore: (data, _) => data.toJson(),
    ).get();
    final List<DocumentSnapshot> documents = fetchdoc.docs;
    List<AddReportBean> reportList = [];
    for (var dataSnapshot in documents) {
      reportList.add(dataSnapshot.data() as AddReportBean);
    }
    _reportListRespo = reportList;
    notifyListeners();
    return reportList;
  }
}
