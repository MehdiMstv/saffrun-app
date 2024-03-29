import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:saffrun_app/constants/theme_color.dart';

void showDialogForParticipantReserve(
    BuildContext context, Function confirmFunction) {
  showDialog(
      context: context,
      // useSafeArea: false,
      // useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            // contentPadding: const EdgeInsets.all(0.0),
            content: Container(
              height: context.height() * 0.36,
              width: context.width() * 0.8,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'آیا از گرفتن این نوبت اطمینان دارید؟',
                      style: boldTextStyle(),
                      textDirection: TextDirection.rtl,
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                        child: Image(
                            width: MediaQuery.of(context).size.width,
                            image: AssetImage(
                                'assets/images/widget_participant.jpg'),
                            height: context.height() * 0.25,
                            fit: BoxFit.cover),
                      ),
                    ),
                    20.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            confirmFunction();
                          },
                          hoverColor: Colors.white,
                          highlightColor: Colors.white,
                          focusColor: Colors.white,
                          focusElevation: 0.5,
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: boxDecorationWithRoundedCorners(
                                backgroundColor: colorPallet3),
                            child: Center(
                              child: Text(
                                'تایید',
                                style: boldTextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          hoverColor: Colors.white,
                          highlightColor: Colors.white,
                          focusColor: Colors.white,
                          focusElevation: 0.5,
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: boxDecorationWithRoundedCorners(
                              backgroundColor: Colors.white,
                              border: Border.all(
                                color: colorPallet3,
                                width: 5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'لغو',
                                style: boldTextStyle(color: colorPallet3),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      });
}
