import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:ritecare_hms/function/function_class.dart';

import '../../../../model/lab_test_model/summery_model0/item.dart';
import '../../../../model/lab_test_model/summery_model0/patient_services/patient_services.dart';
import '../../../../utils/color_styles.dart';
import '../../../../view_model/approved_view_model/approved_view_model.dart';
import '../../../../view_model/logged_in_user_view_model/logged_in_users_view_model.dart';
import '../../../../view_model/markes_delevered_view_model/markes_delevered_view_model.dart';
import '../../../../view_model/summery_view_model/marke_as_priented/marke_as_printed_view_model.dart';
import '../../../../view_model/summery_view_model/summery_details_view_model.dart';
import '../../../../view_model/summery_view_model/summery_view_model.dart';
import '../../../report_result_screen/report_screen.dart';
import '../../../report_result_screen/update_report_result_screen.dart';
import '../lab_report_result_print_screem.dart';
import 'lab12_screen.dart';

class ExpandableSummeryListItem extends StatefulWidget {
  final String? name;
  final VoidCallback? onPressed;
  late dynamic? statusId;
  final String? status;
  bool btnVisibility = false;
  List<PatientServices>? patientServiceList;
  dynamic index;
  dynamic userTenentId;
  dynamic userSPermissionId;
  Item summeryListItem;

  ExpandableSummeryListItem(
      {this.name,
      this.onPressed,
      this.statusId,
      this.status,
      this.patientServiceList,
      this.index,
      this.userTenentId,
      this.userSPermissionId,
      required this.summeryListItem});

  @override
  State<ExpandableSummeryListItem> createState() =>
      _ExpandableSummeryListItemState();
}

class _ExpandableSummeryListItemState extends State<ExpandableSummeryListItem> {
  final markeasDeleveredVM = MarkesDeleveredViewModel();
  final markeAsPrintedVM = MarkeAsPrintedViewModel();
  final loggedInUserVM = LoggedInUserViewModel();
  final tableRowDesignVm = Get.put(SummeryDetailsViewModel());
  final approvedVM = Get.put(ApprovedViewModel());
  final summeryVM = Get.put(SummeryViewModel());
  String? status;
  dynamic statusId;
  dynamic itemId;
  dynamic serviceId;
  dynamic pS_TenentId; //pS-> patient service
  dynamic lU_TenentId; //lU-> logged in user
  dynamic uS_providerSingPId; // User.ServiceProviderSignPermission.Id
  dynamic pS_signApprovedBy; //patientservice.SignApprovedBy
  dynamic pS_labStatusId; //patientservice.LabStatusId
  dynamic labStatusCompleted; //LabStatusCompleted
  dynamic labStatusPrinted; //LabStatusPrinted
  bool editBtnVisibility = false;
  bool approvedVisibility = false;

