import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:saffrun_app/UI/commentPage/commentpage.dart';
import 'package:saffrun_app/UI/eventPage/components/add_button.dart';
// import 'package:saffrun_app/UI/eventPage/components/add_button.dart';
import 'package:saffrun_app/constants/theme_color.dart';
import 'package:saffrun_app/data_managment/turnover/turnover_networkservice.dart';
import 'package:saffrun_app/state_managment/event/event_cubit.dart';

import '../../logical/general/size_function.dart';
import '../../models/event/event_model.dart';
import '../admin/admin_page.dart';
import 'components/payment_button.dart';

class EventPage extends StatefulWidget {
  final Event event;
  final Object? heroTag;

  const EventPage({Key? key, required this.event, this.heroTag})
      : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

int current = 0;
final CarouselController controller = CarouselController();

final String description =
    "به‌طور کلی در این بازی قدرت تکلم، حفظ خونسردی و آوردن استدلال‌های منطقی نقش بسزایی در پیروزی دارد. بازیکنان به‌طور مخفیانه نقش شان مشخص می‌شود؛ مافیاها همدیگر را می‌شناسند و شهروند که تنها از تعداد افراد مافیا آگاه هستند و عده معدودی از آن‌ها از برخی نقش‌ها اطلاع دارند. در فاز شب بازی، افراد مافیا به صورت مخفیانه یک شهروند را به قتل می‌رسانند. پزشک سعی می‌کند فردی که مافیا او را می‌خواهند به قتل برسانند را نجات دهد. کارآگاه نیز در پی شناختن مافیا است و اگر مافیا را شناسایی کند باید با استدلال به بقیه شهروندان ثابت کند او مافیا است. مافیا، پزشک، شهروند و کارآگاه شخصیت‌های اصلی بازی هستند و ممکن است در بازی‌های دیگر شخصیت‌های دیگری مانند تک تیرانداز هم به بازی اضافه شود. در طول فاز روز، تمام بازیکنان بازمانده در مورد هویت‌های مافیایی بحث می‌کنند و برای حذف یک مظنون رای‌گیری می‌کنند. بازی ادامه می‌یابد تا زمانی که همهٔ مافیاها از بازی بیرون بروند (برد شهروندان) یا تعداد مافیاها و شهروندان برابر شود (برد مافیا) یا یکی از شخصیت‌های مستقل که هر کدام شرایط برد متفاوتی دارد، برنده بازی شود. در یک بازی معمولاً نقش‌ها باید به گونه‌ای چیده شود که برای هر شخصیت، شخصیت‌های مقابل و مکمل قرار گیرد. مجموعه نمایش خانگی شب‌های مافیا و فیلم‌های گرگ‌بازی، گرگینه، آدمکش و همچنین بازی میان ما و اپیک از روی این بازی ساخته شده‌اند. همچنین مسابقه‌ای با عنوان شهروند و مافیا از شبکهٔ سلامت ایران به نمایش درآمد.";

class _EventPageState extends State<EventPage> {
  late ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
  }

