import 'package:flutter/material.dart';
import 'package:h_pad/models/preset/PresetGroupModel.dart';
import 'package:h_pad/models/preset/PresetModel.dart';

class PresetListItem extends StatelessWidget {
  final Preset preset;

  PresetListItem(this.preset);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: Text(
        '${ preset.name }',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xFFBFBFBF)
        )
      )
    );
  }
}