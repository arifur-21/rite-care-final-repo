import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:ritecare_hms/utils/color_styles.dart';
import 'package:ritecare_hms/view_model/logged_in_user_view_model/logged_in_users_view_model.dart';
import 'package:ritecare_hms/widgets/resuable_header.dart';

import '../../../data/response/status.dart';
import '../../../function/function_class.dart';
import '../../../model/lab_test_model/summery_model0/item.dart';
import '../../../shere_preference/login_preference.dart';
import '../../../view_model/markes_delevered_view_model/markes_delevered_view_model.dart';
import '../../../view_model/summery_view_model/summery_view_model.dart';
import '../../../widgets/app_bar_widget.dart';
import '../../../widgets/drawer_widget.dart';

import '../../qr_code_screen/qr_code_screen.dart';
import '../summery/components/expandable_summery_list_item_widget.dart';

import 'components/summery_list_filter_widget.dart';

class PatientSummeryScreen extends StatefulWidget {
  const PatientSummeryScreen({Key? key}) : super(key: key);

  @override
  State<PatientSummeryScreen> createState() => _PatientSummeryScreenState();
}

class _PatientSummeryScreenState extends State<PatientSummeryScreen> {
  LoginPreference loginPreference = LoginPreference();
  var colors = Styles.primaryColor;

  final summeryVM = Get.put(SummeryViewModel());
  final loggedInUserVM = Get.put(LoggedInUserViewModel());
  final markeasDeleveredVM = MarkesDeleveredViewModel();
  int? statusId;
  String? status = '';
  bool btnVisibility = false;
  dynamic dateTime;
  dynamic dobs;
  final scrollController = ScrollController();
  int page = 1;

  bool isCancel = false;

  dynamic userTenentId;
  dynamic userSPermissionId;

  @override
  void initState() {
    loggedInUserVM.getLoggedInUserData();
    summeryVM.getSummeryListData(isRefreshed: true);
    scrollController.addListener(_scrollListener);

    super.initState();
  }

