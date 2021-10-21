class AddReportBean {
  DateTime? dateTime;
  String? id;
  String? date;
  String? time;
  String? rate;
  String? qty;
  String? comment;
  DateTime? dateFormat;

  AddReportBean(this.dateTime, this.date, this.time, this.rate, this.qty,
      this.comment, this.id, this.dateFormat);

  AddReportBean.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'].toDate();
    date = json['date'];
    time = json['time'];
    rate = json['rate'];
    qty = json['qty'];
    comment = json['comment'];
    id = json['id'];
    dateFormat = json['dateFormat'].toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dateTime'] = dateTime;
    data['date'] = date;
    data['time'] = time;
    data['rate'] = rate;
    data['qty'] = qty;
    data['comment'] = comment;
    data['id'] = id;
    data['dateFormat'] = dateFormat;
    return data;
  }
}
