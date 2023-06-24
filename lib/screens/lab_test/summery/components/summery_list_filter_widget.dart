import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ritecare_hms/model/lab_test_model/summery_sub_item_model/lab_test_name_sugg_model.dart';
import 'package:ritecare_hms/utils/color_styles.dart';

import '../../../../data/response/status.dart';
import '../../../../shere_preference/login_preference.dart';
import '../../../../view_model/summery_view_model/lab_test_name_sugge_query_view_model/lab_test_name_query_sugg_view_model.dart';
import '../../../../view_model/summery_view_model/summery_view_model.dart';
import '../../../../widgets/end_date_calendar_widget.dart';
import '../../../../widgets/start_date_calendar_widget.dart';
import '../../../../widgets/resueable_filter_text_filed_widget.dart';
import 'package:http/http.dart' as http;

import '../../../qr_code_screen/bar_code_scanner_screen.dart';
import '../../../qr_code_screen/scanner_screen.dart';

class SummeryListFilterWidget extends StatefulWidget {
  String textField1HintText;
  String textField2HintText;
  final VoidCallback onClick;
  final VoidCallback qrOnClick;

  SummeryListFilterWidget(
      {required this.textField1HintText,
        required this.textField2HintText,
        required this.onClick,
        required this.qrOnClick});

  @override
  State<SummeryListFilterWidget> createState() =>
      _SummeryListFilterWidgetState();
}

class _SummeryListFilterWidgetState extends State<SummeryListFilterWidget> {
  final summeryFilterVM = Get.put(LabTestNameQuerySuggViewModel());
  final summeryVm = Get.put(SummeryViewModel());

  LoginPreference loginPreference = LoginPreference();
  // this variable holds the selected items
  final List<String> _selectedItems = [];
  bool isCheckeds = false;
  dynamic statusId = 0;
  bool isClick = true;
  bool isCancel = false;

  dynamic labTestSuggName;
  dynamic labTestSuggNameId;

  @override
  void initState() {
    summeryFilterVM.getSummeryListFilterStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //bar code ui
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 42,
                  width: 100,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          bottomLeft: Radius.circular(6))),
                  child: Text(
                    "INV NO",
                    style: Styles.poppinsFont14_600,
                  ),
                ),
                InkWell(
                  onTap: widget.qrOnClick,
                  child: Container(
                      height: 42,
                      width: 40,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6),
                              bottomRight: Radius.circular(6))),
                      child: Container(
                        height: 22,
                        width: 22,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/icons/qrcode.png')),
                        ),
                      )),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isCancel = true;
                      _showDialog();
                    });
                  },
                  child: Container(
                    height: 42,
                    width: Get.width * 0.35,
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      children: [
                        Container(
                          height: 26,
                          width: 26,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/filter.png')),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Filter", style: Styles.poppinsFont14_600),
                        SizedBox(
                          width: 20,
                        ),
                        Visibility(
                            visible: isCancel,
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    summeryVm.startDate =
                                        DateFormat("yyyy-MM-dd")
                                            .format(DateTime.now());
                                    summeryVm.endDate =
                                        DateFormat("yyyy-MM-dd")
                                            .format(DateTime.now());

                                     summeryVm.getSummeryListData();

                                    isCancel = false;
                                  });
                                },
                                child: Image.asset(
                                  'assets/images/delete.png',
                                  height: 50,
                                ))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            /// you need to use `StatefulBuilder`'s setState to update dialog ui
            // therefor I am passing this setState to `_showDatePicker`
            builder: (context, setState) => AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: _cancel,
                      child: Icon(
                        Icons.cancel_presentation,
                        size: 30,
                        color: Colors.red,
                      )),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*    InkWell(
                      onTap: ()async{
                        await loginPreference.getServiceId().then((value) {
                          dynamic id = 0;
                          id = value.setviceId;
                        //  summeryVm.getSummeryListData(serviceId: id);
                          Navigator.pop(context);
                        });
                      },
                        child: Text("Selected Patient")),
                    SizedBox(height: 10,),
