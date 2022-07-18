import 'package:bloc/bloc.dart';
import 'package:yazilar/core/service/IService.dart';

import '../core/model/record.dart';

class CubitController extends Cubit<AppState> {
  CubitController({required this.service}) : super(InitState());

  //service
  final IService service;

  //received data
  List<Record> records = [];

  //filter screen visibility
  bool isFilterScreenVisible = false;
  //record open/closed
  bool isRecordOpen = false;
  //selected page - default --> home page
  int pageIndex = 0;

  //data loading
  bool recordsLoading = false;

  //SERVICE CALLS
  //get
  Future<void> getRecords() async {
    changeRecordsLoading(true);
    final data = await service.getRecords();
    changeRecordsLoading(false);
    if (data.isNotEmpty) {
      records = data;
      emit(RecordsSuccess(data));
    } else {
      emit(RecordsFail());
    }
  }

  //delete
  Future<bool> deleteRecord(String id) {
    return service.deleteRecord(id);
  }

  //post
  Future<String> postRecord(Record record) {
    return service.postRecord(record);
  }

  //change page
  void changePage(int i) {
    pageIndex = i;
    emit(PageChangedState(pageIndex));
  }

  //filter screen change visibility
  void changeFilterScreenVisibility(bool b) {
    isFilterScreenVisible = b;
    emit(FilterScreenVisibility(isFilterScreenVisible));
  }

  //record open state change
  void changeRecordState(bool b) {
    isRecordOpen = b;
    emit(RecordStateChanged(isRecordOpen));
  }

  //record loading state change
  void changeRecordsLoading(bool b) {
    recordsLoading = b;
    emit(RecordsLoadingState(recordsLoading));
  }
}

abstract class AppState {}

class InitState extends AppState {}

//page state
class PageChangedState extends AppState {
  final int pageIndex;

  PageChangedState(this.pageIndex);
}

//visibility states
class FilterScreenVisibility extends AppState {
  final bool isVisible;

  FilterScreenVisibility(this.isVisible);
}

//record state
class RecordStateChanged extends AppState {
  final bool isRecordOpen;

  RecordStateChanged(this.isRecordOpen);
}

//records loading state
class RecordsLoadingState extends AppState {
  final bool isLoading;

  RecordsLoadingState(this.isLoading);
}

//records get success
class RecordsSuccess extends AppState {
  final List<Record> records;

  RecordsSuccess(this.records);
}

//records get fails
class RecordsFail extends AppState {}
