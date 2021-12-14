// import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:saffrun_app/UI/eventPage/event_page.dart';
import 'package:saffrun_app/constants/theme_color.dart';
import 'package:saffrun_app/models/history/reserve_model.dart';


final List<String> imgList2 = [
  'assets/images/mafia1.jpg',
  'assets/images/mafia1.jpg',
  'assets/images/mafia1.jpg',
  'assets/images/mafia1.jpg'
];

class ReserveCardWidget extends StatefulWidget {
  ReserveCardWidget({Key? key,
    required this.reserve,}) : super(key: key);

  final Reserve reserve;

  // static const IconData trash = IconData(0xf4c4, fontFamily: iconFont, fontPackage: iconFontPackage);



  @override
  _ReserveCardWidgetState createState() => _ReserveCardWidgetState();
}

class _ReserveCardWidgetState extends State<ReserveCardWidget> {

  final String item = 'assets/images/mafia1.jpg';
  DateTime now = DateTime.now();
  late final Reserve reserve;

  //-----------------
  // static const duration = const Duration(seconds: 1);
  //
  // int secondsPassed = 0;
  // bool isActive = false;
  //
  // late Timer timer;
  // late int seconds, minutes, hours;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   reserve = widget.reserve;
  //   if (timer == null)
  //     timer = Timer.periodic(duration, (Timer t) {
  //       handleTick();
  //     });
  // }
  //
  // void handleTick() {
  //   if (isActive) {
  //     setState(() {
  //       secondsPassed = secondsPassed + 1;
  //       seconds = secondsPassed * 60;
  //       minutes = secondsPassed ~/ 60;
  //       hours = secondsPassed ~/ (60 * 60);
  //     });
  //   }
  // }
  //------------

  @override
  void initState() {
    reserve = widget.reserve;
    // _iteration();
  }

  int current = 0;
  final CarouselController controller = CarouselController();

  String getStatus(Reserve reserve, DateTime now) {
    switch (reserve.status) {
      case 1:
        {
          final date = DateTime.now();
          final difference_day = date.difference(reserve.startTime).inDays.round();
          final difference_hour = date.difference(reserve.startTime).inHours.round();
          final difference_minute = date.difference(reserve.startTime).inMinutes.round();
          final difference_second = date.difference(reserve.startTime).inSeconds.round();

          if (difference_day>0){
            // return difference_day.toString() + " روز";
            // return (difference_hour - difference_day * 24 - hours).toString() + ":" +
            //     (difference_minute - difference_hour * 60 - minutes).toString() + ":" +
            //     (difference_second - difference_minute * 60 - seconds).toString();
            return (difference_hour - difference_day * 24).toString() + ":" +
                (difference_minute - difference_hour * 60).toString() + ":" +
                (difference_second - difference_minute * 60).toString();

          }
          else{
          return (difference_hour - difference_day * 24).toString() + ":" +
          (difference_minute - difference_hour * 60).toString() + ":" +
          (difference_second - difference_minute * 60).toString();
          }
        }
        // break;

      case 2:
        {
          final date = DateTime.now();
          final difference_day = date.difference(reserve.finishTime).inDays.round();
          final difference_hour = date.difference(reserve.finishTime).inHours.round();
          final difference_minute = date.difference(reserve.finishTime).inMinutes.round();
          final difference_second = date.difference(reserve.finishTime).inSeconds.round();

          if (difference_day>0){
            return difference_day.toString() + " روز";
          }
          else{
            return (difference_hour - difference_day * 24).toString() + ":" +
                (difference_minute - difference_hour * 60).toString() + ":" +
                (difference_second - difference_minute * 60).toString();
          }
        }
        // break;

      case 3:
        {
          return "-";
        }
        // break;

      default:
        {
          return "";
        }
        // break;
    }
  }
  Color getColor(Reserve reserve) {
    switch(reserve.status) {
      case 1: {  return Colors.green; }
      // break;

      case 2: {  return Colors.yellow; }
      // break;

      case 3: {  return Colors.red; }
      // break;

      default: { return Colors.white; }
      // break;
    }
  }
  var initial_icon = Icon(Icons.delete,color: Colors.grey,);
  void _mouseEnter(Color c) {
    setState(() {
      initial_icon = Icon(Icons.delete,color: c,);
    });
  }
  // void _iteration(){
  //   setState(() {
  //       var a=0;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: context.height() * 0.3,
        // width: context.width() * 0.3,
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(
            boxShadow: defaultBoxShadow(),
            borderRadius: BorderRadius.circular(12)),
        child: IntrinsicHeight(
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(color: colorPallet2, width: 10),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(left: context.width() * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    boxShadow: defaultBoxShadow(),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Image(
                                  height: context.height() * 0.15,
                                  width: context.width() * 0.35,
                                  image: AssetImage(item),
                                  fit: BoxFit.fill,

                                ),
                              ),
                              Column(
                                children:[
                                  Text(reserve.title),
                                  SizedBox(
                                    height: context.height() * 0.01,
                                  ),
                                  Text('hazine'),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: context.height() * 0.035,
                                    width: context.width() * 0.15  ,
                                    decoration: boxDecorationWithRoundedCorners(
                                        backgroundColor: getColor(reserve)),
                                    child: Center(
                                      child: Text(
                                        getStatus(reserve,now),
                                        style: boldTextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: context.height() * 0.01,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: context.height() * 0.01,
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: context.height() * 0.1,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Wrap(
                                      direction: Axis.vertical,
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'تاریخ شروع: ',
                                              style: primaryTextStyle(),
                                            ),
                                            Text(
                                              '10 آبان | 8:00',
                                              style: boldTextStyle(),
                                            ),
                                          ],
                                        ).paddingSymmetric(horizontal: 10),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'تاریخ پایان: ',
                                              style: primaryTextStyle(),
                                            ),
                                            Text(
                                              '10 آبان | 14:00',
                                              style: boldTextStyle(),
                                            ),
                                          ],
                                        ).paddingSymmetric(horizontal: 10),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: context.width() * 0.01),
                                  child: Row(
                                    children:[
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => EventPage()));
                                        },
                                        child: MouseRegion(
                                          child: initial_icon,
                                          onHover: (event) {
                                            _mouseEnter(Colors.red);
                                          },
                                          onExit: (event) {
                                            _mouseEnter(Colors.grey);
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: context.width() * 0.01,
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => EventPage()));
                                        },
                                        child: Container(
                                          height: context.height() * 0.07,
                                          width: context.width() * 0.2,
                                          decoration: boxDecorationWithRoundedCorners(
                                              backgroundColor: colorPallet3),
                                          child: Center(
                                            child: Text(
                                              'جزئیات',
                                              style: boldTextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),


                      // SizedBox(height: 8),

                      // 10.height,
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


final List<Widget> imageSliders = imgList2
    .map((item) => Container(
  child: Container(
    margin: const EdgeInsets.all(5.0),
    child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Image(
              image: AssetImage(item),
            ),
          ],
        )),
  ),
))
    .toList();