*/
                    SizedBox(
                      height: 10,
                    ),
                    ExpansionTile(
                      leading:
                      Text("${summeryVm.statusName.value}", style: Styles.poppinsFontBlack12_400),
                      title: Text(""),
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 2,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          children: [
                            ListBody(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                            onTap: (){
                                              setState((){
                                                summeryVm.categoryId.value = 0;
                                                summeryVm.statusName.value = "All";
                                                summeryVm.getSummeryListData();
                                              });

                                            },
                                            child: Text("All")),
                                      ],
                                    ),
                                    Container(
                                      width: 200,
                                      height: 150,
                                      child: ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: summeryFilterVM.summeryListFilterStatus.value.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          isClick = true;
                                                          statusId = summeryFilterVM.summeryListFilterStatus[index].id;
                                                          summeryVm.statusName.value = summeryFilterVM.summeryListFilterStatus[index].name!;
                                                          summeryVm.getSummeryListData(labStatus: statusId);

                                                        });

                                                      },
                                                      child: Text(
                                                          "${summeryFilterVM.summeryListFilterStatus[index].name}",
                                                          style: TextStyle(
                                                              color: (summeryVm.categoryId.value == summeryFilterVM.summeryListFilterStatus[index].id && statusId !=0 )
                                                                  ? Colors.red
                                                                  : Colors
                                                                  .black))),
                                                ),
                                              ),
                                            );
                                          }, separatorBuilder: (context, index)=> Divider(color: Colors.grey, height: 2,),),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                StartDateCalendarWidget(),
                SizedBox(
                  height: 10,
                ),
                EndDateCalendarWidget(),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    FutureBuilder(
                        future: summeryFilterVM.getSummeryLabTestNameSuggData(),
                        builder: (contxt, data) {
                          return Autocomplete<LabTestNameSuggModel>(
                            optionsBuilder: (TextEditingValue textValue) {
                              summeryFilterVM.getSummeryLabTestNameSuggData(
                                  query: textValue.text);
                              print("query text ${textValue.text}");
                              if (textValue.text.isEmpty) {
                                return List.empty();
                              }
                              return summeryFilterVM.labTestNameSuggList
                                  .where((value) => value.name
                                  .toLowerCase()
                                  .contains(textValue.text.toLowerCase()))
                                  .toList();
                            },
                            fieldViewBuilder: (BuildContext context,
                                textEditingController,
                                FocusNode focusNode,
                                VoidCallback onFieldSubmitted) {
                              return Container(
                                height: 40,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Lab test name",
                                    labelStyle: TextStyle(
                                      fontFamily: 'IstokWeb',
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  onSubmitted: (String value) {
                                    setState(() {
                                      print("onchange $value");
                                    });
                                  },
                                ),
                              );
                            },
                            optionsViewBuilder: (BuildContext context,
                                Function onSelect,
                                Iterable<LabTestNameSuggModel> dataList) {
                              return Material(
                                child: ListView.builder(
                                    itemCount: dataList.length,
                                    itemBuilder: (context, index) {
                                      LabTestNameSuggModel data =
                                      dataList.elementAt(index);
                                      return InkWell(
                                        onTap: () => onSelect(data),
                                        child: ListTile(
                                          title: Text("${data.name}"),
                                        ),
                                      );
                                    }),
                              );
                            },
                            displayStringForOption:
                                (LabTestNameSuggModel latTastName) =>
                            '${latTastName.name}',
                            onSelected: (selectedValue) {
                              print("select value ${selectedValue.id}");
                              print("select id ${selectedValue.medicalTypeId}");
                            //  labTestSuggNameId = selectedValue.id;
                              labTestSuggName = selectedValue.name;
                              summeryVm.getSummeryListData(labTestSuggNameId: selectedValue.id);
                            },
                          );
                        }),

                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: Get.width * 0.6,
                          height: 40,
                          child: TextFormField(
                            onChanged: (value){
                              summeryVm.getSummeryListData(invoiceNum: value);
                            },
                            controller: summeryVm.invoNumController.value,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              label: Text("Inv.NO"),
                              labelStyle: TextStyle(
                                  fontFamily: 'IstokWeb',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Styles.greyColor),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Styles.greyColor),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            BarCodeScannerScreen();
                          },
                          child: Container(
                            height: 40,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.grey),
                              borderRadius: BorderRadius.circular(6),
                              image: DecorationImage(
                                  image:
                                  AssetImage('assets/icons/barcode.png')),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),

                    /// ResueableFilterTextFieldWidget(controllerValue: summeryFilterVM.invoNumController.value, hintText: widget.textField2HintText,),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context, _selectedItems);
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Styles.primaryColor, width: 2)),
                      child: InkWell(
                          onTap: () {
                           // summeryVm.getSummeryListData();
                            Navigator.pop(context);
                          },
                          child: Center(
                              child: Text(
                                "Go",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Styles.primaryColor),
                              ))),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _cancel() {
    Navigator.pop(context);
  }
}
