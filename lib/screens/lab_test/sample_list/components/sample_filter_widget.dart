import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ritecare_hms/screens/lab_test/sample_list/components/sample_end_date_calendar_widget.dart';
import 'package:ritecare_hms/screens/lab_test/sample_list/components/sample_start_date_calendar_widget.dart';
import 'package:ritecare_hms/utils/color_styles.dart';

import '../../../../data/response/status.dart';
import '../../../../view_model/sampleListViewModel/sample_list_view_model.dart';
import '../../../../view_model/summery_view_model/summery_view_model.dart';
import '../../../../widgets/end_date_calendar_widget.dart';
import '../../../../widgets/start_date_calendar_widget.dart';
import '../../../../widgets/resueable_filter_text_filed_widget.dart';

class SampleListFilterWidget extends StatefulWidget {
  String textField1HintText;
  String textField2HintText;
  final VoidCallback  onClick;
  final VoidCallback  barCodeOnClick;



  SampleListFilterWidget({required this.textField1HintText, required this.textField2HintText, required this.onClick, required this.barCodeOnClick});

  @override
  State<SampleListFilterWidget> createState() => _SampleListFilterWidgetState();
}

class _SampleListFilterWidgetState extends State<SampleListFilterWidget> {

  final sampleVM = Get.put(SampleListVeiewModel());


  // this variable holds the selected items
  final List<String> _selectedItems = [];
  bool isCheckeds = false;
  dynamic statusId = 0;
  bool isCancel = false;

  @override
  void initState() {
    sampleVM.getSampleListFilterStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('smple filter');
    return SingleChildScrollView(
      child: Container(
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
                            bottomLeft: Radius.circular(6))
                    ),
                    child: Text(
                      "INV NO",
                      style: Styles.poppinsFont14_600,
                    ),
                  ),

                  Container(
                      height: 42,
                      width: 40,

                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6),
                              bottomRight: Radius.circular(6))
                      ),
                      child: InkWell(
                        onTap: widget.barCodeOnClick,
                        child: Container(
                          height: 22,
                          width: 22,
                          decoration: BoxDecoration(

                            image: DecorationImage(
                                image: AssetImage('assets/icons/qrcode.png')
                            ),
                          ),
                        ),
                      )

                  ),
                ],
              ),

              ///filter container

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
                          borderRadius: BorderRadius.circular(6)
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 26,
                            width: 26,
                            decoration: BoxDecoration(

                              image: DecorationImage(
                                  image: AssetImage('assets/images/filter.png')
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Text("Filter", style: Styles.poppinsFont14_600),
                          SizedBox(width: 20,),
                          Visibility(
                              visible: isCancel,
                              child: InkWell(
                                  onTap: (){
                                    setState(() {
                                      sampleVM.startDate =  DateFormat("yyyy-MM-dd").format(DateTime.now());
                                      sampleVM.endDate =  DateFormat("yyyy-MM-dd").format(DateTime.now());
                                      sampleVM.getSampleListData();

                                      isCancel = false;
                                    });

                                  },
                                  child: Image.asset('assets/images/delete.png', height: 50,))),

                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ],),
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
                        Icons.cancel_presentation, size: 30, color: Colors.red,)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ExpansionTile(
                      leading: Text("Status", style: Styles.poppinsFontBlack12_400),
                      title: Text(""),
                      children: [
                        SizedBox(height: 10,),
                        Divider(height: 2, color: Colors.grey,),
                        SizedBox(height: 5,),
                        Column(
                          children: [
                            ListBody(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 150,
                                      child:  FutureBuilder(
                                        future: sampleVM.getSampleListFilterStatus(),
                                          builder: (context, snapshot){
                                          return Obx((){
                                            switch(sampleVM.rxRequestStatus.value){
                                              case Status.LOADING:
                                                return Center(child:  CircularProgressIndicator(),);

                                              case Status.ERROR:
                                                print("error ${sampleVM.error.value.toString()}");
                                                return Text(sampleVM.error.value.toString());

                                              case Status.SUCCESS:
                                                if(sampleVM.sampleListFilterStatus.value.length == 0){
                                                  print("data not found");
                                                  return Text("data not found");
                                                }
                                                else{
                                                  return  ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: sampleVM.sampleListFilterStatus.value.length,
                                                      itemBuilder: (context, index) {

                                                        return ListTile(
                                                          title: Padding(
                                                            padding: const EdgeInsets
                                                                .all(8.0),
                                                            child: InkWell(
                                                                onTap: () {
                                                                  setState((){
                                                                    isCheckeds = !isCheckeds;
                                                                  });
                                                                  statusId = sampleVM.sampleListFilterStatus[index].id;

                                                                  print("status id  = ${sampleVM.sampleListFilterStatus[index].id}");
                                                                },
                                                                child: Text("${sampleVM.sampleListFilterStatus[index].name}", style: TextStyle(color: statusId == sampleVM.sampleListFilterStatus[index].id ? Colors.red : Colors.black ),)),
                                                          ),
                                                        );
                                                      });
                                                }
                                            }
                                          });
                                      }),


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

                SampleStartDateCalendarWidget(),
                SizedBox(height: 10,),
                SampleEndDateCalendarWidget(),
                SizedBox(height: 10,),

                Column(
                  children: [
                    ResueableFilterTextFieldWidget(controllerValue: sampleVM.sampleIdController.value, hintText: widget.textField1HintText,),
                    SizedBox(height: 10,),
                    ResueableFilterTextFieldWidget(controllerValue: sampleVM.invoNumController.value, hintText: widget.textField2HintText,),
                  ],
                ),

                SizedBox(height: 20,),
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
                          border: Border.all(color: Colors.red, width: 2)

                      ),
                      child: InkWell(
                          onTap: (){
                            sampleVM.getSampleListData(statusId: statusId);
                            Navigator.pop(context);
                          },
                          child: Center(
                              child: Text(
                                "Go", style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.red),))),
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