  late Event event;
  late BuildContext contextState;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventCubit(),
      child: Scaffold(
        floatingActionButton: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            onPressed: () {
              if (!event.isParticipate) {
                showDialogForParticipantEvent(context, () async {
                  finish(context);
                  if (event.price != 0) {
                    showDialogForPayment(context, event, () async {
                      bool status =
                          await BlocProvider.of<EventCubit>(contextState)
                              .sendParticipant(event.id);
                      if (status) {
                        await TurnoverNetworkService().postPayment(
                            event.price, event.ownerId, event.id, 'event');
                      }
                      if (status) {
                        toast('با موفقیت به رویداد اضافه شدید');
                        finish(context);
                        event.isParticipate = true;
                        event.participantCount += 1;
                        setState(() {});
                        return true;
                      }
                      finish(context);
                      return false;
                    });
                  } else {
                    bool status =
                        await BlocProvider.of<EventCubit>(contextState)
                            .sendParticipant(event.id);

                    if (status) {
                      toast('با موفقیت به رویداد اضافه شدید');
                      finish(context);
                      event.isParticipate = true;
                      event.participantCount += 1;
                      setState(() {});
                    }
                    finish(context);
                  }

                  // bool status = await BlocProvider.of<EventCubit>(contextState)
                  //     .sendParticipant(event.id);
                  // if (status) {
                  //   toast('با موفقیت به رویداد اضافه شدید');
                  // }
                  // finish(context);
                });
              } else {
                toast('شما قبلا در این رویداد شرکت کرده اید');
              }
            },
            child: Icon(LineIcons.user_plus),
            backgroundColor: colorPallet5,
          ),
        ),
        body: BlocBuilder<EventCubit, EventState>(
          builder: (context, state) {
            print(state);
            contextState = context;
            if (state is EventInitial) {
              BlocProvider.of<EventCubit>(context).fetchEvent(widget.event.id);
            }
            if (state is EventLoadedState) {
              event = state.event;
              return SafeArea(
                child: Container(
                  height: context.height(),
                  width: context.width(),
                  decoration: const BoxDecoration(color: colorPallet5),
                  child: Stack(
                    children: [
                      Column(children: [
                        Hero(
                          tag: widget.heroTag ?? "",
                          child: CarouselSlider(
                            items: state.event.imageUrls
                                .map((item) => CachedNetworkImage(
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          margin: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.contain,
                                                  image: imageProvider)),
                                        );
                                      },
                                      placeholder: (context, strImage) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                        );
                                      },
                                      imageUrl: item,
                                      fit: BoxFit.fill,
                                      height: context.width() * 0.32,
                                      width: context.height() * 0.6,
                                    ))
                                .toList(),
                            carouselController: controller,
                            options: CarouselOptions(
                                autoPlay: true,
                                enlargeCenterPage: true,
                                aspectRatio: 2.0,
                                enableInfiniteScroll: false,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    current = index;
                                  });
                                }),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: state.event.imageUrls
                              .asMap()
                              .entries
                              .map((entry) {
                            return GestureDetector(
                              onTap: () => controller.animateToPage(entry.key),
                              child: Container(
                                width: 12.0,
                                height: 12.0,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.white)
                                        .withOpacity(
                                            current == entry.key ? 0.9 : 0.4)),
                              ),
                            );
                          }).toList(),
                        ),
                      ]),
                      DraggableScrollableSheet(
                          initialChildSize: 0.68,
                          minChildSize: 0.65,
                          builder: (context, scrollController) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25))),
                              child: ListView(
                                controller: scrollController,
                                children: [
                                  const SizedBox(
                                    height: 50.0,
                                    width: 2.0,
                                    child: Divider(
                                      color: Colors.red,
                                      indent: 100,
                                      endIndent: 100,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                                maxWidth:
                                                    context.width() * 0.5),
                                            child: Text(
                                              state.event.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: boldTextStyle(
                                                  color: colorPallet1,
                                                  size: 20),
                                            ),
                                          ),
                                          8.width,
                                          if (state.event.discount != 0)
                                            Container(
                                              height: 40,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              decoration:
                                                  boxDecorationWithRoundedCorners(
                                                      backgroundColor:
                                                          colorPallet5,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                              child: Center(
                                                child: Text(
                                                  "${state.event.discount}%",
                                                  style: primaryTextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      15.width,
                                      GestureDetector(
                                        onTap: () {
                                          pushNewScreen(
                                            context,
                                            screen: AdminPage(
                                              adminId: event.ownerId,
                                            ),
                                            withNavBar: false,
                                            // OPTIONAL VALUE. True by default.

                                            pageTransitionAnimation:
                                                PageTransitionAnimation
                                                    .cupertino,
                                          );
                                        },
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: context.width() * 0.25),
                                          child: Text(
                                            state.event.ownerName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: boldTextStyle(
                                              color: colorPallet5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ).paddingLeft(10),
                                  16.height,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.category_outlined,
                                            color: colorPallet2,
                                          ),
                                          Container(
                                            child: Text(
                                              state.event.category,
                                              style: primaryTextStyle(
                                                  color: colorPallet2,
                                                  size: 18),
                                            ),
                                          ),
                                        ],
                                      ),
                                      30.width,
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.supervised_user_circle_sharp,
                                            color: colorPallet3,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Text(
                                              state.event.participantCount
                                                  .toString(),
                                              style: boldTextStyle(
                                                color: colorPallet3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  20.height,
                                  SizedBox(
                                    height: context.height() * 0.092,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        DottedBorderWidget(
                                          radius: 15,
                                          color: colorPallet5,
                                          child: Column(
                                            // alignment: WrapAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'تاریخ شروع: ',
                                                    style: primaryTextStyle(),
                                                  ),
                                                  Text(
                                                    formatTimeString(
                                                        state.event.startTime),
                                                    style: boldTextStyle(),
                                                  ),
                                                ],
                                              ).paddingSymmetric(
                                                  horizontal: 10, vertical: 3),
                                              Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'تاریخ پایان: ',
                                                    style: primaryTextStyle(),
                                                  ),
                                                  Text(
                                                    formatTimeString(
                                                        state.event.finishTime),
                                                    style: boldTextStyle(),
                                                  ),
                                                ],
                                              ).paddingSymmetric(
                                                  horizontal: 10, vertical: 3),
                                            ],
                                          ),
                                        ).paddingLeft(4),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50.0,
                                    width: 150.0,
                                    child: Divider(
                                      color: Colors.red,
                                      indent: 100,
                                      endIndent: 100,
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'درباره رویداد:',
                                            style: boldTextStyle(),
                                          ),
                                        ),
                                        DescriptionTextWidget(
                                            text: state.event.description),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    child: Divider(
                                      color: Colors.red,
                                      indent: 100,
                                      endIndent: 100,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'نظرات:',
                                        style: boldTextStyle(),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          pushNewScreen(
                                            context,
                                            screen: CommentPage(
                                              eventId: event.id,
                                            ),
                                            withNavBar: false,
                                            // OPTIONAL VALUE. True by default.
                                            pageTransitionAnimation:
                                                PageTransitionAnimation
                                                    .cupertino,
                                          ).then((value) async {
                                            await BlocProvider.of<EventCubit>(
                                                    context)
                                                .fetchEvent(widget.event.id);
                                          });
                                        },
                                        child: const Text('نظر دهید ...'),
                                      )
                                    ],
                                  ),
                                  state.event.comments.isNotEmpty
                                      ? SizedBox(
                                          height: 300,
                                          child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            // itemExtent: ,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                leading: CircleAvatar(
                                                  backgroundColor: colorPallet1,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        getDateForCircle(state
                                                            .event
                                                            .comments[index]
                                                            .date),
                                                        style:
                                                            secondaryTextStyle(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      state
                                                          .event
                                                          .comments[index]
                                                          .userName,
                                                      style: boldTextStyle(),
                                                    ),
                                                    Text(
                                                      state
                                                          .event
                                                          .comments[index]
                                                          .content,
                                                      style:
                                                          secondaryTextStyle(),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                            itemCount:
                                                state.event.comments.length,
                                          ),
                                        )
                                      : const Center(
                                          child: Text("هیچ نظری یافت نشد"))
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              );
            }
            return SafeArea(
                child: Container(
              height: context.height(),
              width: context.width(),
              decoration: const BoxDecoration(color: Colors.white),
              child: const Center(
                child: Text('لطفا چند لحظه صبر کنید'),
              ),
            ));
          },
        ),
      ),
    );
  }
}

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  DescriptionTextWidget({required this.text});

  @override
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 50) {
      firstHalf = widget.text.substring(0, 50);
      secondHalf = widget.text.substring(50, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf.isEmpty
          ? Text(
              firstHalf,
              textAlign: TextAlign.start,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                  textAlign: TextAlign.start,
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        flag ? "بیشتر" : "کمتر",
                        style: const TextStyle(color: colorPallet4),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
