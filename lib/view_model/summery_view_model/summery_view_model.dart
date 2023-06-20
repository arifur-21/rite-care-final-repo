
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:ritecare_hms/model/lab_test_model/status_model.dart';
import 'package:ritecare_hms/model/login_model/login_token_model.dart';
import 'package:ritecare_hms/repository/repository.dart';
import 'package:ritecare_hms/resources/app_url/app_url.dart';

import '../../data/app_exceptions.dart';
import '../../data/response/status.dart';
import '../../model/lab_test_model/lab_test_list_model.dart';

import '../../model/lab_test_model/summery_model0/item.dart';
import '../../model/lab_test_model/summery_model0/summery_model0.dart';
import '../../model/lab_test_model/summery_sub_item_model/lab_test_name_sugg_model.dart';

import '../../model/register/number_check_model.dart';
import '../../model/service_id_model/service_id_model.dart';
import '../../repository/search_repository/SearchRepository.dart';
import '../../shere_preference/login_preference.dart';
import 'package:http/http.dart' as http;

import '../../utils/utils.dart';
import '../login_view_model/logged_in_user_model.dart';

class SummeryViewModel extends GetxController{

  final _api = SearchRepository();
  final _repository = Repository();
  LoginPreference loginPreference = LoginPreference();

  dynamic startDate = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;
  dynamic endDate = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;

  final sampleIdController = TextEditingController().obs;
  final invoNumController = TextEditingController().obs;

  final textController = TextEditingController().obs;

  dynamic resultData;


  final rxRequestStatus = Status.LOADING.obs;
  final summeryListItem = SummeryModel().obs;

  RxString error = ''.obs;
  RxList<Item> items = <Item>[].obs;


  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  void setSummeryList(SummeryModel _value) => summeryListItem.value =  _value;
  void setError(String _value) => error.value = _value;

  RxBool hasReachedMax = false.obs;
  RxInt pageNumber = 1.obs;
  RxInt categoryId = 0.obs;
  RxInt labTestSuggNameId =0.obs;
  RxString scannBarCode = ''.obs;
  //get rank data



  /// get summery list data
  Future<void> getSummeryListData({statusId = 0, dynamic page = 1,dynamic serviceId = 0,})async {
    print("test");
    setRxRequestStatus(Status.LOADING);

    print("summery serviceId ${serviceId}");
    await _api.getSummeryListData(startDate, endDate, statusId, page,serviceId).then((value) {
      setRxRequestStatus(Status.SUCCESS);
      setSummeryList(value);
    }).onError((error, stackTrace){
      setRxRequestStatus(Status.ERROR);
      setError(error.toString());
      print("viewModel error ${error.toString()}");
    });
  }


/*
  /// get summery list data
  Future<void> getSummeryListData({int labStatus = 0, int page = 1, bool isRefreshed = true, })async {
   ServiceIdModel? service = await loginPreference.getServiceId();

    if (isRefreshed == true) {
      pageNumber.value = 1;
      categoryId.value = labStatus;
      hasReachedMax.value = false;

       startDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
       endDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

      await _api
          .getSummeryListData(
          categoryId.value == 0 ? "" : categoryId.value, pageNumber.value,service.setviceId , startDate, endDate,invoNumController.value.text)
          .then((value) {
        setRxRequestStatus(Status.SUCCESS);

        setSummeryList(value);
        items.value = [];

        items.addAll(value.items ?? []);
        // pageNumber.value++;
        if ((value.items?.length ?? 0) < 10) {
          hasReachedMax.value = true;
          print("==================================== reached Max");
        }
        print("lab test VM ${value.items?.length}");
      }).onError((error, stackTrace) {
        setRxRequestStatus(Status.ERROR);
        setError(error.toString());
        print("viewModel error ${error.toString()}");
      });
    } else {
      if (hasReachedMax.value == false) {
        pageNumber.value++;
        categoryId.value = labStatus;

        await _api
            .getSummeryListData(
            categoryId.value == 0 ? "" : categoryId.value, pageNumber.value,service.setviceId , startDate, endDate,invoNumController.value.text)
            .then((value) {
          setRxRequestStatus(Status.SUCCESS);
          setSummeryList(value);
          items.addAll(value.items ?? []);
          if (value.items!.length < 10) {
            hasReachedMax.value = true;
            print(
                "==================================== reached Max other than first call");
          }
          print("lab test VM ${value.items?.length}");
        }).onError((error, stackTrace) {
          setRxRequestStatus(Status.ERROR);
          setError(error.toString());
          print("viewModel error ${error.toString()}");
        });
      }
    }
    setRxRequestStatus(Status.LOADING);

*/

/*    await _api.getSummeryListData(startDate, endDate, statusId, page,serviceId).then((value) {

      setRxRequestStatus(Status.SUCCESS);
      setSummeryList(value);
    }).onError((error, stackTrace){
      setRxRequestStatus(Status.ERROR);
      setError(error.toString());
      print("viewModel error ${error.toString()}");
    })*//*
;
  }
*/








}