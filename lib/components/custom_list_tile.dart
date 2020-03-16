import 'package:aoe2/constants.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final Function onTap;

  CustomListTile(this.title,this.onTap);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: kTrajanTitle,
      ),
      trailing: Icon(
        Icons.play_arrow,
        color: Color(kRedColor),
        size: 28,
      ),
      onTap: () => onTap(),
    );
  }
}