  dynamic? dateTime;
  @override
  void initState() {
    loggedInUserVM.getLoggedInUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("service id11 ${serviceId}");
    print("user tenent id123 ${widget.userTenentId}");
    print("user permission ${widget.userSPermissionId}");
    // print("data${  tableRowDesignVm.tableRowDesignListItem.value.design![0].unit?.name}");
    return Column(
      children: [
        Container(
          height: 150,
          child: ListView.builder(
            itemCount: widget.patientServiceList?.length,
            itemBuilder: (context, index) {
              statusId = widget.patientServiceList![index].labStatusId;
              itemId = widget.patientServiceList![index].itemId;
              serviceId = widget.patientServiceList![index].id;
              pS_TenentId = widget.patientServiceList![index].patient?.tenantId;
              pS_labStatusId =
                  serviceId = widget.patientServiceList![index]?.labStatusId;
              pS_signApprovedBy =
                  serviceId = widget.patientServiceList![index]?.signApprovedBy;

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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(width: 2, color: Styles.primaryColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                    "${widget.patientServiceList![index].item?.name}",
                                    style: Styles.poppinsFontBlack12_500)),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(
                                    "${widget.patientServiceList![index].doctorName}",
                                    style: Styles.poppinsFontBlack12_300)),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(
                                    "${widget.patientServiceList![index].item?.itemCategory?.name}",
                                    style: Styles.poppinsFontBlack12_300))
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: 24,
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
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Center(
                                    child: Text("$status",
                                        style: Styles.poppinsFont12_600))),

                       /////////////////////// condition

                       (pS_TenentId == widget.userTenentId && widget.userSPermissionId > 0 && pS_signApprovedBy == 0 &&
                                    (pS_labStatusId == 2 ||
                                        pS_labStatusId == 5))?

                              Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [

                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _markeAsPrintedAlertDialog(
                                                summeryListItem:
                                                    widget.summeryListItem,
                                                index: index);
                                          });
                                        },
                                        child: Visibility(
                                          visible: statusId == 2 || statusId == 3 ? true: false,
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      'assets/icons/print.png')),
                                            ),
                                          ),
                                        ),
                                        ////assets/icons/print.png
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReportScreen(
                                                        serviceId: serviceId,
                                                        patientService: widget.patientServiceList![index],
                                                      )));
                                        },
                                        child: Visibility(
                                          visible:
                                              (statusId == 4) ? true : false,
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      'assets/icons/edit.png')),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateReportResultScreen(
                                                        serviceId: serviceId,
                                                        patientService: widget
                                                                .patientServiceList![
                                                            index],
                                                      )));
                                        },
                                        child: Visibility(
                                          visible:  statusId == 2 ? true: false,

                                          child:  Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      'assets/icons/edit.png')),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Lab12Screen()));
                                        },
                                        child: Visibility(
                                          visible:
                                              (statusId == 2 || serviceId == 4)
                                                  ? true
                                                  : false,
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      'assets/icons/file.png')),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Visibility(
                                        visible: (statusId == 2 && pS_signApprovedBy == null)
                                            ? true
                                            : false,
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    'assets/icons/approved2.png')),
                                          ),
                                        ),
                                      ),


                                      InkWell(
                                        onTap: () {
                                          _approvedAlertDialog(
                                              patientServices: widget
                                                  .patientServiceList![index]);
                                        },
                                        child: Visibility(
                                          visible: (statusId == 2 && pS_signApprovedBy == 0)
                                              ? true
                                              : false,
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      'assets/icons/check.png')),
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        width: 12,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.to(LabReportResultPrintScreen(
                                            patientService: widget.patientServiceList![index],

                                          ));
                                        },
                                        child: Visibility(
                                          visible: (statusId == 3 || statusId == 2 || statusId == 5)? true: false,

                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      'assets/icons/printer.png')),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      /*InkWell(
                                        onTap: () {
                                          _markasDeleveredAlertDialog(
                                              summeryListItem:
                                                  widget.summeryListItem,
                                              index: index);
                                        },
                                        child: Visibility(
                                          visible: (statusId == 5 &&
                                              pS_signApprovedBy == 0)? true: false,

                                          child: Text("Mark as Delivered"),
                                        ),
                                      ),*/
                                    ],
                                  )
                           :

                              Row(
                                    children: [
                                    
                                      InkWell(
                                        onTap: () {
                                          _markeAsPrintedAlertDialog(
                                              summeryListItem:
                                                  widget.summeryListItem,
                                              index: index);
                                        },
                                        child: Visibility(
                                          visible: statusId == 2 ? true : false,
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      'assets/icons/print.png')),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReportScreen(
                                                        serviceId: serviceId,
                                                        patientService: widget
                                                                .patientServiceList![
                                                            index],
                                                      )));
                                        },
                                        child: Visibility(
                                          visible: (statusId == 1)
                                              ? editBtnVisibility = false
                                              : (statusId == 4)
                                                  ? editBtnVisibility = true
                                                  : (statusId == 2)
                                                      ? editBtnVisibility =
                                                          false
                                                      : editBtnVisibility =
                                                          false,
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      'assets/icons/edit.png')),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateReportResultScreen(
                                                        serviceId: serviceId,
                                                        patientService: widget
                                                                .patientServiceList![
                                                            index],
                                                      )));
                                        },
                                        child: Visibility(
                                          visible: (statusId == 1)
                                              ? editBtnVisibility = false
                                              : (statusId == 4)
                                                  ? editBtnVisibility = false
                                                  : (statusId == 2)
                                                      ? editBtnVisibility = true
                                                      : editBtnVisibility =
                                                          false,
                                          child:  Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      'assets/icons/edit.png')),
                                            ),
                                          ),

                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Lab12Screen()));
                                        },
                                        child: Visibility(
                                          visible: (statusId == 1)
                                              ? widget.btnVisibility = false
                                              : (statusId == 2)
                                                  ? widget.btnVisibility = true
                                                  : (statusId == 4)
                                                      ? widget.btnVisibility =
                                                          true
                                                      : widget.btnVisibility =
                                                          false,
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      'assets/icons/file.png')),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),

