import 'package:flutter/material.dart';

class StepperWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final Function(int) onChange;

  final int count;

  const StepperWidget(
      {Key? key,
      required this.label,
      this.count = 1,
      required this.controller,
      required this.onChange})
      : super(key: key);

  @override
  _StepperWidgetState createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  int _count = 1;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    _count = widget.count;
    controller.text = _count.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "",
          // widget.label.toString() ?? AppLocalizations.of(context)!.quantity,
          style: TextStyle(color: Colors.grey[700]),
        ),
        const SizedBox(
          height: 6,
        ),
        SizedBox(
          width: 200,
          height: 40,
          child: Row(
            children: [
              SizedBox(
                width: 50,
                height: 40,
                child: OutlineButton(
                    borderSide:
                        BorderSide(width: 0.5, color: Colors.grey.shade700),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    )),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(Icons.remove),
                    onPressed: () {
                      if (_count > 0) _count--;
                      controller.text = _count.toString();
                      widget.onChange(_count);
                      setState(() {});
                    }),
              ),
              SizedBox(
                  width: 100,
                  height: 40,
                  child: TextFormField(
                    readOnly: true,
                    controller: controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                  )),
              SizedBox(
                width: 50,
                height: 40,
                child: OutlineButton(
                    borderSide:
                        BorderSide(width: 0.5, color: Colors.grey.shade700),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    )),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(Icons.add),
                    onPressed: () {
                      _count++;
                      controller.text = _count.toString();
                      widget.onChange(_count);
                      setState(() {});
                    }),
              )
            ],
          ),
        ),
      ],
    );
  }
}
