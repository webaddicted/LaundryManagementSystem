import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laundry/data/bean/login_user_bean.dart';
import 'package:laundry/utils/common/utilities.dart';
import 'package:laundry/utils/common/validation_helper.dart';
import 'package:laundry/utils/common/widget_helper.dart';
import 'package:laundry/utils/constant/api_const.dart';
import 'package:laundry/utils/constant/assets_const.dart';
import 'package:laundry/utils/constant/color_const.dart';
import 'package:laundry/utils/sp/sp_manager.dart';
import 'package:laundry/view/home_page_screen.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OtpVerifyPage extends StatefulWidget {
  String mobileNo;

  OtpVerifyPage(this.mobileNo);

  @override
  _OtpVerifyPageState createState() => _OtpVerifyPageState(mobileNo);
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  final formKey = GlobalKey<FormState>();
  static BuildContext? _ctx;
  static final _fcmAuth = FirebaseAuth.instance;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  // static String mobileNo = '';
  static String verifId = "";

  var mobileNo ='';
  static var getmobileNo;

  static final _dbRef = FirebaseFirestore.instance;

  _OtpVerifyPageState(this.mobileNo);

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: ColorConst.APP_COLOR),
      borderRadius: BorderRadius.circular(5),
    );
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    getmobileNo = mobileNo;
    return Scaffold(
      body: Builder(builder: (_context) => _createUi(_context)),
    );
  }

  Widget _createUi(BuildContext context) {
    _ctx = context;
    return Stack(
      children: <Widget>[
        // bgDesign(),
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                getTxtGreyColor(
                    msg: 'Verify Account',
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 20),
                SizedBox(
                    height: 150, child: Image.asset(AssetsConst.OTP_IMG)),
                const SizedBox(height: 20),
                getTxtBlackColor(
                    msg: 'Verification Code',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 20),
                getTxtGreyColor(
                    textAlign: TextAlign.center,
                    msg:
                        'OTP has been sent to your mobile\nnumber please verify',
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
                Form(
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 40, bottom: 30),
                    child: PinPut(
                      fieldsCount: 6,
                      validator: ValidationHelper.validateOtp,
                      onSubmit: (String pin) => showSnackBar(_ctx, pin),
                      focusNode: _pinPutFocusNode,
                      controller: _pinPutController,
                      submittedFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(5)),
                      selectedFieldDecoration: _pinPutDecoration,
                      followingFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: ColorConst.APP_COLOR,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () {checkUser();}, // navigationPush(context, FcmSignup()),
                    child: getTxtColor(
                        msg: 'Resend OTP',
                        txtColor: ColorConst.APP_COLOR,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                _verifyBtn(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _verifyBtn() {
    return ButtonTheme(
      minWidth: double.infinity,
      height: 45,
      child: RaisedButton(
          shape: const StadiumBorder(),
          color: ColorConst.APP_COLOR,
          child: getTxtWhiteColor(
              msg: 'Verify', fontSize: 15, fontWeight: FontWeight.bold),
          onPressed: () => _submitVerify()),
    );
  }

  _submitVerify() {
//    final form = formKey.currentState;
//    if (formKey.currentState.validate()) {
//      form.save();
//      setState(() {
//      });
//    }
    if (_pinPutController.text.length == 6)
      _signInWithPhoneNumber();
    else
      showSnackBar(_ctx, 'Please enter all OTP code');
  }

  void _signInWithPhoneNumber() async {
    var _authCredential = PhoneAuthProvider.credential(
        verificationId: verifId, smsCode: _pinPutController.text);
    _fcmAuth.signInWithCredential(_authCredential).then((value) async {
      navigationPush(_ctx!, HomePageScreen(mobileNo));
//      showSnackBar(_ctx, 'Success   :  ' + value.toString());
    }).catchError((error) {
      showSnackBar(_ctx, 'Something has gone wrong, please try later $error');
    });
  }

  void checkUser() {
    _fcmAuth
        .verifyPhoneNumber(
            phoneNumber: mobileNo,
            timeout: const Duration(seconds: 60),
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
        .then((value) {
      print('Code sent');
    }).catchError((error) {
      print(error.toString());
    });
  }

  PhoneCodeSent codeSent = (String verificationId, [int? forceResendingToken]) async {
    verifId = verificationId;
    showSnackBar(_ctx, 'OTP sent successfully');
    print("\nEnter the code sent to ");
  };

  final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
    verifId = verificationId;
    showSnackBar(_ctx, "Auto retrieval time out");
  };

  final PhoneVerificationFailed verificationFailed =
      (FirebaseAuthException authException) {
    print('${authException.message}');
    if (authException.message!.contains('not authorized')) {
      showSnackBar(_ctx, 'App not authroized');
    } else if (authException.message!.contains('Network'))
      showSnackBar(_ctx, 'Please check your internet connection and try again');
    else
      showSnackBar(
          _ctx,
          'Something has gone wrong, please try later ${authException.message}');
  };

  PhoneVerificationCompleted verificationCompleted = (AuthCredential auth) async {
    _fcmAuth.signInWithCredential(auth).then((value) async {
      if (value.user != null) {
        _insert();
        print('Authentication successful');
      } else {
        showSnackBar(_ctx, 'Invalid code/invalid authentication');
      }
    }).catchError((error) {
      print('Something has gone wrong, please try later $error');
    });
  };

  static _insert() async {
    var loginBean = LoginUserBean('', '', getmobileNo, '', '', "");
    final snapShot = await _dbRef
        .collection(ApiConst.FIRESTORE_COLL_USERS)
        .doc(loginBean.mobileNo)
        .get();
    if (snapShot.exists) {
      SPManager.setMobileNo(getmobileNo);
    navigationPush(_ctx!, HomePageScreen(getmobileNo));
      showSnackBar(_ctx, 'User already exist with this mobile number');
    } else {
      await _dbRef
          .collection(ApiConst.FIRESTORE_COLL_USERS)
          .doc(loginBean.mobileNo)
          .set(loginBean.toJson())
          .then((result) => {
                SPManager.setMobileNo(getmobileNo),
                navigationPush(_ctx!, HomePageScreen(getmobileNo)),
                showSnackBar(_ctx, 'Successfully Signup')
              })
          .catchError((err) {
        showSnackBar(_ctx, err);
        print(err);
      });
    }
  }
}