//////////////////change 0 to null
                                      InkWell(
                                        onTap: (){
                                          _approvedAlertDialog(patientServices:  _approvedAlertDialog(
                                              patientServices: widget
                                                  .patientServiceList![index]));
                                        },
                                        child: Visibility(
                                          visible: (statusId == 2 && pS_signApprovedBy == null)
                                              ? true
                                              : false,
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage('assets/icons/check.png')
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: statusId == 2 || statusId == 5
                                            ? true
                                            : false,
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage('assets/icons/approved2.png')
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),



                                      InkWell(
                                        onTap: () {
                                          Get.to(LabReportResultPrintScreen(
                                            patientService: widget.patientServiceList![index],
                                          ));
                                        },
                                        child: Visibility(
                                          visible: statusId == 3 || statusId == 5 || statusId == 2?true : false,

                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      'assets/icons/printer.png')),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _markasDeleveredAlertDialog(
                                              summeryListItem:
                                                  widget.summeryListItem,
                                              index: index);

                                        },
                                        child: Visibility(
                                          visible: statusId == 5 ? true : false,

                                          child: Text("Mark as Delivered"),
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _approvedAlertDialog({required PatientServices patientServices}) async {
    print("patient service data ${patientServices.itemId}");

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
                        String currentDateTime =
                            DateFormat("MM-dd-yyyy HH:mm:ss")
                                .format(DateTime.now());
                        dateOfTiemConterter(patientServices.serviceDate);

                        patientServices.serviceDate = "$dateTime";
                        patientServices.signApprovedBy = patientServices.userId;
                        patientServices.signApprovedDate = currentDateTime;
                        approvedVM.postApprovedApiData(data: patientServices);
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
                        //  widget.summeryListItem.invoiceDate = "2023-06-14 04:22:29 PM";
                          // widget.summeryListItem.dueDate = "2023-06-14 04:22:29 PM";


                        widget.summeryListItem.invoiceDate = DateTimeConverter.dateOfTiemConterter(widget.summeryListItem.invoiceDate);
                        widget.summeryListItem.dueDate = DateTimeConverter.dateOfTiemConterter(widget.summeryListItem.dueDate);
                        widget.summeryListItem.patientServices![index]
                            .serviceDate = DateTimeConverter.dateOfTiemConterter(widget.summeryListItem
                            .patientServices![index].serviceDate);



                        //  widget.summeryListItem.patientServices![index].serviceDate = "2023-06-14 04:22:29 PM";

                        widget.summeryListItem.patientServices![index]
                            .labStatusId = 3;
                        print("widget ${widget.summeryListItem}");

                        dynamic data = {
                          "pinvoice":
                              jsonDecode(jsonEncode(widget.summeryListItem))
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

  _markeAsPrintedAlertDialog(
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
                        widget.summeryListItem.patientServices![index]
                            .labStatusId = 5;
                        dynamic data =
                            jsonDecode(jsonEncode(widget.summeryListItem));

                        markeAsPrintedVM.postMarkAsPrintedDAta(data: data);
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
