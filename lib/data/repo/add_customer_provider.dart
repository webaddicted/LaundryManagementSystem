import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laundry/data/bean/add_customer_bean.dart';
import 'package:laundry/utils/constant/api_const.dart';

class AddCustomerProvider with ChangeNotifier {
  late List<AddCustomerBean> _customerListRespo;

  late List<AddCustomerBean> _searchListRespo;

  AddCustomerProvider() {
    _customerListRespo = [];
    _searchListRespo = [];
  }

  List<AddCustomerBean> get getCustomers => _customerListRespo;

  List<AddCustomerBean> get getSearchCust => _searchListRespo;

  Future<List<AddCustomerBean>> customerData(String mobileNo) async {
    print('AddCustomerBean  $mobileNo');
    var customers = await FirebaseFirestore.instance
        .collection(ApiConst.FIRESTORE_COLL_USERS +
            "/$mobileNo/" +
            ApiConst.FIRESTORE_CUSTOMER)
        .withConverter<AddCustomerBean>(
          fromFirestore: (snapshots, _) =>
              AddCustomerBean.fromJson(snapshots.data()!),
          toFirestore: (data, _) => data.toJson(),
        ).get();
    final List<DocumentSnapshot> documents = customers.docs;
    List<AddCustomerBean> custBean = [];
    for (var dataSnapshot in documents) {
      // dataSnapshot.data()
      // print('customer : ');
      custBean.add(dataSnapshot.data() as AddCustomerBean);
    }
    print('customer : $mobileNo    $custBean');
    _customerListRespo = custBean;
    _searchListRespo = custBean;
    notifyListeners();
    return custBean;
    // setState(() {});
  }

  void onDataChange(String value) {
    try {
      _searchListRespo = _customerListRespo
          .where((e) =>
              (e.name!.toUpperCase().contains(value.toUpperCase())) ||
              e.mobileNo!.toUpperCase().contains(value.toUpperCase()))
          .toList();
      print("List : ${_searchListRespo.length}  ${_customerListRespo.length}");
      notifyListeners();
    } catch (exp) {
      print('Search exp: $exp');
    }
  }
}
