import 'package:flutter/material.dart';
import 'package:xivah/farmingNotifiers/qty_counter_notifier.dart';

class CounterBar extends StatelessWidget {
  QtyCounterNotifier _value;
  CounterBar(this._value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo, width: 2.5),
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
              child: Icon(
                Icons.add_circle,
                size: 20.0,
                color: Colors.indigo,
              ),
              onTap: () {
                _value.increment();
              }),
          Container(
            width: 40.0,
            child: Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  text: "${_value.presentValue}",
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                      fontSize: 12.0),
                ),
              ),
            ),
          ),
          InkWell(
              child: Icon(
                Icons.remove_circle,
                color: Colors.indigo,
                size: 20.0,
              ),
              onTap: () {
                _value.decrement();
              })
        ],
      ),
    );
  }
}
