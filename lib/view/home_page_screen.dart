import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:laundry/data/bean/add_customer_bean.dart';
import 'package:laundry/data/repo/add_customer_provider.dart';
import 'package:laundry/utils/common/dialog_utility.dart';
import 'package:laundry/utils/common/str_const.dart';
import 'package:laundry/utils/common/utilities.dart';
import 'package:laundry/utils/common/widget_helper.dart';
import 'package:laundry/utils/constant/api_const.dart';
import 'package:laundry/utils/constant/color_const.dart';
import 'package:laundry/view/add_customer_page.dart';
import 'package:laundry/view/home_item_widget.dart';
import 'package:laundry/view/nav_drawer.dart';
import 'package:laundry/view/records_page_screen.dart';
import 'package:provider/provider.dart';

class HomePageScreen extends StatefulWidget {
  String mobileNo = '';

  HomePageScreen(this.mobileNo);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<AddCustomerBean> custBean = [];
  late String mobileNo;
  late AddCustomerProvider movieData;

  late SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _HomePageScreenState() {
    searchBar = SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onChanged: onChange,
        onCleared: () {
          movieData.onDataChange("");
          // print("cleared");
        },
        onClosed: () {
          movieData.onDataChange("");
          // print("closed");
        });
  }

  @override
  void initState() {
    super.initState();
    mobileNo = widget.mobileNo;
    movieData = AddCustomerProvider();
    // print("mobile : $mobileNo  + ${widget.mobileNo}");
    movieData.customerData(mobileNo);
  }

  @override
  Widget build(BuildContext context) {
    onChange("");
    return
      // WillPopScope(
      // onWillPop: () => onWillPop(context),
      // child:
      Scaffold(
        appBar: searchBar.build(context),
        key: _scaffoldKey,
        drawer: NavDrawer(movieData, mobileNo),
        floatingActionButton: SizedBox(
            height: 60,
            width: 60,
            child: FloatingActionButton(
                child: const Icon(Icons.person_add),
                onPressed: () => navigationPush(
                    context, AddCustomerPage(movieData, mobileNo)))),
        // navigationPush(context, AddCustomerPage(movieData,mobileNo)))),
        body: ChangeNotifierProvider<AddCustomerProvider>(
          create: (BuildContext context) => movieData,
          child: HomeListScreen(movieData, mobileNo),
        ),
      // ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        title: const Text(StrConst.APP_NAME),
        backgroundColor: ColorConst.APP_COLOR,
        actions: [searchBar.getSearchAction(context)]);
  }

  void onChange(String value) {
    movieData.onDataChange(value);
  }
}

class HomeListScreen extends StatefulWidget {
  var mobileNo = '';
  var movieData;

  HomeListScreen(this.movieData, this.mobileNo);

  @override
  _HomeListScreenState createState() => _HomeListScreenState();
}

class _HomeListScreenState extends State<HomeListScreen> {
  late AddCustomerProvider appState;
  late List<AddCustomerBean> custlist;
  late BuildContext _ctx;

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AddCustomerProvider>(context);
    custlist = appState.getSearchCust;
    _ctx = context;
    return RefreshIndicator(
        onRefresh: () => appState.customerData(widget.mobileNo),
        child: HomeItemWidget(
          dataBean: appState.getSearchCust,
          onTap: (customerInfo) {
            navigationPush(
                context, RecordsPageScreen(customerInfo, widget.mobileNo));
          },
          longPress: (customerInfo) {
            optionMenu(context, customerInfo);
          },
        ));
  }

  optionMenu(BuildContext context, AddCustomerBean customerInfo) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
                    navigationPush(
                        context,
                        AddCustomerPage(widget.movieData, widget.mobileNo,
                            customerBean: customerInfo));
                  },
                  child: Container(
                      padding: const EdgeInsets.all(15),
                      child: getTxtBlackColor(msg: 'Edit Customer details')),
                ),
                const Divider(
                  color: Colors.grey,
                  height: 1,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(_ctx).pop();
                      deleteCustomer(customerInfo);
                    },
                    child: Container(
                        padding: const EdgeInsets.all(15),
                        child: getTxtBlackColor(msg: 'Delete Customer'))),
              ],
            )));
  }

  void deleteCustomer(AddCustomerBean customerdetails) async {
    showCustomDialog(ctx: context);
    CollectionReference customerInfo = FirebaseFirestore.instance.collection(
        ApiConst.FIRESTORE_COLL_USERS +
            "/${widget.mobileNo}/" +
            ApiConst.FIRESTORE_CUSTOMER);
    await customerInfo
        .doc(customerdetails.id)
        .delete()
        .then((value) async => {
              widget.movieData.customerData(widget.mobileNo),
              Navigator.pop(context),
              showSingleClickDialog(
                  ctx: context,
                  title: 'Congratulations',
                  msg: 'Customer successfully deleted',
                  okClick: okClick)
            })
        .catchError((err) {
      Navigator.pop(context);
      showSnackBar(_ctx, err);
      print(err);
    });
  }

  okClick() {
    Navigator.pop(context);
  }
}
