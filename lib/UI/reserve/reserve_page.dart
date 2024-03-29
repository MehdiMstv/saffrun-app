import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:saffrun_app/UI/admin/components/pament_button_reserve.dart';
import 'package:saffrun_app/UI/utils/appbar/appbar_type1.dart';
import 'package:saffrun_app/constants/theme_color.dart';
import 'package:saffrun_app/models/reserve/reserve.dart';
import 'package:saffrun_app/state_managment/reserve/reserve_cubit.dart';

import '../../data_managment/turnover/turnover_networkservice.dart';
import '../../models/admin/admin_model.dart';
import '../admin/components/reserve_reserve_dialog.dart';
import 'components/card_profile_user.dart';
import 'components/time_component.dart';

class ReservePage extends StatefulWidget {
  Admin adminId;

  ReservePage({Key? key, required this.adminId}) : super(key: key);

  @override
  _ReservePageState createState() => _ReservePageState();
}

class _ReservePageState extends State<ReservePage> {
  Reserve? selectedReserve;
  late Reserve? nearReserve;
  late List<List<Reserve>>? listReserves;
  late ScrollController controller;
  late ScrollController controllerInLiner;
  late BuildContext contextCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = ScrollController();
    controllerInLiner = ScrollController();
    controllerInLiner.addListener(() {
      if (controllerInLiner.position.pixels > 0) {
        controller.animateToPosition(controller.position.maxScrollExtent);
      } else {
        controller.animateToPosition(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReserveCubit(),
      child: Scaffold(
        appBar: AppBarTitleProfileWhite(
          context,
          0,
          title: 'رزرو نوبت',
          functionBack: () {},
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            onPressed: () async {
              if (selectedReserve == null) {
                toast('لطفا یک زمان انتخاب کنید');
                return;
              }
              showDialogForParticipantReserve(context, () async {
                if (selectedReserve?.price != 0) {
                  finish(context);
                  showDialogForPaymentReserve(context, selectedReserve!,
                      () async {
                        bool status =
                        await BlocProvider.of<ReserveCubit>(contextCubit)
                            .sendReserveId(selectedReserve!);
                    if (status) {
                      await TurnoverNetworkService().postPayment(
                          selectedReserve!.price,
                          selectedReserve!.adminId,
                          selectedReserve!.id,
                          'reserve');
                    }
                    if (status) {
                      toast('نوبت با موفقیت گرفته شد');
                      finish(context);
                      Navigator.pop(context);
                      return true;
                    }
                    toast('با خطا مواجه شد');
                    finish(context);
                    return false;
                  });
                } else {
                  bool status =
                      await BlocProvider.of<ReserveCubit>(contextCubit)
                          .sendReserveId(selectedReserve!);
                  if (status) {
                    toast('نوبت با موفقیت گرفته شد');
                    finish(context);
                    Navigator.pop(context);
                    return true;
                  }
                  toast('با خطا مواجه شد');
                  finish(context);
                  return false;
                }
              });
            },
            child: const Icon(Icons.check_rounded),
            backgroundColor: colorPallet5,
          ),
        ),
        body: BlocBuilder<ReserveCubit, ReserveState>(
          builder: (context, state) {
            print(state);
            contextCubit = context;
            if (state is ReserveInitial) {
              BlocProvider.of<ReserveCubit>(context)
                  .loadTimeReserve(widget.adminId.ownerId);
            }
            if (state is ReserveError) {
              return Column(
                children: [
                  SizedBox(
                    height: context.height() * 0.16,
                    child: CardProfileReserveWidget(
                      admin: widget.adminId,
                    ).paddingSymmetric(horizontal: 25),
                  ),
                  const Center(
                          child: Text("هیچ نوبتی برای این کارفرما وجود ندارد"))
                      .paddingTop(30)
                ],
              );
            }
            if (state is ReserveLoadedTime) {
              nearReserve = state.nearest;
              listReserves = state.reserves;
              try {} catch (e) {}
            }

            return Directionality(
              textDirection: TextDirection.rtl,
              child: ListView(
                controller: controller,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(top: 10),
                children: [
                  SizedBox(
                    height: context.height() * 0.16,
                    child: CardProfileReserveWidget(admin: widget.adminId)
                        .paddingSymmetric(horizontal: 25),
                  ),
                  10.height,
                  if (state is ReserveLoadingTime || state is ReserveInitial)
                    Center(child: const CircularProgressIndicator()),
                  if (state is! ReserveLoadingTime && state is! ReserveInitial)
                    SizedBox(
                      height: context.height() * 0.18,
                      child: IntrinsicHeight(
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'نزدیک ترین زمان ممکن',
                                  style: boldTextStyle(),
                                ),
                                15.height,
                                Row(
                                  children: [
                                    Text(getDateString(
                                            nearReserve!.targetStartReserve,
                                            true) +
                                        ":"),
                                    15.width,
                                    InkWell(
                                        onTap: () {
                                          selectedReserve = nearReserve!;
                                          BlocProvider.of<ReserveCubit>(context)
                                              .selectedReserve(nearReserve!);
                                          controller.animateToPosition(0);
                                        },
                                        child: TimeWidget(
                                          selected: (selectedReserve == null
                                                  ? -1
                                                  : selectedReserve!.id) ==
                                              nearReserve!.id,
                                          reserve: nearReserve!,
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ).paddingSymmetric(horizontal: 25),
                    ),
                  if (state is! ReserveLoadingTime && state is! ReserveInitial)
                    IntrinsicHeight(
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 13, horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'زمان های ممکن',
                                style: boldTextStyle(),
                              ),
                              15.height,
                              SizedBox(
                                height: context.height() * 0.65,
                                child: ListView.builder(
                                  controller: controllerInLiner,
                                  padding: EdgeInsets.only(bottom: 65),
                                  shrinkWrap: true,
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    if (listReserves![index].length == 0)
                                      return Container();
                                    return ListView(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: [
                                        Text(
                                          '' +
                                              getDateString(
                                                  listReserves![index][0]
                                                      .targetStartReserve,
                                                  false) +
                                              " : ",
                                          style: primaryTextStyle(),
                                        ),
                                        GridView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  childAspectRatio: 1.65
                                                  // crossAxisSpacing: 5.0,
                                                  // mainAxisSpacing: 5.0,
                                                  ),
                                          itemBuilder: (context, i) {
                                            Reserve reserve =
                                                listReserves![index][i];
                                            return InkWell(
                                                onTap: () {
                                                  selectedReserve = reserve;
                                                  BlocProvider.of<ReserveCubit>(
                                                          context)
                                                      .selectedReserve(reserve);
                                                  controller.animateToPosition(
                                                      controller.position
                                                          .maxScrollExtent);
                                                },
                                                child: TimeWidget(
                                                  selected:
                                                      (selectedReserve == null
                                                              ? -1
                                                              : selectedReserve
                                                                  ?.id) ==
                                                          reserve.id,
                                                  reserve: reserve,
                                                ));
                                          },
                                          itemCount:
                                              listReserves![index].length,
                                        )
                                      ],
                                    );
                                  },
                                  itemCount: listReserves!.length,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 25)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String getDateString(DateTime targetStartReserve, bool near) {
    if (targetStartReserve.isToday) {
      return 'امروز';
    }
    var jalali = Jalali.fromDateTime(targetStartReserve);
    var f = jalali.formatter;
    return '${f.wN} ${f.d} ${f.mN}';
  }
}
