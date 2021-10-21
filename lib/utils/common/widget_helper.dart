import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laundry/utils/common/utilities.dart';
import 'package:laundry/utils/common/validation_helper.dart';
import 'package:laundry/utils/constant/assets_const.dart';
import 'package:laundry/utils/constant/color_const.dart';
import 'package:laundry/utils/sp/sp_manager.dart';
import 'package:laundry/view/login_page.dart';

//  {START TEXT VIEW}
Text getTxt(
    {required String msg,
    FontWeight fontWeight = FontWeight.normal,
    int? maxLines,
    TextAlign textAlign = TextAlign.start}) {
  return Text(msg,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(fontWeight: fontWeight));
}

Text getTxtAppColor(
    {required String msg,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.normal,
    int? maxLines,
    TextAlign textAlign = TextAlign.start}) {
  return Text(
    msg,
    maxLines: maxLines,
    textAlign: textAlign,
    style: _getFontStyle(
        txtColor: ColorConst.APP_COLOR,
        fontSize: fontSize,
        fontWeight: fontWeight),
  );
}

Text getTxtWhiteColor(
    {required String msg,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.normal,
    int? maxLines,
    TextAlign textAlign = TextAlign.start}) {
  return Text(
    msg,
    maxLines: maxLines,
    textAlign: textAlign,
    style: _getFontStyle(
        txtColor: ColorConst.WHITE_COLOR,
        fontSize: fontSize,
        fontWeight: fontWeight),
  );
}

Text getTxtBlackColor(
    {required String msg,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.normal,
    int? maxLines,
    TextAlign textAlign = TextAlign.start}) {
  return Text(
    msg,
    textAlign: textAlign,
    maxLines: maxLines,
    style: _getFontStyle(
        txtColor: ColorConst.BLACK_COLOR,
        fontSize: fontSize,
        fontWeight: fontWeight),
  );
}

Text getTxtGreyColor(
    {required String msg,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.normal,
    int? maxLines,
    TextAlign textAlign = TextAlign.start}) {
  return Text(
    msg,
    textAlign: textAlign,
    maxLines: maxLines,
    style: _getFontStyle(
        txtColor: ColorConst.GREY_COLOR,
        fontSize: fontSize,
        fontWeight: fontWeight),
  );
}

Text getTxtColor(
    {required String msg,
    required Color txtColor,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.normal,
    int? maxLines,
    TextAlign textAlign = TextAlign.start}) {
  return Text(
    msg,
    textAlign: textAlign,
    maxLines: maxLines,
    style: _getFontStyle(
        txtColor: txtColor, fontSize: fontSize, fontWeight: fontWeight),
  );
}

TextStyle _getFontStyle(
    {required Color txtColor,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.normal,
    String fontFamily = AssetsConst.ZILLASLAB_FONT,
    TextDecoration txtDecoration = TextDecoration.none}) {
  return TextStyle(
      color: txtColor,
      fontSize: fontSize,
      decoration: txtDecoration,
      fontFamily: fontFamily,
      fontWeight: fontWeight);
}

//  {END TEXT VIEW}

Widget edtPwdField(
    {required TextEditingController control,
    bool pwdVisible = false,
    bool isRect = true,
    IconData icons = Icons.lock_outline,
    Function? pwdVisibleClick}) {
  return TextFormField(
    controller: control,
    decoration: InputDecoration(
      counterText: '',
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      border: OutlineInputBorder(
          borderRadius:
              isRect ? BorderRadius.circular(0) : BorderRadius.circular(30)),
      hintText: "Password",
      prefixIcon: Icon(icons),
      suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            pwdVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () => pwdVisibleClick),
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w300,
        color: Colors.grey,
      ),
    ),
    obscureText: !pwdVisible,
    textInputAction: TextInputAction.done,
    maxLength: 32,
    // validator: ValidationHelper.validateNormalPass,
  );
}

