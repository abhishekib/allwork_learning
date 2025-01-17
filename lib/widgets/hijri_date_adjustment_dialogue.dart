import 'dart:developer';

import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:flutter/material.dart';

class HijriDate extends StatefulWidget {
  const HijriDate({super.key});

  @override
  HijriDateState createState() => HijriDateState();
}

class HijriDateState extends State<HijriDate> {
  final List<String> _hijriDateAdjustment = [
    '-4',
    '-3',
    '-2',
    '-1',
    '0',
    '1',
    '2',
    '3',
    '4'
  ];

  String _selectedAdjustment = '0';

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
            child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Hijri Date Adjustment',
                      style: AppTextStyles.whiteBoldTitleText,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Adjust the Hijri date to match the local sighting',
                      style: AppTextStyles.whiteText,
                    ),
                    const SizedBox(height: 10),
                    DropdownButton(
                        value: _selectedAdjustment,
                        style: AppTextStyles.whiteBoldText,
                        selectedItemBuilder: (context) {
                          return _hijriDateAdjustment
                              .map((value) => Center(
                                    child: Text(
                                      value,
                                      style: AppTextStyles.whiteBoldText,
                                    ),
                                  ))
                              .toList();
                        },
                        items: _hijriDateAdjustment
                            .map((value) => DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: AppTextStyles.blueBoldText,
                                )))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAdjustment = value!;
                          });
                          log(_selectedAdjustment);
                        }),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ))));
  }
}
