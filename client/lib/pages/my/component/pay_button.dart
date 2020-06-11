import 'package:client/routers/Navigator_util.dart';
import 'package:flutter/material.dart';
class PayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //  decoration: new BoxDecoration(borderRadius: BorderRadius.circular(35)),
        child: RaisedButton(
      color: Colors.yellowAccent,
      onPressed: () {
        NavigatorUtils.rechargeCentrePage(context);
      },
      child: Text('充值'),
    ));
  }
}