Widget edtDobField(
    {required TextEditingController control,
    bool isRect = true,
    validate,
    IconData? icons,
    Color iconColor = Colors.grey,
    String title = '',
    Function? click}) {
  return TextFormField(
    onTap: () => click,
    validator: validate,
    decoration: InputDecoration(
      counterText: '',
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      border: OutlineInputBorder(
          borderRadius:
              isRect ? BorderRadius.circular(0) : BorderRadius.circular(30)),
      hintText: title,
      prefixIcon: Icon(
        icons,
        color: iconColor,
      ),
      hintStyle:
          const TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),
    ),
    textInputAction: TextInputAction.next,
    maxLength: 32,
    readOnly: true,
    controller: control,
    // validator: (dob) => ValidationHelper.empty(dob, 'DOB is Required'),
  );
}

Widget edtRectField(
    {TextEditingController? control,
    String hint = '',
    validate,
    IconData? icons,
    bool isRect = true,
    int txtLength = 32,
    keyboardType,
    bool isReadOnly = false,
    int maxLine = 1,
    double contentVerticalPadding = 5,
    double contentHoriPadding = 5,
    textCapitalization = TextCapitalization.words}) {
  return TextFormField(
      textCapitalization: textCapitalization,
      //TextCapitalization.words,
      controller: control,
      textInputAction: TextInputAction.next,
      maxLength: txtLength,
      validator: validate,
      keyboardType: keyboardType,
      maxLines: maxLine,
      //TextInputType.number,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        counterText: '',
        contentPadding: EdgeInsets.symmetric(
            horizontal: contentHoriPadding, vertical: contentVerticalPadding),
        border: OutlineInputBorder(
            borderRadius:
                isRect ? BorderRadius.circular(0) : BorderRadius.circular(30)),
        hintText: hint,
        prefixIcon: Icon(icons),
        labelText: hint,
        hintStyle:
            const TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),
      ));
}

Widget edtTimeField(TextEditingController edtController, Function timeClick) {
  return TextFormField(
    onTap: () {
      timeClick();
    } ,
    decoration: InputDecoration(
      counterText: '',
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      border: OutlineInputBorder(
          gapPadding: 30, borderRadius: BorderRadius.circular(30)),
      hintText: "Select Time",
      hintStyle:
          const TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),
    ),
    textInputAction: TextInputAction.next,
    maxLength: 32,
    readOnly: true,
    controller: edtController,
    // validator: (dob) => ValidationHelper.empty(dob!, 'Time is Required'),
  );
}

Widget edtRateField(TextEditingController edtController) {
  return TextFormField(
    controller: edtController,
    decoration: InputDecoration(
      counterText: '',
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      border: OutlineInputBorder(
          gapPadding: 30, borderRadius: BorderRadius.circular(30)),
      hintText: "Enter Rate",
      hintStyle:
          const TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),
    ),
    textInputAction: TextInputAction.next,
    maxLength: 10,
    keyboardType: TextInputType.number,
    validator: ValidationHelper.rateValidate,
  );
}

Widget edtCommentField(TextEditingController edtController) {
  return TextFormField(
    textCapitalization: TextCapitalization.words,
    controller: edtController,
    decoration: InputDecoration(
        counterText: '',
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        border: OutlineInputBorder(
            gapPadding: 30, borderRadius: BorderRadius.circular(30)),
        hintText: "Enter Comments",
        hintStyle:
            const TextStyle(fontWeight: FontWeight.w300, color: Colors.grey)),
    textInputAction: TextInputAction.next,
    maxLength: 150,
  );
}

Widget raisedRoundAppColorBtn(String txt, Function() btnClick) => ButtonTheme(
//  minWidth: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          btnClick();},
        clipBehavior: Clip.antiAlias,
        child: getTxtWhiteColor(
            msg: 'Add Address', fontSize: 15, fontWeight: FontWeight.bold),
        style: ElevatedButton.styleFrom(
            primary: ColorConst.APP_COLOR,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
      ),
    );

Widget raisedRoundColorBtn(String txt, Color color, Function() btnClick) =>
    ButtonTheme(
//  minWidth: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: () {
          btnClick();
        },
        clipBehavior: Clip.antiAlias,
        child: getTxtWhiteColor(
            msg: 'Add Address', fontSize: 15, fontWeight: FontWeight.bold),
        style: ElevatedButton.styleFrom(
            primary: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
      ),
    );

