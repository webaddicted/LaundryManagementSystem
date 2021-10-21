import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laundry/data/bean/countries_bean.dart';
import 'package:laundry/utils/common/utilities.dart';
import 'package:laundry/utils/common/validation_helper.dart';
import 'package:laundry/utils/common/widget_helper.dart';
import 'package:laundry/utils/constant/assets_const.dart';
import 'package:laundry/utils/constant/color_const.dart';
import 'package:laundry/view/otp_verify_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController mobileNoCont = TextEditingController();
  TextEditingController otpCont = TextEditingController();
  late BuildContext _ctx;
  late List<CountryBean> _countryBean;

  var _countryCode = '🇮🇳 (+91) ';

  String _dialCode = '+91';

  @override
  void initState() {
    super.initState();
    _loadCountriesJson();
  }

  @override
  Widget build(BuildContext context) {
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
                // Align(
                //   alignment: Alignment.bottomLeft,
                //   child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          SystemNavigator.pop();
                        }),
                    // IconButton(
                    //     icon: Icon(Icons.language),
                    //     onPressed: () {
                    //       optionLang(_ctx);
                    //     }),
                  ],
                ),
                // ),
                getTxtGreyColor(
                    msg: 'Create Account',
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 20),
                SizedBox(
                    height: 185,
                    width: 130,
                    child: Image.asset(
                      AssetsConst.MOBILE_IMG,
                      color: ColorConst.APP_COLOR,
                    )),
                const SizedBox(height: 20),
                getTxtBlackColor(
                    msg: 'Enter your mobile number \nto create account',
                    textAlign: TextAlign.center,
                    fontSize: 20),
                const SizedBox(height: 10),
                getTxtGreyColor(
                    msg: 'We will send you one time \npassword (OTP)',
                    textAlign: TextAlign.center,
                    fontSize: 17),
                const SizedBox(height: 30),
                Form(
                  key: formKey,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3.0,
                            offset: Offset(1.0, 1.0))
                      ],
                    ),
                    child: TextFormField(
                      controller: mobileNoCont,
                      textInputAction: TextInputAction.next,
                      // maxLines: 1,
                      // maxLength: 10,
                      keyboardType: TextInputType.number,
                      validator: ValidationHelper.validateMobile,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        // fillColor: Colors.transparent,
                        hintText: 'Phone Number',
                        contentPadding: const EdgeInsets.only(top: 15),
                        prefixIcon: InkWell(
                            onTap: () => showDialog(
                                context: context,
                                builder: (_) => _CountryCodeDialog(
                                      countries: _countryBean,
                                      onCellTap: countryCodeTap,
                                    )),
                            child: SizedBox(
                              width: 100,
                              child: Center(
                                child: getTxtBlackColor(
                                    msg: _countryCode, fontSize: 17),
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _loginBtn(width: 180),
                const SizedBox(height: 30),
                // Center(
                //     child: getTxtGreyColor(
                //         msg: 'Dont have an account', fontSize: 16)),
                // SizedBox(height: 5),
                // GestureDetector(
                //     onTap: () {}, //navigationPush(context, FcmSignup()),
                //     child: getTxtColor(
                //         msg: 'SIGN UP',
                //         txtColor: ColorConst.APP_COLOR,
                //         fontSize: 16,
                //         fontWeight: FontWeight.bold)),
                // SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginBtn({double width = 0}) {
    return ButtonTheme(
      minWidth: width == 0 ? double.infinity : width,
      height: 45,
      child: RaisedButton(
          shape: const StadiumBorder(),
          color: ColorConst.APP_COLOR,
          child: getTxtWhiteColor(
              msg: 'Login', fontSize: 15, fontWeight: FontWeight.bold),
          onPressed: () => _submitLogin()),
    );
  }

  optionLang(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
            title: getTxtBlackColor(
                msg: 'Select Language', fontWeight: FontWeight.bold),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            GestureDetector(
                onTap: () {
                  // Multilanguage.setLanguage(path: Languages.en, context: context);
                  // setState(() {
                  // });
                  Navigator.of(_ctx).pop();
                },
                child: Container(
                    padding: const EdgeInsets.all(15),
                    child: getTxtBlackColor(msg: 'English'))),
            GestureDetector(
                onTap: () {
                  // Multilanguage.setLanguage(path: Languages.es, context: context);
                  // setState(() {
                  // });
                  Navigator.of(_ctx).pop();
                },
                child: Container(
                    padding: const EdgeInsets.all(15),
                    child: getTxtBlackColor(msg: 'Hindi'))),
              ],
            )));
  }

  _submitLogin() {
//    navigationPush(context, FcmOtpVerify());
    final form = formKey.currentState;
    if (formKey.currentState!.validate()) {
      form!.save();
      setState(() {
//        isLoading = true;
      });
      navigationPush(_ctx, OtpVerifyPage('$_dialCode${mobileNoCont.text}'));
    }
  }

  Future<List<CountryBean>> _loadCountriesJson() async {
    _countryBean = [];
    var value = await DefaultAssetBundle.of(context)
        .loadString(AssetsConst.COUNTRY_PHONE_CODES_JSON);
    var countriesJson = json.decode(value);
    for (var country in countriesJson) {
      _countryBean.add(CountryBean.fromJson(country));
    }
    print("object" + _countryBean.toString());
    setState(() {});
    return _countryBean;
  }

  countryCodeTap(CountryBean p1) {
    print("code   :${p1.flag}  $p1");
    _dialCode = p1.dialCode;
    _countryCode = '${p1.flag} (${p1.dialCode}) ';
    setState(() {});
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('_ctx', _ctx));
    properties.add(DiagnosticsProperty<BuildContext>('_ctx', _ctx));
  }
}

