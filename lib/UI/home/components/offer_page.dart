import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:saffrun_app/models/admin/admin_model.dart';

class OfferPage extends StatefulWidget {
  const OfferPage({Key? key}) : super(key: key);

  @override
  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  late List<Admin> mListings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mListings = Admin.admins;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: mListings.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              child: Row(
                children: <Widget>[
                  Container(
                    height: width * 0.32,
                    width: width * 0.32,
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: new BorderRadius.circular(12.0),
                          child: CachedNetworkImage(
                            placeholder: (context, strImage) {
                              return Container(
                                color: Colors.grey,
                              );
                            },
                            imageUrl: mListings[index].getImageUrls()[0],
                            fit: BoxFit.fill,
                            height: width * 0.32,
                            width: width * 0.32,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.only(right: 10, top: 10),
                            child: const Icon(Icons.favorite_border,
                                color: Colors.red, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        text(
                          mListings[index].getName(),
                          textColor: Colors.black,
                        ),
                        text(mListings[index].getDescription(),
                            maxLine: 1, textColor: Colors.black, fontSize: 13),
                        SizedBox(height: 2),
                        Row(
                          children: <Widget>[
                            // RatingBar(
                            //   initialRating: 5,
                            //   minRating: 1,
                            //   itemSize: 16,
                            //   direction: Axis.horizontal,
                            //   itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                            //   ratingWidget: RatingWidget(half: null, full: null),
                            //       (context, _) => Icon(
                            //     Icons.star,
                            //     color: t7colorPrimary,
                            //   ),
                            //   onRatingUpdate: (rating) {},
                            // ),
                            text(mListings[index].getCategory(),
                                textColor: Colors.white, fontSize: 13),
                          ],
                        ),
                        text(mListings[index].getFollowers().toString(),
                            textColor: Colors.black, fontSize: 13),
                        text(mListings[index].getRate(),
                            maxLine: 1,
                            isLongText: true,
                            textColor: Colors.black,
                            fontSize: 13),
                        const SizedBox(height: 8),
                        // const Divider(height: 0.5, color: Colors.black, thickness: 1)
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}

Widget text(String? text,
    {double fontSize = 15,
    Color? textColor,
    var fontFamily,
    var isCentered = false,
    var maxLine = 1,
    var latterSpacing = 0.5,
    bool textAllCaps = false,
    var isLongText = false,
    bool lineThrough = false,
    FontWeight fontWeight = FontWeight.w500}) {
  return Text(
    textAllCaps ? text!.toUpperCase() : text!,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor ?? Colors.white,
      height: 1.5,
      letterSpacing: latterSpacing,
      decoration:
          lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    ),
  );
}