AppBar getAppBar({required String title, double fontSize = 15}) {
  return AppBar(
      centerTitle: true,
      title: getTxtBlackColor(
          msg: title, fontWeight: FontWeight.bold, fontSize: fontSize));
}

AppBar getAppBarWithBackBtn(
    {String title = '',
    Color bgColor = ColorConst.APP_COLOR,
    double fontSize = 15,
    String titleTag = '',
    Widget? icon,
    List<Widget>? actions}) {
  return AppBar(
    backgroundColor: bgColor,
    leading: icon,
    actions: actions,
    centerTitle: true,
    title: Hero(
        tag: titleTag,
        child: getTxtColor(
            msg: title,
            txtColor: ColorConst.WHITE_COLOR,
            fontSize: fontSize,
            fontWeight: FontWeight.bold)),
  );
}

Divider getDivider() {
  return const Divider(
    color: ColorConst.GREY_COLOR,
    height: 1,
  );
}

Widget edtNameField(TextEditingController edtController) {
  return TextFormField(
    textCapitalization: TextCapitalization.words,
    controller: edtController,
    decoration: InputDecoration(
      counterText: '',
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      border: OutlineInputBorder(
          gapPadding: 30, borderRadius: BorderRadius.circular(30)),
      hintText: "Full Name",
      hintStyle:
          const TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),
    ),
    textInputAction: TextInputAction.next,
    maxLength: 32,
    validator: ValidationHelper.validateName,
  );
}

Widget edtMobileNoField(TextEditingController edtController) {
  return TextFormField(
    controller: edtController,
    decoration: InputDecoration(
      counterText: '',
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      border: OutlineInputBorder(
          gapPadding: 30, borderRadius: BorderRadius.circular(30)),
      hintText: "Mobile number",
      hintStyle:
          const TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),
    ),
    textInputAction: TextInputAction.next,
    maxLength: 10,
    keyboardType: TextInputType.number,
    validator: ValidationHelper.validateMobile,
  );
}

showCustomDialog({BuildContext? ctx}) => showDialog(
    context: ctx!,
    barrierDismissible: false,
    builder: (BuildContext ctx) {
      return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: SizedBox(
            height: 150,
            width: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                getTxtBlackColor(
                    msg: "Loading...",
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ],
            ),
          ));
    });

logout(BuildContext ctx) {
  SPManager.clearPref();
  navigationRemoveAllPush(ctx, LoginPage());
}

onWillPop(BuildContext context) async {
  showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: getTxtColor(
              msg: "Are you sure you want to exit this app?",
              fontSize: 17,
              txtColor: ColorConst.BLACK_COLOR),
          title: getTxtBlackColor(
              msg: "Warning!", fontSize: 18, fontWeight: FontWeight.bold),
          actions: <Widget>[
            FlatButton(
                child: getTxtBlackColor(msg: "Yes", fontSize: 17),
                onPressed: () => SystemNavigator.pop()),
            FlatButton(
                child: getTxtBlackColor(
                  msg: "No",
                  fontSize: 17,
                ),
                onPressed: () => Navigator.pop(context)),
          ],
        );
      });
}

Widget showError(String? error) {
  return Visibility(
      visible: (error != null && error.isNotEmpty) ? false : true,
      child: getTxtColor(msg: error ?? '', txtColor: ColorConst.RED_COLOR));
}

Widget edtDateField(TextEditingController edtController, dateClick,
    {String hintTxt = ''}) {
  return TextFormField(
    onTap: dateClick,
    decoration: InputDecoration(
      counterText: '',
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      border: OutlineInputBorder(
          gapPadding: 30, borderRadius: BorderRadius.circular(30)),
      hintText: hintTxt,
      hintStyle:
          const TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),
    ),
    textInputAction: TextInputAction.next,
    maxLength: 32,
    readOnly: true,
    controller: edtController,
    // validator:ValidationHelper.validateDate,//(dob!, 'Date is Required'),
  );
}
