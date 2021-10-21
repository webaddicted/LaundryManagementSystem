import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundry/data/bean/add_report_bean.dart';
import 'package:laundry/utils/common/widget_helper.dart';

class RecordsItemWidget extends StatelessWidget {
  final List<AddReportBean> dataBean;
  final onTap;
  var onLongPress;

  RecordsItemWidget({required this.dataBean, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return _createUi();
  }

  Widget _createUi() {
    return ListView.builder(
        itemCount: dataBean == null ? 0 : dataBean.length,
        itemBuilder: (BuildContext context, int index) {
          return taskRow(context, dataBean[index]);
        });
  }

  Widget taskRow(BuildContext context, AddReportBean recordBean) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: InkWell(
        onLongPress: () {
          onLongPress(recordBean);
        },
        onTap: () {
          onTap(recordBean);
        },
        borderRadius: BorderRadius.circular(4),
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    spreadRadius: 0.5,
                    offset: Offset(0, 2))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                const SizedBox(width: 3),
                Container(
                  height: 68,
                  width: 68,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.blue[300], shape: BoxShape.circle),
                  child: getTxtWhiteColor(
                      msg: '₹', fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (recordBean.comment != null &&
                          recordBean.comment!.isNotEmpty)
                        getTxtBlackColor(
                            msg: '${recordBean.comment}',
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      getTxtBlackColor(
                          msg: 'Quantity : ${recordBean.qty}', fontSize: 16),
                      getTxtBlackColor(
                          msg: 'Rate :  ₹ ${recordBean.rate}', fontSize: 16),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          getTxtGreyColor(
                              msg: '${recordBean.date}', fontSize: 15),
                          const SizedBox(width: 8),
                          getTxtGreyColor(
                              msg: '${recordBean.time}', fontSize: 15),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
