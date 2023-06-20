
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ritecare_hms/model/register/service_type_id_model.dart';
import 'package:ritecare_hms/model/search_model/SearchModel.dart';
import 'package:ritecare_hms/resources/app_url/app_url.dart';

import '../../data/response/status.dart';
import '../../model/register/blood_group_model/BloodGroupModel.dart';
import '../../model/register/gender_model.dart';
import '../../model/register/number_check_model.dart';
import '../../model/register/rank_model.dart';
import '../../repository/repository.dart';
import '../../shere_preference/login_preference.dart';
import '../../utils/utils.dart';
import 'package:http/http.dart' as http;

class PatientRegisterViewModel extends GetxController{


  final _api = Repository();
  LoginPreference loginPreference = LoginPreference();
  var token;

  final  officalNOController = TextEditingController().obs;
  final  firstNameController = TextEditingController().obs;
  final  phoneNumberController = TextEditingController().obs;
  final  zipCodeController = TextEditingController().obs;
  final  rankController = TextEditingController().obs;
  final  uniController = TextEditingController().obs;
  final  emailController = TextEditingController().obs;

  final  lastNameController = TextEditingController().obs;
  final  patientOldIdController = TextEditingController().obs;
  final  nationalIdController = TextEditingController().obs;
  final  emergencyContactNumberController = TextEditingController().obs;
  final  emergencyNameContactController = TextEditingController().obs;
  final  emergencyContactRelationController = TextEditingController().obs;
  final  streetController = TextEditingController().obs;
  final  cityController = TextEditingController().obs;

  final rxRequestStatus = Status.LOADING.obs;
  final rxRequestStatus1 = Status1.SUCCESS.obs;
  RxString error = ''.obs;
  final rankListItem = <RankModel>[].obs;
  final unitListItem = <RankModel>[].obs;
  final numberCehckList = <NumberCheckModel>[].obs;
  dynamic serviceId = ''.obs;

  dynamic serviceTypeIdList = ServiceTypeIdModel().obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  void setRxRequestStatus1(Status1 _value) => rxRequestStatus1.value = _value;
  void setServiceTypeId(ServiceTypeIdModel _value) => serviceTypeIdList.value = _value;
  void setRankList(List<RankModel> _value) => rankListItem.value = _value;
  void setUnitList(List<RankModel> _value) => unitListItem.value = _value;
  void setNumberCheckData(List<NumberCheckModel> _value) => numberCehckList.value = _value;
  void setError(String _value) => error.value = _value;



  //get number cross check list data
  Future<List<NumberCheckModel>> getNumberCheckData({ dynamic number}) async {
    await _api.getNumberCheckData(number).then((value) {
      setRxRequestStatus1(Status1.SUCCESS);
      setNumberCheckData(value);
      print("phone valu ${value}");
    }).onError((error, stackTrace){
      print("viewModel error ${error.toString()}");
    });
    return numberCehckList;
  }


  /// get service typte by id check cross
 Future<void> getServiceTypeId({dynamic value})async{
    await _api.getServiceTypeId(value).then((value) {
      print("cell no response ${value}");
      setRxRequestStatus1(Status1.SUCCESS);
      setServiceTypeId(value);
      serviceId = value.patient?.serviceId;
    }).onError((error, stackTrace){
      print("viewModel error ${error.toString()}");
    });

  }


