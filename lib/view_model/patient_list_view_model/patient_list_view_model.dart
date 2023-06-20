
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:ritecare_hms/model/patinet_list_model/patient_list_model.dart';

import '../../data/response/status.dart';
import '../../repository/search_repository/SearchRepository.dart';
import '../../resources/app_url/app_url.dart';
import '../../shere_preference/login_preference.dart';
import 'package:http/http.dart' as http;

class PatientListViewModel{

  final _api = SearchRepository();

  final patientUnitController = TextEditingController().obs;

  final rxRequestStatus = Status.LOADING.obs;
  final patientList = PatientListModel().obs;
  RxString error = ''.obs;


  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  void setPatientList(PatientListModel _value) => patientList.value = _value;
  void setError(String _value) => error.value = _value;

  dynamic startDate = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;
  dynamic endDate = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;

  RxInt totalPation = 0.obs;

  /// get patient list view model
  void getPatientList({dynamic statusId , dynamic unitId, dynamic page }) async{
    print(page);
    print("pataiten date ${startDate}");
 //   setRxRequestStatus(Status.LOADING);
   await _api.getPatientList(startDate, endDate, statusId, unitId, page).then((value) {
      setRxRequestStatus(Status.SUCCESS);
      setPatientList(value);
      print("patient lit${value}");
    }).onError((error, stackTrace){
      setRxRequestStatus(Status.ERROR);
      setError(error.toString());
      print("viewModel error ${error.toString()}");
    });
  }


}