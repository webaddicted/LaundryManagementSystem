import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundry/data/bean/add_customer_bean.dart';
import 'package:laundry/data/bean/add_report_bean.dart';
import 'package:laundry/data/repo/add_record_provider.dart';
import 'package:laundry/utils/common/dialog_utility.dart';
import 'package:laundry/utils/common/str_const.dart';
import 'package:laundry/utils/common/utilities.dart';
import 'package:laundry/utils/common/widget_helper.dart';
import 'package:laundry/utils/constant/api_const.dart';
import 'package:laundry/utils/constant/color_const.dart';
import 'package:laundry/utils/widget/stepper_widget.dart';

class AddRecordPage extends StatefulWidget {
  AddCustomerBean customerInfo;
  var mobileNo = '';
  AddRecordProvider recordProvider;

  var isUpdate;
  AddReportBean? reportBean;

  AddRecordPage(this.customerInfo, this.mobileNo, this.recordProvider,
      {this.reportBean});

  @override
  _AddRecordPageState createState() => _AddRecordPageState(customerInfo);
}

class _AddRecordPageState extends State<AddRecordPage> {
  late BuildContext _ctx;
  bool isLoading = false;
  var formKey = GlobalKey<FormState>();
  late TextEditingController dateCont;
  late TextEditingController timeCont;
  TextEditingController commentCont =
      TextEditingController(text: 'Product Price');
  int _quantity = 1;
  late AddCustomerBean customerInfo;
  late DateTime dateFormate;
  var steppController = TextEditingController();

  _AddRecordPageState(this.customerInfo);

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    var date = DateTime.now();
    dateFormate = date;
    dateCont = TextEditingController(
        text: widget.reportBean == null
            ? DateFormat('dd-MMMM-yyyy').format(date)
            : widget.reportBean?.date);
    timeCont = TextEditingController(
        text: widget.reportBean == null
            ? DateFormat('hh:mm a').format(DateTime.now())
            : widget.reportBean?.time);
    commentCont = TextEditingController(
        text: widget.reportBean == null
            ? 'Product Price'
            : widget.reportBean?.comment);
    _quantity = widget.reportBean == null
        ? (int.parse(customerInfo.qty.toString()))
        : int.parse(widget.reportBean?.qty.toString() ?? "0");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBarWithBackBtn(
          bgColor: ColorConst.APP_COLOR,
            title: widget.reportBean == null
                ? StrConst.ADD_RECORD
                : StrConst.UPDATE_RECORDs),
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
                  addRecord('Name : ', customerInfo.name),
                  const SizedBox(height: 5),
                  addRecord('Contact no : ', customerInfo.mobileNo),
                  const SizedBox(height: 5),
                  addRecord('Rate : ', '₹ ${customerInfo.rate}'),
                  const SizedBox(height: 20),
                  edtDateField(dateCont, _dateClick),
                  const SizedBox(height: 10),
                  edtTimeField(timeCont, _timeClick),
                  const SizedBox(height: 10),
                  edtCommentField(commentCont),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: StepperWidget(
                count: _quantity,
                onChange: (int quantity) {
                  _quantity = quantity;
                },
                label: 'Test',
                controller: steppController,
              )),
          const SizedBox(height: 30),
          raisedRoundAppColorBtn(
              widget.reportBean == null ? 'Add Record' : "Update Record",
              _submit),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void _dateClick() async {
    showDatePicker(
            locale: const Locale('en', 'UK'),
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((value) => {
              dateFormate = value!,
              dateCont.text = DateFormat('dd-MMMM-yyyy').format(value)
            });
  }

  void _timeClick() async {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) => timeCont.text = value!.format(context));
  }

  void _submit() {
    print("vvvvvvvvvvvvv");
    final form = formKey.currentState;
    if (formKey.currentState!.validate()) {
      form!.save();
      setState(() {
        isLoading = true;
        _insert();
      });
    }else print("errrrrrrrrrr");
  }

  void _insert() async {
    DateTime now = DateTime.now();
    // DateTime date = DateTime(now.year, now.month, now.day);
    // DateTime time = DateTime(now.hour, now.minute, now.second);
    showCustomDialog(ctx: context);
    var reportBean = AddReportBean(
        widget.reportBean == null ? now : widget.reportBean?.dateTime,
        dateCont.text,
        timeCont.text,
        customerInfo.rate,
        _quantity.toString(),
        commentCont.text,
        widget.reportBean == null ? now.toString() : widget.reportBean?.id,
        dateFormate);
    CollectionReference customerIn = FirebaseFirestore.instance.collection(
        ApiConst.FIRESTORE_COLL_USERS +
            "/${widget.mobileNo}/" +
            ApiConst.FIRESTORE_CUSTOMER +
            "/${customerInfo.id}/" +
            ApiConst.FIRESTORE_REPORT);
    await customerIn
        .doc(reportBean.id)
        .set(reportBean.toJson())
        .then((result) => {
              widget.recordProvider
                  .fetchReports(widget.mobileNo, customerInfo.id!),
              Navigator.pop(context),
              showSingleClickDialog(
                  ctx: context,
                  title: 'Congratulations',
                  msg: 'Successfully added',
                  okClick: okClick),
            })
        .catchError((err) {
      Navigator.pop(context);
      showSnackBar(_ctx, err);
      print(err);
    });
  }

  okClick() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Widget addRecord(String title, String? name) {
    return Row(
      children: [
        const SizedBox(width: 10),
        getTxtBlackColor(
            msg: title, fontSize: 16, fontWeight: FontWeight.w700),
        getTxtGreyColor(
            msg: name!, fontSize: 15, fontWeight: FontWeight.w700),
      ],
    );
  }
}