  //registration short form
  void registerPatient({
    dynamic serviceId,
    dynamic genderId,
    dynamic bloodId,
    dynamic imageUrl,
    dynamic  dateOfBrith,
    dynamic isRetired,
    dynamic prefixId,
    dynamic statusId,
    dynamic relationId,
    dynamic rankId,
    dynamic unitId,
    dynamic patientPrefixName,
    dynamic patientStatusName,
    dynamic patientRelationName,
    dynamic bloodGroupName,
    dynamic genderName,
    dynamic rankName,
    dynamic unitName,
  }){
    print("unit ${statusId}");
    print("rank ${rankName}");
    print("rank ${rankListItem}");

    Map data =   {
      "FirstName": firstNameController.value.text,
      "PhoneNumber": phoneNumberController.value.text,
      "GenderId": genderId,
      "BloodGroup": null,
      "BloodGroupId": bloodId,
      "DOB": dateOfBrith.toString(),
      "Email": emailController.value.text,
      "Photo": null,
      "CreatedDate": dateOfBrith.toString(),
      "ServiceId": officalNOController.value.text,
      "RelationshipId": relationId,
      "RankId": rankId,
      "TradeId": null,
      "ServiceTypeId": 0,
      "RankTypeId": null,
      "UnitName": unitName.toString(),
      "RankName": rankName.toString(),
      "TradeName": null,
      "UnitId": unitId,
      "IsRetired": isRetired,
      "PatientPrefixId": prefixId,
      "PatientStatusId": statusId,
      "Gender": {
        "Name": genderName.toString(),
        "Id": genderId
      },

      "Rank": {
        "Name": rankName,
        "Id": rankId
      },
      "Unit": {
        "Name": unitId,
        "Id": unitName

      },
     // "Id": 776087
    };

    _api.registerPatient(data).then((value){
      if(value == "PatientExist") {
        Utils.snakBar("Registration", 'Already Exist.');
      }
      print(value);
      if(value['Id'] > 0) {
        Utils.snakBar("Registration", 'Registration successfully');
      }
      print("short form register ${value}");

    }).onError((error, stackTrace) {
      Utils.snakBar("Error", error.toString());
      print("error occured : ${error.toString()}");
    });

  }



  //registration full form
  void registerPatientFullForm({
    dynamic serviceId,
    dynamic genderId,
    dynamic bloodId,
    dynamic imageUrl,
    dynamic  dateOfBrith,
    dynamic isRetired,
    dynamic prefixId,
    dynamic patientStatusId,
    dynamic relationId,
    dynamic rankId,
    dynamic unitId,
    dynamic patientPrefixName,
    dynamic patientStatusName,
    dynamic patientRelationName,
    dynamic bloodGroupName,
    dynamic genderName,
    dynamic rankName,
    dynamic unitName,

  }){


    Map data = {
      "FirstName": firstNameController.value.text,
      "LastName": lastNameController.value.text,
      "PhoneNumber": phoneNumberController.value.text,
      "GenderId": genderId,
      "BloodGroup": null,
      "BloodGroupId": bloodId,
      "DOB": dateOfBrith.toString(),
      "NationalId": nationalIdController.value.text,
      "Street": streetController.value.text,
      "City": cityController.value.text,
      "Zip": "",
      "Country": "BD",
      "Email": emailController.value.text,
      "Photo": null,
      "EmergencyNumber": emergencyNameContactController.value.text,
      "EmergencyContactName": emergencyNameContactController.value.text,
      "EmergencyContactRelation": emergencyContactRelationController.value.text,
      "CreatedDate": dateOfBrith.toString(),
      "ServiceId": officalNOController.value.text,
      "RelationshipId": relationId,
      "RankId": rankId,
      "TradeId": null,
     // "ServiceTypeId": 0,
      "UnitName": unitName.toString(),
      "RankName": rankName.toString(),
      "TradeName": null,
      "UnitId": unitId,
      "IsRetired": isRetired,
      "PatientPrefixId": prefixId,
      "PatientStatusId": null,
    };

    _api.registerPatient(data).then((value){
      if(value == "PatientExist") {
        Utils.snakBar("Registration", 'Already Exist.');
      }
      if(value['Id'] > 0) {
        Utils.snakBar("Registration", 'Registration successfully');
      }
    }).onError((error, stackTrace) {
      Utils.snakBar("Error", error.toString());
      print("error occured : ${error.toString()}");
    });

  }


