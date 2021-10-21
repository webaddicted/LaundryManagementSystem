import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundry/data/bean/add_customer_bean.dart';
import 'package:laundry/data/bean/add_report_bean.dart';
import 'package:laundry/data/repo/add_record_provider.dart';
import 'package:laundry/utils/common/str_const.dart';
import 'package:laundry/utils/common/utilities.dart';
import 'package:laundry/utils/common/validation_helper.dart';
import 'package:laundry/utils/common/widget_helper.dart';
import 'package:laundry/utils/constant/api_const.dart';
import 'package:laundry/utils/constant/color_const.dart';
import 'package:share/share.dart';

class FilterPage extends StatefulWidget {
  AddCustomerBean customerInfo;
  var mobileNo = '';

  AddRecordProvider recordProvider;
  AddReportBean? reportBean;

  FilterPage(this.customerInfo, this.mobileNo, this.recordProvider,
      {this.reportBean});

  @override
  _FilterPageState createState() => _FilterPageState(customerInfo);
}

class _FilterPageState extends State<FilterPage> {
  late BuildContext _ctx;
  var formKey = GlobalKey<FormState>();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController rateCont = TextEditingController();
  late AddCustomerBean customerInfo;
  int totalQty = 0;
  int rate = 0;
  int totalPrice = 0;

  late DateTime startDateTime = DateTime.now();
  late DateTime endDateTime = DateTime.now();
  late List<AddReportBean> searchAmountBean =[];

