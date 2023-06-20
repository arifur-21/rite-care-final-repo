
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ritecare_hms/model/patinet_list_model/patient_list_model.dart';
import 'package:ritecare_hms/utils/color_styles.dart';
import '../../../data/response/status.dart';
import '../../../function/function_class.dart';
import '../../../local_db/boxes/boxes.dart';
import '../../../local_db/search_user_model.dart';
import '../../../view_model/patient_list_view_model/patient_list_view_model.dart';
import '../../../widgets/app_bar_widget.dart';
import '../../../widgets/drawer_widget.dart';
import '../../../widgets/popup_button_widget.dart';
import '../patient_info/patien_info_screen.dart';
import 'components/patient_card_list_view_widget.dart';
import 'components/patient_list_filter_widget.dart';


class PatientListScreen extends StatefulWidget {
  const PatientListScreen({Key? key}) : super(key: key);

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {

  final patinetListVM = Get.put(PatientListViewModel());
  dynamic totalPatient;
  dynamic dob;

  final scrollerController = ScrollController();
  int page = 1;
  List<Items> itemsData= [];

  @override
  void initState() {
   patinetListVM.getPatientList();
   setState(() {
     totalPatient =  patinetListVM.patientList.value?.total;
   });

   scrollerController.addListener(_scrollListener);
   patinetListVM.getPatientList(page: page);
   itemsData?.addAll(patinetListVM.patientList.value.items?.toList()?? []);

   print("list length1 ${itemsData.length}");

    super.initState();
  }

  void _scrollListener()async{
    if(scrollerController.position.pixels == scrollerController.position.maxScrollExtent){
      page = page + 1;

      patinetListVM.getPatientList(page: page);
      itemsData?.addAll(patinetListVM.patientList.value.items?.toList()?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child:DrawerWidget(),
      ),

      appBar: AppBar(
          backgroundColor: Styles.primaryColor,
          actions: [
          AppBarWidget(),
        ]
      ),

      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [

              SizedBox(height: 10,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: Get.width * 0.4,
              height: 80,
              child: Card(
                color: Colors.greenAccent,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 40,),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Total Patient :"),
                          SizedBox(height: 6,),
                          Text("${totalPatient}"),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            PatientListFilterWidget(),

          ],
        ),
            SizedBox(height: 20,),

        Expanded(
          child: Obx ((){
            switch(patinetListVM.rxRequestStatus.value){
              case Status.LOADING:
                return Center(child:  CircularProgressIndicator(),);

              case Status.ERROR:
                print("error ${patinetListVM.error.value.toString()}");
                return Text(patinetListVM.error.value.toString());

              case Status.SUCCESS:
                if(patinetListVM.patientList.value.items!.length == null){
                  return Text("item not found, please select date");
                }else{
                  return ListView.builder (
                      controller: scrollerController,
                      shrinkWrap: true,
                      itemCount: patinetListVM.patientList.value.items!.length ,
                      itemBuilder: (context, index){


                        totalPatient =  patinetListVM.patientList.value?.total;

                        print("amount ${totalPatient}");
                        return Column(
                          children: [
                            PatientCartListViewWidgets(
                                patientId: patinetListVM.patientList.value.items![index].id.toString(),
                                PatientName: patinetListVM.patientList.value.items![index].firstName.toString(),
                                DateOfBirth: patinetListVM.patientList.value.items![index].dOB,
                                onTap: (){

                                  setState(() {
                                    final data = SearchUserModel(
                                      id:  patinetListVM.patientList.value.items![index].id,
                                      cellNo: patinetListVM.patientList.value.items![index].phoneNumber,
                                      name:patinetListVM.patientList.value.items![index].firstName,
                                      officalNo: patinetListVM.patientList.value.items![index].serviceId,
                                      patientId: patinetListVM.patientList.value.items![index].id,
                                      gender: patinetListVM.patientList.value.items![index].gender?.name,
                                      email: patinetListVM.patientList.value.items![index].email,
                                      dob: patinetListVM.patientList.value.items![index].dOB,
                                      bloodGroup: patinetListVM.patientList.value.items![index].bloodGroup,
                                      mobile: patinetListVM.patientList.value.items![index].phoneNumber,
                                      emergencyContact: patinetListVM.patientList.value.items![index].emergencyNumber,
                                      emergencyRelation: patinetListVM.patientList.value.items![index].emergencyContactRelation,
                                      relationship: patinetListVM.patientList.value.items![index].relationship?.name,
                                      rank: patinetListVM.patientList.value.items![index].rank?.name,
                                      unit: patinetListVM.patientList.value.items![index].unit?.name,
                                      patienStatus: patinetListVM.patientList.value.items![index].patientStatus,
                                      patientPrefix: patinetListVM.patientList.value.items![index].patientPrefix?.name,
                                    );
                                    final box = Boxes.getData();
                                    box.put("id", data);
                                    data.save();
                                    print("hive ${box.length}");
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> PatientInfoScreen(
                                      isInfoVisible: 1,
                                    )));

                                  });


                                })
                          ],
                        );
                      });
                }
            }
          }),
        )
          ],
        ),
      ),

    );
  }
}