class _CountryCodeDialog extends StatefulWidget {
  late List<CountryBean> countries;
  late Function(CountryBean) onCellTap;

  _CountryCodeDialog({required this.countries, required this.onCellTap});

  @override
  _CountryCodeDialogState createState() => _CountryCodeDialogState();
}

class _CountryCodeDialogState extends State<_CountryCodeDialog> {
  late List<CountryBean> _countries;
  late TextEditingController _controller;
  late Size _size;

  @override
  void initState() {
    _countries = widget.countries;
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      contentPadding: EdgeInsets.zero,
      title: Theme(
        child: TextField(
          controller: _controller,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
            fillColor: Colors.transparent,
            hintText: 'Search',
            prefixIcon: Icon(Icons.search),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            filled: true,
            prefixStyle: TextStyle(color: Colors.black, fontSize: 35),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black87),
            ),
          ),
          onChanged: (str) {
            _countries = widget.countries
                .where((e) =>
                    (e.name.toUpperCase().contains(str.toUpperCase())) ||
                    e.dialCode.toUpperCase().contains(str.toUpperCase()))
                .toList();
            setState(() {});
          },
        ),
        data: Theme.of(context).copyWith(
          primaryColor: Colors.black87,
        ),
      ),
      children: <Widget>[
        SizedBox(
          height: _size.height - 10,
          width: _size.width - 20,
          child: ListView.separated(
            padding: const EdgeInsets.all(15),
            separatorBuilder: (_, __) => const Divider(height: 25),
            itemCount: _countries.length,
            itemBuilder: (_, index) {
              final d = _countries[index];
              return _CountryCell(
                data: d,
                onTap: widget.onCellTap,
              );
            },
          ),
        )
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Size>('_size', _size));
  }
}

class _CountryCell extends StatelessWidget {
  final CountryBean data;
  final Function(CountryBean) onTap;

  _CountryCell({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ValueKey(data.name),
      onTap: () {
        onTap(data);
        Navigator.of(context).pop();
      },
      child: Row(
        children: <Widget>[
          getTxtBlackColor(msg: data.flag, fontSize: 22),
          const SizedBox(width: 10),
          getTxtBlackColor(msg: ' (${data.dialCode}) ', fontSize: 16),
          Expanded(
              child: getTxtBlackColor(
                  msg: data.name, fontSize: 16, maxLines: 1)),
        ],
      ),
    );
  }
}