  void patientRegistrationUpdate({
    dynamic serviceId,
    dynamic genderId,
    dynamic bloodId,
    dynamic imageUrl,
    dynamic  dateOfBrith,
    dynamic isRetired,
    dynamic prefixId,
    dynamic statusId,
    dynamic relationId,
    dynamic rankId,
    dynamic unitId,
    dynamic patientPrefixName,
    dynamic patientStatusName,
    dynamic patientRelationName,
    dynamic bloodGroupName,
    dynamic genderName,
    dynamic rankName,
    dynamic unitName,
  }
      ){


    Map data = {
      "FirstName": firstNameController.value.text,
      "PhoneNumber": phoneNumberController.value.text,
      "GenderId": genderId,
      "BloodGroup": null,
      "BloodGroupId": bloodId,
      "DOB": dateOfBrith.toString(),
      "Email": emailController.value.text,
      "Photo": null,
      "CreatedDate": dateOfBrith.toString(),
      "ServiceId": officalNOController.value.text,
      "RelationshipId": relationId,
      "RankId": rankId,
      "TradeId": null,
      "ServiceTypeId": 0,
      "RankTypeId": null,
      "UnitName": unitName.toString(),
      "RankName": rankName.toString(),
      "TradeName": null,
      "UnitId": unitId,
      "IsRetired": isRetired,
      "PatientPrefixId": prefixId,
      "PatientStatusId": statusId,
      "Gender": {
        "Name": genderName.toString(),
        "Id": genderId
      },

      "Rank": {
        "Name": rankName,
        "Id": rankId
      },
      "Unit": {
        "Name": unitId,
        "Id": unitName

      },
      // "Id": 776087
    };

    _api.registrationUpdate(data).then((value){

      Utils.snakBar("Update", 'Update Successfull');
    }).onError((error, stackTrace) {
      Utils.snakBar("Error", error.toString());
      print("error occured : ${error.toString()}");
    });

  }






  //get rank data
  Future<List<RankModel>> getRankData()async{
    setRxRequestStatus(Status.LOADING);
   await _api.getRankListData().then((value) {
      setRxRequestStatus(Status.SUCCESS);
      setRankList(value);
    }).onError((error, stackTrace){
      setRxRequestStatus(Status.ERROR);
      setError(error.toString());
      print("viewModel error  ${error.toString()}");
    });

    return rankListItem;
  }

  //get unit data
  Future<List<RankModel>> getUnitData({String? query})async{
    setRxRequestStatus(Status.LOADING);
   await _api.getUnitListData(query!).then((value) {
      setRxRequestStatus(Status.SUCCESS);
      setUnitList(value);
    }).onError((error, stackTrace){
      setRxRequestStatus(Status.ERROR);
      setError(error.toString());
      print("viewModel error cell ${error.toString()}");
    });

    return unitListItem;
  }






  Future<List<dynamic>> getPatientPrefix()async {
    var data;

    loginPreference.getToken().then((value){
      token = value.accessToken!;
    });

    final response = await http.get(Uri.parse(AppUrl.patientPrefixurl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'cache-control': 'no-cache'
        }
    );

    if(response.statusCode == 200){
      data  = jsonDecode(response.body) ;
      print("data prefix ${response.body.length}");
      return data;
    }else{
      return data;
    }
  }


  Future<List<dynamic>> getPatientStatus()async {
    var data;

    loginPreference.getToken().then((value){
      token = value.accessToken!;
    });

    final response = await http.get(Uri.parse(AppUrl.patientStatusurl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'cache-control': 'no-cache'
        }
    );

    if(response.statusCode == 200){
      data  = jsonDecode(response.body) ;
      print("data prefix ${response.body.length}");
      final dropdownData = List<dynamic>.from(data);
      return dropdownData;
    }else{
      return data;
    }
  }

  Future<List<dynamic>> getPatientRelation()async {
    var data;

    loginPreference.getToken().then((value){
      token = value.accessToken!;
    });

    final response = await http.get(Uri.parse(AppUrl.patientRelationurl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'cache-control': 'no-cache'
        }
    );

    if(response.statusCode == 200){
      data  = jsonDecode(response.body) ;
      print("data prefix ${response.body.length}");
      return data;
    }else{
      return data;
    }
  }


}