

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * 일반 Alert 창
 * */
class AlertNormal extends StatelessWidget{

  String title = "";
  String contents  = "";
  AlertNormal({required this.title, required this.contents});

  @override
  Widget build(BuildContext context) {
    return _buildAlert(context, title, contents);
  }


  Widget _buildAlert(BuildContext context, String title, String contents) => new Container(
      child:  AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(contents),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      )
  );


}