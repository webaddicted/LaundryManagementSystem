class CountryBean {
  String name, code, dialCode, flag;

  CountryBean({required this.name, required this.code, required this.dialCode, required this.flag});

  factory CountryBean.fromJson(Map<String, dynamic> json) => CountryBean(
      name: json["name"],
      code: json["code"],
      dialCode: json["dial_code"],
      flag: json["flag"]);

  @override
  String toString() {
    return 'Country{name: $name, code: $code, dialCode: $dialCode}';
  }
}
