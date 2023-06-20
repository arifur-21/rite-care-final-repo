import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:ritecare_hms/utils/color_styles.dart';
import 'package:ritecare_hms/widgets/resuable_header.dart';
import '../../../data/app_exceptions.dart';
import '../../../data/response/status.dart';
import '../../../function/function_class.dart';
import '../../../model/lab_test_model/lab_test_list_model.dart';
import '../../../model/lab_test_model/simple_list_models.dart';
import '../../../model/patinet_list_model/patient_list_model.dart';
import '../../../view_model/sampleListViewModel/sample_list_view_model.dart';
import '../../../view_model/summery_view_model/summery_view_model.dart';
import '../../../widgets/app_bar_widget.dart';
import '../../../widgets/drawer_widget.dart';

import '../../../widgets/filter_button.dart';
import '../../../widgets/popup_button_widget.dart';
import '../summery/components/expandable_summery_list_item_widget.dart';

import 'components/expandable_item_sub_list.dart';
import 'components/sample_filter_widget.dart';
import 'package:http/http.dart' as http;

class SampleList extends StatefulWidget {
  const SampleList({Key? key}) : super(key: key);

  @override
  State<SampleList> createState() => _SampleListState();
}

class _SampleListState extends State<SampleList> {
  var colors = Styles.primaryColor;

  final sampleVM = Get.put(SampleListVeiewModel());
  dynamic statusId;
  String? status = '';
  dynamic getResult = 'QR Code Result';

  dynamic? dateTime;
  dynamic dobs = "/Date(1680773234000)/";


  final scrollController = ScrollController();
  int page = 1;

  dateOfTiem(){
    dynamic dob = dobs;
    print("dob12123 ${dob}");
    dynamic unixTimestamp = dob;
    int timestampInMilliseconds = int.parse(unixTimestamp.replaceAll(RegExp(r'[^0-9]'), '')); // extract the numeric value from the string
    dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInMilliseconds);
    print(" date time11 ${dateTime.toString()}");
    return dateTime;
  }

  @override
  void initState() {
    sampleVM.getSampleListData();
    scrollController.addListener(_scrollListener);
    super.initState();
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
                SampleListFilterWidget(
                  textField1HintText: 'Sample Id',
                  textField2HintText: 'Inv.NO',
                  onClick: () {
                    sampleVM.getSampleListData();
                    Navigator.pop(context);
                  },
                  barCodeOnClick: () {
                  //  scanQRCode();
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
          Expanded(
            child: Obx(() {
              switch (sampleVM.rxRequestStatus.value) {
                case Status.LOADING:
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                case Status.ERROR:
                  print("error ${sampleVM.error.value.toString()}");
                  return Text(sampleVM.error.value.toString());

                case Status.SUCCESS:
                  if (sampleVM.sampleListItem.value.items?.length == 0 ||
                      sampleVM.sampleListItem.value.items?.length == null) {
                    return Center(child: Text("Item not found, please select date"));
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: sampleVM.sampleListItem.value.items?.length,
                        itemBuilder: (context, index) {
                          statusId = sampleVM.sampleListItem.value.items?[index].labStatusId;
                          print("sample status id ${statusId}");


                          dobs = sampleVM.sampleListItem.value.items?[index].invoiceDate;

                          List<int>? listOfStatusId = sampleVM.sampleListItem
                              .value.items?[index].patientServices
                              ?.map((e) => int.parse(e.labStatusId.toString()))
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

                          print(sampleVM.sampleListItem.value.items?[index]
                              .patientServices
                              ?.map((element) {
                            return int.parse(element.labStatusId.toString());
                          }).toList());



                          if(statusId == 1){
                            status = "Pending";
                          }
                          else if(statusId == 2){
                            status = "Completed";
                          }
                          else if(statusId == 3){
                            status = "Delivered";
                          }
                          else if(statusId == 4){
                            status = "Collected";
                          }else{
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
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                        child: Text("${status}",
                                            style: Styles.poppinsFont12_600))),
                                title: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(DateFormat('dd-MM-yyyy HH:mm ').format(DateTimeConverter.dateOfTiemConterter(dobs)), style: Styles.poppinsFontBlack12),
                                        Text(
                                            "${sampleVM.sampleListItem.value.items?[index].invoiceNo}",
                                            style: Styles.poppinsFontBlack12),
                                      ],
                                    )
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        Text(
                                          "PATIENT :",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Styles.textGreen),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${sampleVM.sampleListItem.value.items?[index].patient?.firstName}",
                                          style: TextStyle(fontSize: 12),
                                        ),


                                      ],
                                    ),
                                  ),
                                  ExpandableItemSubList(

                                    name: sampleVM.sampleListItem.value.items?[index].patient?.firstName,
                                      sampleList: sampleVM.sampleListItem.value.items?[index].patientServices,
                                    onTap: (){
                                    //  scanQRCode();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
              }
            }),
          )
        ],
      ),
    );
  }

  void _scrollListener(){

    if(scrollController.position.pixels ==
        scrollController.position.maxScrollExtent){

      page = page + 1;
      sampleVM.getSampleListData(page: page);

    }else{
      print("dont call");
    }

  }
}
