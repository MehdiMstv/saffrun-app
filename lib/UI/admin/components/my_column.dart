
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:saffrun_app/constants/theme_color.dart';

class MyColumn extends StatelessWidget {
  const MyColumn({
    Key? key,
    required this.first_text,
    required this.second_text,
  }) : super(key: key);
  final int first_text;
  final String second_text;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: context.width() * 0.095,
          padding: const EdgeInsets.all(9),
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: colorPallet3),
          child: Center(
            child: Text(
              '$first_text',
              style: boldTextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        2.height,
        Center(
          child: Text(
            second_text,
            style: boldTextStyle(
              color: colorPallet3,
            ),
          ),
        ),
      ],
    );
  }
}
