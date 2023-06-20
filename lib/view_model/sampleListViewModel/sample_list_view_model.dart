import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/response/status.dart';
import '../../model/lab_test_model/simple_list_models.dart';
import '../../model/lab_test_model/status_model.dart';
import '../../repository/repository.dart';
import '../../repository/search_repository/SearchRepository.dart';
import '../../shere_preference/login_preference.dart';

class SampleListVeiewModel extends GetxController{
  LoginPreference loginPreference = LoginPreference();
  final _api = SearchRepository();
  final _repository = Repository();
  dynamic startDate = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;
  dynamic endDate = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;


  final sampleIdController = TextEditingController().obs;
  final invoNumController = TextEditingController().obs;

  final rxRequestStatus = Status.LOADING.obs;
  RxString error = ''.obs;
  final sampleListItem = SampleTest().obs;
  final sampleListFilterStatus = <StatusListModel>[].obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  void setError(String _value) => error.value = _value;

  void setSampleList(SampleTest _value) => sampleListItem.value = _value;
  void setSampleListFilterStatus(List<StatusListModel> _value) => sampleListFilterStatus.value = _value;

  /// get sample list data
  void getSampleListData({ statusId = 0,page ,serviceId })async {
    print("start date vm $startDate");
    print("end date vm $endDate");
    setRxRequestStatus(Status.LOADING);

    await loginPreference.getServiceId().then((value) => {
      serviceId = value.setviceId
    });
    print("service sample  $serviceId");
    await _api.getSampleListData(startDate, endDate, statusId, page, serviceId).then((value) {
      setRxRequestStatus(Status.SUCCESS);
      setSampleList(value);
    }).onError((error, stackTrace){
      setRxRequestStatus(Status.ERROR);
      setError(error.toString());
      print("viewModel error ${error.toString()}");
    });
  }


  //get sample and summery list filter status
  Future<List<StatusListModel>> getSampleListFilterStatus()async{

    // setRxRequestStatus(Status.LOADING);
    await  _repository.getSampleListFilterStatusData().then((value) {
      setRxRequestStatus(Status.SUCCESS);
      setSampleListFilterStatus(value);
    }).onError((error, stackTrace){
      setRxRequestStatus(Status.ERROR);
      setError(error.toString());
    });
    return sampleListFilterStatus;
  }



}