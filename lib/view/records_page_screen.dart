import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laundry/data/bean/add_customer_bean.dart';
import 'package:laundry/data/bean/add_report_bean.dart';
import 'package:laundry/data/repo/add_record_provider.dart';
import 'package:laundry/utils/common/dialog_utility.dart';
import 'package:laundry/utils/common/utilities.dart';
import 'package:laundry/utils/common/widget_helper.dart';
import 'package:laundry/utils/constant/api_const.dart';
import 'package:laundry/view/add_record_page.dart';
import 'package:laundry/view/filter_page.dart';
import 'package:laundry/view/records_item_widget.dart';
import 'package:provider/provider.dart';

class RecordsPageScreen extends StatefulWidget {
  AddCustomerBean customerDetails;
  var mobileNo;

  RecordsPageScreen(this.customerDetails, this.mobileNo);

  @override
  _RecordsPageScreenState createState() =>
      _RecordsPageScreenState(customerDetails, this.mobileNo);
}

class _RecordsPageScreenState extends State<RecordsPageScreen> {
  List<AddReportBean> reportList = [];
late  AddCustomerBean customerDetails;

  late AddRecordProvider recordProvider;
  var mobileNo = '';

  _RecordsPageScreenState(this.customerDetails, this.mobileNo);

  @override
  void initState() {
    super.initState();
    recordProvider = AddRecordProvider();
    recordProvider.fetchReports(widget.mobileNo, customerDetails.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBarWithBackBtn(
          title:   '${customerDetails.name} order',
          actions: [getFilterAction(context)]),
      floatingActionButton: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => navigationPush(
                  context,
                  AddRecordPage(
                      customerDetails, widget.mobileNo, recordProvider)))),
      body: ChangeNotifierProvider<AddRecordProvider>(
        create: (BuildContext context) => recordProvider,
        child: RecordsWidget(widget.mobileNo, customerDetails.id,
            customerDetails: customerDetails, recordProvider: recordProvider),
      ), // _createUi(context),
    );
  }

  IconButton getFilterAction(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.filter_alt_sharp),
        onPressed: () {
          navigationPush(
              context, FilterPage(customerDetails, mobileNo, recordProvider));
        });
  }
}

class RecordsWidget extends StatelessWidget {
  var mobileNo;

  var custId;
  var customerDetails;
  var recordProvider;

  late BuildContext _ctx;

  RecordsWidget(this.mobileNo, this.custId,
      {this.customerDetails, this.recordProvider});

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var appState = Provider.of<AddRecordProvider>(context);
    return RefreshIndicator(
        onRefresh: () => appState.fetchReports(mobileNo, custId),
        child: RecordsItemWidget(
          dataBean: appState.getReports,
          onTap: (recordBean) {
            navigationPush(
                context,
                AddRecordPage(customerDetails, mobileNo, recordProvider,
                    reportBean: recordBean));
          },
          onLongPress: (recordBean) {
            optionMenu(_ctx, recordBean);
          },
        ));
  }

  optionMenu(BuildContext context, AddReportBean reportBean) {
    showDialog(
        context: context,
        builder:(_) =>  AlertDialog(
            title: getTxtBlackColor(
                msg: 'Select Option', fontWeight: FontWeight.bold),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.of(_ctx).pop();
                  deleteRecord(reportBean);
                },
                child: Container(
                    padding: const EdgeInsets.all(15),
                    child: getTxtBlackColor(msg: 'Delete Record'))),
              ],
            )));
  }

  void deleteRecord(AddReportBean reportBean) async {
    showCustomDialog(ctx: _ctx);
    CollectionReference customerInfo = FirebaseFirestore.instance.collection(
        ApiConst.FIRESTORE_COLL_USERS +
            "/$mobileNo/" +
            ApiConst.FIRESTORE_CUSTOMER +
            "/${customerDetails.id}/" +
            ApiConst.FIRESTORE_REPORT);
    await customerInfo
        .doc(reportBean.id)
        .delete()
        .then((value) async => {
              recordProvider.fetchReports(mobileNo, customerDetails.id),
              Navigator.pop(_ctx),
              showSingleClickDialog(
                  ctx: _ctx,
                  title: 'Congratulations',
                  msg: 'Record successfully deleted',
                  okClick: okClick)
            })
        .catchError((err) {
      Navigator.pop(_ctx);
      showSnackBar(_ctx, err);
      print(err);
    });
  }

  okClick() {
    Navigator.of(_ctx).pop();
  }
}
