
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ritecare_hms/screens/lab_test/summery/components/lab12_screen.dart';
import 'package:ritecare_hms/utils/color_styles.dart';
import 'package:ritecare_hms/widgets/reusable_icon_containter.dart';

import '../../../../model/lab_test_model/simple_list_models.dart';

class ExpandableItemSubList extends StatefulWidget {

  final String? title;
  final String? category;
  final String? name;
  final VoidCallback? onTap;
  final dynamic barCode;
  List<PatientServices>? sampleList;

  ExpandableItemSubList({this.title, this.category, this.name, this.onTap, this.sampleList, this.barCode});

  @override
  State<ExpandableItemSubList> createState() => _ExpandableItemSubListState();
}

class _ExpandableItemSubListState extends State<ExpandableItemSubList> {
  @override
  Widget build(BuildContext context) {
    return   Container(
      height: 220,
      child:  ListView.builder(
          itemCount: widget.sampleList?.length ,
          itemBuilder: (context, index){
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
                              child: Text("${widget.sampleList![index].item?.name}", style: Styles.poppinsFontBlack12_500)),
                          SizedBox(width: 10,),
                          Expanded(
                              flex: 1,
                              child: Text("${widget.sampleList![index].doctorName}",style: Styles.poppinsFontBlack12_300)),
                          SizedBox(width: 10,),
                          Expanded(
                              flex: 1,
                              child: Text("${widget.sampleList![index].item?.itemCategory?.name}",style: Styles.poppinsFontBlack12_300))

                        ],),
                      SizedBox(height: 20,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                         // Text("100893", style: Styles.poppinsFontBlack12_600),

                          Container(
                              height: 25,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Styles.primaryColor,
                                border: Border(),
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Center(
                                  child: Text("Complete", style: Styles.poppinsFont12_600))

                          ),
                          /*Row(
                            children: [
                              InkWell(
                                onTap: widget.onTap,
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage('assets/icons/barcode.png')
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12,),

                              InkWell(
                                onTap: (){

                                },
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage('assets/icons/message.png')
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          )*/
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }, ),
    );
  }
}
