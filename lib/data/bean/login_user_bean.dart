class LoginUserBean {
  String? image;
  String? password;
  String? dob;
  String? name;
  String? emailId;
  String? mobileNo;

  LoginUserBean(
      this.name,
      this.emailId,
      this.mobileNo,
      this.dob,
      this.password,
      this.image);

  LoginUserBean.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    password = json['password'];
    dob = json['dob'];
    name = json['name'];
    emailId = json['emailId'];
    mobileNo = json['mobileNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['password'] = password;
    data['dob'] = dob;
    data['name'] = name;
    data['emailId'] = emailId;
    data['mobileNo'] = mobileNo;
    return data;
  }
}
