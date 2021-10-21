class AddCustomerBean {
  String? name;
  String? mobileNo;
  String? date;
  String? time;
  String? rate;
  String? qty;
  String? dateTime;
  String? id;

  AddCustomerBean(this.name, this.mobileNo, this.date, this.time, this.rate,
      this.qty, this.dateTime, this.id);

  AddCustomerBean.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobileNo = json['mobileNo'];
    date = json['date'];
    time = json['time'];
    rate = json['rate'];
    qty = json['qty'];
    dateTime = json['dateTime'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['mobileNo'] = mobileNo;
    data['date'] = date;
    data['time'] = time;
    data['rate'] = rate;
    data['qty'] = qty;
    data['dateTime'] = dateTime;
    data['id'] = id;
    return data;
  }
}