  _FilterPageState(this.customerInfo);

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    rateCont = TextEditingController(text: '0');
  }

  @override
  Widget build(BuildContext context) {
    var iconShare =
        IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              var startDate=DateFormat('dd/MMMM/yyyy').format(startDateTime);
              var endDate=DateFormat('dd/MMMM/yyyy').format(endDateTime);

              Share.share(' *Payment*\nFrom - $startDate \nTo - $endDate \n\nTotal quantity : $totalQty \nRate : ${rateCont.text} \n*Total Prices : ₹ $totalPrice*',);
              // navigationPush(
              //     context, FilterPage(customerDetails, mobileNo, recordProvider));
            });
    return Scaffold(
        appBar: getAppBarWithBackBtn(
            title: StrConst.TOTAL_AMOUNT,
            actions: searchAmountBean.isNotEmpty?[iconShare]:[]),
        body: Builder(
          builder: (context) => _crateUi(context),
        ));
  }

  Widget _crateUi(BuildContext context) {
    _ctx = context;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  edtDateField(startDate, _dateClick,
                      hintTxt: "Select Start Date"),
                  const SizedBox(height: 10),
                  edtDateField(endDate, _endDateClick,
                      hintTxt: "Select End Date"),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          raisedRoundAppColorBtn("Search", _submit),
          const SizedBox(height: 30),
          addRecord(
            'Total Amount : ',
            "₹ " + totalPrice.toString(),
            textSize: 22,
            color: ColorConst.APP_COLOR,
          ),
          const SizedBox(height: 5),
          addRecord('Total Quantity : ', totalQty.toString()),
          // SizedBox(height: 10),
          Row(
            children: [
              SizedBox(child: addRecord('Rate : ', '₹')),
              SizedBox(
                  width: 80,
                  height: 35,
                  child: TextFormField(
                    controller: rateCont,
                    cursorRadius: Radius.zero,
                    cursorWidth: 2,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      hintText: '0',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w300, color: Colors.grey),
                    ),
                    onChanged: _change,
                    textInputAction: TextInputAction.none,
                    maxLength: 5,
                    keyboardType: TextInputType.number,
                    validator: (rate) =>
                        ValidationHelper.empty(rate!, 'Rate is Required'),
                  ))
            ],
          ),
          const SizedBox(height: 15),
          FilterWidget(searchAmountBean),
        ],
      ),
    );
  }

  void _dateClick() async {
    showDatePicker(
            locale: const Locale('en', 'UK'),
            context: context,
            initialDate: startDateTime,
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((value) => {
              startDateTime = value!,
              startDate.text = DateFormat('dd-MMMM-yyyy').format(value)
            });
  }

  _endDateClick() {
    showDatePicker(
            locale: const Locale('en', 'UK'),
            context: context,
            initialDate:  endDateTime,
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((value) => {
              endDateTime = value!,
              endDate.text = DateFormat('dd-MMMM-yyyy').format(value)
            });
  }

  void _submit() {
    // _insert();
    final form = formKey.currentState;
    if (formKey.currentState!.validate()) {
      form!.save();
      setState(() {
        _insert();
      });
    }
  }

  void _insert() async {
    endDateTime = endDateTime.add(const Duration(hours: 23,minutes: 59));
    // print(
    //     'Date : $startDateTime    $endDateTime      ${startDateTime.isBefore(endDateTime)}            ${startDateTime == (endDateTime)}');
    if (startDateTime.isBefore(endDateTime) || startDateTime == endDateTime) {
      // DateTime now = DateTime.now();
      // DateTime date = DateTime(now.year, now.month, now.day);
      // DateTime time =  DateTime(now.hour, now.minute, now.second);
      // endDateTime = endDateTime.add(Duration(days: 1));
      showCustomDialog(ctx: context);
      CollectionReference cusRef = FirebaseFirestore.instance.collection(
          ApiConst.FIRESTORE_COLL_USERS +
              "/${widget.mobileNo}/" +
              ApiConst.FIRESTORE_CUSTOMER +
              "/${customerInfo.id}/" +
              ApiConst.FIRESTORE_REPORT);
      final QuerySnapshot data = await cusRef
          .where('dateFormat',
              isGreaterThanOrEqualTo: startDateTime,
              isLessThanOrEqualTo: endDateTime)
          .withConverter<AddReportBean>(
        fromFirestore: (snapshots, _) => AddReportBean.fromJson(snapshots.data()!),
        toFirestore: (data, _) => data.toJson(),
      ).get();
      totalQty = 0;
      rate = 0;
      totalPrice = 0;
      final List<DocumentSnapshot> docSnap = data.docs;
      searchAmountBean = [];
      for (var dataSnapshot in docSnap) {
        AddReportBean addReportBean = dataSnapshot.data() as AddReportBean;
        searchAmountBean.add(addReportBean);
        totalQty = totalQty + int.parse(addReportBean.qty!);
        rate = int.parse(addReportBean.rate!);
        rateCont.text = rate.toString();
        totalPrice = totalPrice +
            (int.parse(addReportBean.qty.toString()) * int.parse(addReportBean.rate.toString()));
      }
      Navigator.pop(context);
      if (searchAmountBean.isNotEmpty) {
        // print('data  ${searchAmountBean.length} : startDateTime : $startDateTime ${docSnap[0].data()} ' + docSnap.toString());
        setState(() {});
      }
    } else {
      showSnackBar(_ctx, 'End date should be lower then start date');
    }
  }

  okClick() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Widget addRecord(String title, String name,
      {double textSize = 0, Color? color}) {
    return Row(
      children: [
        const SizedBox(width: 10),
        if (color == null)
          getTxtBlackColor(
              msg: title,
              fontSize: textSize > 0 ? textSize : 16,
              fontWeight: FontWeight.w700),
        if (color != null)
          getTxtColor(
              msg: title,
              fontSize: textSize > 0 ? textSize : 16,
              fontWeight: FontWeight.w700,
              txtColor: color),
        getTxtGreyColor(
            msg: name,
            fontSize: textSize > 0 ? textSize - 1 : 15,
            fontWeight: FontWeight.w700),
      ],
    );
  }

  void _change(String value) {
    if (searchAmountBean.isNotEmpty &&
        value.isNotEmpty &&
        int.parse(value) > 0) {
      totalPrice = int.parse(value) * totalQty;
      setState(() {});
    }
  }
}

class FilterWidget extends StatelessWidget {
  List<AddReportBean> searchAmountBean;

  FilterWidget(this.searchAmountBean);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // scrollDirection: Axis.vertical,
            itemCount: searchAmountBean == null ? 0 : searchAmountBean.length,
            itemBuilder: (BuildContext context, int index) {
              return taskRow(context, searchAmountBean[index]);
            }),
      ],
    );
  }

  Widget taskRow(BuildContext context, AddReportBean recordBean) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    spreadRadius: 0.5,
                    offset: Offset(0, 2))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                const SizedBox(width: 3),
                Container(
                  height: 68,
                  width: 68,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.blue[300], shape: BoxShape.circle),
                  child: getTxtWhiteColor(
                      msg: '₹', fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (recordBean.comment != null &&
                          recordBean.comment!.isNotEmpty)
                        getTxtBlackColor(
                            msg: '${recordBean.comment}',
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      getTxtBlackColor(
                          msg: 'Quantity : ${recordBean.qty}', fontSize: 16),
                      getTxtBlackColor(
                          msg: 'Rate :  ₹ ${recordBean.rate}', fontSize: 16),
                      getTxtAppColor(
                          msg:
                              'Total Price :  ₹ ${(int.parse(recordBean.rate.toString()) * int.parse(recordBean.qty.toString()))}',
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          getTxtGreyColor(
                              msg: '${recordBean.date}', fontSize: 15),
                          const SizedBox(width: 8),
                          getTxtGreyColor(
                              msg: '${recordBean.time}', fontSize: 15),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
