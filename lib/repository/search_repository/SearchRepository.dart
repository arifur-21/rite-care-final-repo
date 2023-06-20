
import 'dart:math';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ritecare_hms/model/search_model/SearchModel.dart';
import 'package:ritecare_hms/resources/app_url/app_url.dart';

import '../../data/network/network_api_services.dart';
import '../../model/lab_test_model/lab_test_list_model.dart';
import '../../model/lab_test_model/simple_list_models.dart';
import '../../model/lab_test_model/status_model.dart';
import '../../model/lab_test_model/summery_model0/summery_model0.dart';
import '../../model/lab_test_model/summery_sub_item_model/table_row_design_model.dart';
import '../../model/ot_management_model/ot_list_model.dart';
import '../../model/patinet_list_model/patient_list_model.dart';
import '../../model/register/rank_model.dart';
import '../../model/user_profile_model/user_profile_model.dart';
import '../../view_model/login_view_model/logged_in_user_model.dart';
import '../../view_model/serch_view_mode/SearchViewModel.dart';


class SearchRepository{

  final _apiServices = NetworkApiServices();
  List<SearchModel> getPatientCellNoApi = [];
  List<SearchModel> response = [];


  Future<SearchModel> getSearch(String id)async{
    dynamic response = await _apiServices.getPatientById(id);
    return SearchModel.fromJson(response);
  }


  /// get object data
  /// get logged in user data
  Future<LoggedInUserModel> getLoggedInUserData()async{
    dynamic response = await _apiServices.getApiData('/Login/GetLoggedinUser');
    return LoggedInUserModel.fromJson(response);
  }

  /// get user profile
  Future<UserProfileModel> getUserProfile()async{
    dynamic response = await _apiServices.getApiData('/Login/GetLoggedinUser');
    return UserProfileModel.fromJson(response);
  }


  //get sample list data
  Future<SampleTest> getSampleListData(startDate, endDate,statusId, page, serviceId)async{
    print("------------------> date <----------------------");
    print(startDate);
    print(endDate);
    print("test sample ");
    dynamic response = await _apiServices.getApiData('/Item/GetInvoiceSampleIDByMedicalType?id=0&statusid=0&medicalTypeID=62&DateStart=$startDate&DateEnd=$endDate&pageNumber=1&pageSize=25&invoiceId=undefined&sampleId=null');
    return SampleTest.fromJson(response);
  }



  //get summery list data
  Future<SummeryModel> getSummeryListData(startDate, endDate,statusId, page, serviceId)async{
    dynamic response = await _apiServices.getApiData('/Item/GetPatientInvoicebyMedicalType?id=${serviceId}&statusid=$statusId&medicalTypeID=62&DateStart=${startDate}&DateEnd=${endDate}&pageNumber=1&pageSize=100&invoiceId=undefined&sampleId=null&itemId=undefined');
    return SummeryModel.fromJson(response);
  }

  //get table row design item
  Future<TableRowDesignModel> getTableRowDesignItem(serviceId, itemId)async{
    print("repo item Id ${itemId}");
    print("repo service Id ${serviceId}");
    dynamic response = await _apiServices.getApiData('/Item/GetTableRowDesignByItemId?itemId=$itemId&machineId=&groupItemId=&serviceId=$serviceId');
    return TableRowDesignModel.fromJson(response);
  }

  /// get patient list
  Future<PatientListModel> getPatientList( startDate, endDate,statusId, unitId, page)async{
    dynamic response = await _apiServices.getApiData("/Patient/GetPatientList?pageNumber=1&pageSize=25&startDate=${startDate}&endDate=${endDate}&unitId=${unitId}&bloodGroupId=${statusId}");
    return PatientListModel.fromJson(response);
  }



  List<SearchModel> searchData =[];
  Future<List<SearchModel>> getPatientByOccicialNo(String id)async{
    dynamic response = await _apiServices.getListOfApiData('/Patient/GetPatientByServiceId?serviceNumber=${id}&oldData=false');

    searchData.clear();
    for(Map i in response){
      SearchModel data =  SearchModel.fromJson(i);
      searchData.add(data);
    }
    return searchData;
  }

  List<SearchModel> searchDataOfficial =[];
  Future<List<SearchModel>> getPateintByCellNO(String id)async{
    dynamic response = await _apiServices.getListOfApiData('/Patient/GetPatientByPhone?phoneNumber=${id}');
    searchDataOfficial.clear();
    for(Map i in response){
      SearchModel data =  SearchModel.fromJson(i);
      searchDataOfficial.add(data);
    }
    return searchDataOfficial;
  }


  List<SearchModel> searchDataByName =[];
  Future<List<SearchModel>> getPateintByName(String id)async{

    dynamic response = await _apiServices.getListOfApiData('/Patient/SearchPatientByPartialName?name=${id}&partialFullSearch=true');
    searchDataByName.clear();
    for(Map i in response){
      SearchModel data =  SearchModel.fromJson(i);
      searchDataByName.add(data);
    }
    return searchDataByName;
  }


}