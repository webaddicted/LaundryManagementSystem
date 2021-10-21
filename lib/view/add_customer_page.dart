import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundry/data/bean/add_customer_bean.dart';
import 'package:laundry/data/repo/add_customer_provider.dart';
import 'package:laundry/utils/common/dialog_utility.dart';
import 'package:laundry/utils/common/str_const.dart';
import 'package:laundry/utils/common/utilities.dart';
import 'package:laundry/utils/common/widget_helper.dart';
import 'package:laundry/utils/constant/api_const.dart';
import 'package:laundry/utils/widget/stepper_widget.dart';

class AddCustomerPage extends StatefulWidget {
  var mobileNo;

  AddCustomerProvider provider;

  AddCustomerBean? customerBean;

  AddCustomerPage(this.provider, this.mobileNo, { this.customerBean});

  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  late BuildContext _ctx;
  bool isLoading = false;
  var formKey = GlobalKey<FormState>();
  TextEditingController fullNameCont = TextEditingController();
  TextEditingController mobileNoCont = TextEditingController();
  TextEditingController rateCont = TextEditingController();
  int _quantity = 1;
  var steppController = TextEditingController();
  // var mobileNo;
  //
  // _AddCustomerPageState(this.mobileNo);

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    fullNameCont = TextEditingController(
        text: widget.customerBean == null ? '' : widget.customerBean?.name);
    mobileNoCont = TextEditingController(
        text: widget.customerBean == null ? '' : widget.customerBean?.mobileNo);
    rateCont = TextEditingController(
        text: widget.customerBean == null ? '' : widget.customerBean?.rate);
    _quantity =
        widget.customerBean == null ? 1 : int.parse(widget.customerBean!.qty.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBarWithBackBtn(
            title: widget.customerBean == null
                ? StrConst.ADD_CUSTOMER
                : StrConst.UPDATE_CUSTOMER),
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
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  edtNameField(fullNameCont),
                  const SizedBox(height: 10),
                  edtMobileNoField(mobileNoCont),
                  const SizedBox(height: 10),
                  // edtDateField(dateCont, _dateClick),
                  // SizedBox(height: 10),
                  // edtTimeField(timeCont, _timeClick),
                  // SizedBox(height: 10),
                  edtRateField(rateCont),
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
                }, label: 'Add', controller: steppController,

              )),
          const SizedBox(height: 30),
          raisedRoundAppColorBtn(
              widget.customerBean == null
                  ? StrConst.ADD_CUSTOMER
                  : StrConst.UPDATE_CUSTOMER,
              _submit),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void _submit() {
    final form = formKey.currentState;
    if (formKey.currentState!.validate()) {
      form!.save();
      setState(() {
        isLoading = true;
        _insert();
      });
    }else{
      showSnackBar(_ctx, "Error");
    }
  }

  void _insert() async {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    DateTime time = DateTime(now.hour, now.minute, now.second);
    showCustomDialog(ctx: context);
    var customerBean = AddCustomerBean(
        fullNameCont.text,
        mobileNoCont.text,
        DateFormat('dd-MMMM-yyyy').format(date),
        DateFormat('hh-MM-ss').format(time),
        rateCont.text,
        _quantity.toString(),
        now.toString(),
        widget.customerBean == null ? now.toString() : widget.customerBean?.id);
    CollectionReference customerInfo = FirebaseFirestore.instance.collection(
        ApiConst.FIRESTORE_COLL_USERS +
            "/${widget.mobileNo}/" +
            ApiConst.FIRESTORE_CUSTOMER);
    final QuerySnapshot data = await customerInfo
        .where("mobileNo", isEqualTo: customerBean.mobileNo)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = data.docs;
    if (documents.isNotEmpty) {
      if ((widget.customerBean == null &&
          documents[0]["mobileNo"] == customerBean.mobileNo) ||
          (widget.customerBean?.id != documents[0]["id"])) {
        showSnackBar(_ctx, "Customer mobile no already added");
        return;
      }
    }
    await customerInfo
        .doc(customerBean.id)
        .set(customerBean.toJson())
        .then((result) => {
              widget.provider.customerData(widget.mobileNo),
              Navigator.pop(context),
              showSingleClickDialog(
                  ctx: context,
                  title: 'Congratulations',
                  msg: 'Customer information successfully added',
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
}