  void _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      print("another page called");
      await summeryVM.getSummeryListData(isRefreshed: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawerWidget(),
      ),
      appBar: AppBar(
        backgroundColor: Styles.primaryColor,
        actions: [
          AppBarWidget(),
        ],
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                SummeryListFilterWidget(
                  textField1HintText: 'Labtest Name',
                  textField2HintText: 'Inv.No',
                  onClick: () {
                    summeryVM.getSummeryListData();
                    Navigator.pop(context);
                  },
                  qrOnClick: () {
                    //_showDialog();
                    Get.to(QrCodeScreen());
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ResuableHeader(
                  leadingText: 'Date',
                  titleText: 'Inv.No',
                  tralingText: 'Status',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),

          ///////////////// get summery data
          Expanded(
              child: FutureBuilder(
            future: summeryVM.getSummeryListData(),
            builder: (context, snapshot) {
              return Obx(() {
                switch (summeryVM.rxRequestStatus.value) {
                  case Status.LOADING:
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  case Status.ERROR:
                    print("error ${summeryVM.error.value.toString()}");
                    return Text(summeryVM.error.value.toString());

                  case Status.SUCCESS:
                    if (summeryVM.items.isEmpty) {
                      return Text("Item not found, please select date");
                    } else {
                      return ListView.builder(
                          controller: scrollController,
                          // shrinkWrap: true,
                          itemCount: summeryVM.items.length + 1,
                          itemBuilder: (context, index) {
                            if (index == summeryVM.items.length) {
                              return summeryVM.hasReachedMax.value
                                  ? const SizedBox()
                                  : const Center(
                                      child: CircularProgressIndicator());
                            }
                            if (index < summeryVM.items.length) {
                              dobs = summeryVM.items[index].invoiceDate;
                              statusId = summeryVM.items[index].labStatusId;

                           /*   List<int>? listOfStatusId = summeryVM
                                      .items[index].patientServices
                                      ?.map((e) =>
                                          int.parse(e.labStatusId.toString()))
                                      .toList() ??
                                  [];

                              statusId = listOfStatusId.contains(1)
                                  ? 1
                                  : listOfStatusId.contains(4)
                                      ? 4
                                      : listOfStatusId.contains(2)
                                          ? 2
                                          : listOfStatusId.contains(5)
                                              ? 5
                                              : 3;

                              // statusId = summeryVM
                              //     .items?[index].labStatusId;

                              //////////print
                              print(summeryVM.items[index].patientServices
                                  ?.map((element) {
                                return int.parse(
                                    element.labStatusId.toString());
                              }).toList());*/

                              //print("demo1 ${summeryVM.items?[index].patientServices![0].item?.name}");

                              if (statusId == 1) {
                                status = "Pending";
                              } else if (statusId == 2) {
                                status = "Completed";
                              } else if (statusId == 3) {
                                status = "Delivered";
                              } else if (statusId == 4) {
                                status = "Collected";
                              } else if (statusId == 5) {
                                status = "Printed";
                              }

                              return Padding(
                                padding: const EdgeInsets.all(6),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        width: 2,
                                        color: (statusId == 1)
                                            ? Colors.red
                                            : (statusId == 2)
                                                ? Colors.green
                                                : (statusId == 3)
                                                    ? Colors.orange
                                                    : (statusId == 4)
                                                        ? Colors.blue
                                                        : Colors.indigo),
                                  ),
                                  child: ExpansionTile(
                                    trailing: Container(
                                        height: 25,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: (statusId == 1)
                                              ? Colors.red
                                              : (statusId == 2)
                                                  ? Colors.green
                                                  : (statusId == 3)
                                                      ? Colors.orange
                                                      : (statusId == 4)
                                                          ? Colors.blue
                                                          : Colors.indigo,
                                          border: Border(),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 3,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                            child: Text("${status}",
                                                style:
                                                    Styles.poppinsFont12_600))),
                                    title: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                DateFormat('dd-MM-yyyy HH:mm ')
                                                    .format(DateTimeConverter
                                                        .dateOfTiemConterter(
                                                            dobs)),
                                                style:
                                                    Styles.poppinsFontBlack12),
                                            Text(
                                                "${summeryVM.items[index].invoiceNo}",
                                                style:
                                                    Styles.poppinsFontBlack12),
                                          ],
                                        )
                                      ],
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "PATIENT :",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Styles.textGreen),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "${summeryVM.items[index].patient?.firstName}",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),

                                            /*  InkWell(
                    onTap: () {
                      _markasDeleveredAlertDialog(
                          summeryListItem: summeryVM
                              .items![index],
                          index: index
                      );
  
                    },
                    child: Visibility(
                      visible: statusId == 5 ? true: false,
                      child: Text("Mark as Delivered", style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ),*/
                                          ],
                                        ),
                                      ),
                                      ExpandableSummeryListItem(
                                        name: summeryVM
                                            .items[index].patient?.firstName,
                                        statusId: statusId,
                                        status: status,
                                        patientServiceList: summeryVM
                                            
                                            .items[index]
                                            .patientServices,
                                        index: index,
                                        userId: loggedInUserVM
                                            .loggedInUser.value.userId,
                                        userTenentId: loggedInUserVM
                                            .loggedInUser.value.tenantId,
                                        userSPermissionId: loggedInUserVM
                                            .loggedInUser
                                            .value
                                            .serviceProviderSignPermission
                                            ?.id,
                                        summeryListItem: summeryVM.items[index],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return SizedBox();
                          });
                    }
                }
              });
            },
          )),
        ],
      ),
    );
  }

  _markasDeleveredAlertDialog(
      {required Item summeryListItem, required int index}) async {
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.cancel_presentation,
                        size: 30,
                        color: Colors.red,
                      )),
                ],
              ),
              content: Container(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Do you want to change status"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      " ${status}",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              actions: [
                InkWell(
                    onTap: () {
                      setState(() {
                        /*  summeryListItem.invoiceDate = "2023-06-14 04:22:29 PM";
                           summeryListItem.dueDate = "2023-06-14 04:22:29 PM";
                          summeryListItem.patientServices![index].serviceDate = "2023-06-14 04:22:29 PM";*/

                        dateOfTiemConterter(summeryListItem.invoiceDate);
                        summeryListItem.invoiceDate = dateTime.toString();

                        dateOfTiemConterter(summeryListItem.dueDate);
                        summeryListItem.dueDate = dateTime.toString();

                        dateOfTiemConterter(summeryListItem
                            .patientServices![index].serviceDate);
                        summeryListItem.patientServices![index].serviceDate =
                            dateTime.toString();

                        summeryListItem.patientServices![index].labStatusId = 3;
                        print("widget ${summeryListItem}");

                        dynamic data = {
                          "pinvoice": jsonDecode(jsonEncode(summeryListItem))
                        };

                        markeasDeleveredVM.postMarkeAsDelevered(data: data);
                      });
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Confrom',
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
              ],
            ),
          );
        });
  }

  dateOfTiemConterter(dynamic dob) {
    dynamic dobs = "";
    dobs = dob;
    dynamic unixTimestamp = dobs;
    int timestampInMilliseconds = int.parse(
        unixTimestamp.replaceAll(RegExp(r'[^0-9]'), '') ??
            "00:00"); // extract the numeric value from the string
    dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInMilliseconds);

    if (dateTime == null) {
      return "dateTime1";
    } else {
      return dateTime;
    }
  }
}
