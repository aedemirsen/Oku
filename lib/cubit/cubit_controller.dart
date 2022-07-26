import 'package:bloc/bloc.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/core/service/IService.dart';

import '../core/model/record.dart';

class CubitController extends Cubit<AppState> {
  //service
  final IService service;

  ///API related variables ----------------- ///

  //received data
  List<Record> records = [];

  ///categories
  List<String> categories = [];

  ///groups
  List<String> groups = [];

  //filters
  String? selectedCategory;

  String? selectedGroup;

  ///last reached data's id
  int cursor = -1;

  ///order by id - last records id is the biggest
  ///Default = last record show at first
  String orderBy = 'desc';

  ///is there any data left to get from server?
  bool hasMoreData = true;

  ///---------END OF API RELATED VARIABLES---------///

  ///filter screen visibility
  bool isFilterScreenVisible = false;

  ///record open/closed
  bool isRecordOpen = false;

  ///selected page - default --> home page
  int pageIndex = 0;

  ///data loading
  bool recordsLoading = false;

  ///scroll loading
  bool recordsLoadingScroll = false;

  CubitController({required this.service}) : super(InitState()) {
    conf.Session.controller!.addListener(getRecordsOnScroll);
  }

  ///SERVICE CALLS
  Future<void> getRecords() async {
    changeRecordsLoading(true);
    final data = await service.getRecords({
      'category': selectedCategory,
      'group': selectedGroup,
      'orderby': orderBy,
      'start': cursor,
      'limit': conf.AppConfig.requestedDataQuantity,
    });
    changeRecordsLoading(false);
    if (data.isNotEmpty) {
      records.addAll(data);
      cursor = records.last.id!;
      emit(RecordsSuccess(data));
      if (data.length < conf.AppConfig.requestedDataQuantity) {
        changeMoreDataStatus(false);
      }
    } else {
      emit(RecordsFail());
    }
  }

  ///get records on scroll
  void getRecordsOnScroll() async {
    if (hasMoreData &&
        conf.Session.controller!.position.extentAfter < 300 &&
        recordsLoadingScroll == false) {
      changeRecordsScrollLoading(true);
      final data = await service.getRecords({
        'category': selectedCategory,
        'group': selectedGroup,
        'orderby': orderBy,
        'start': cursor,
        'limit': conf.AppConfig.requestedDataQuantity,
      });
      changeRecordsScrollLoading(false);
      if (data.isNotEmpty) {
        records.addAll(data);
        cursor = records.last.id ?? 0;
        emit(RecordsSuccess(data));
        if (data.length < conf.AppConfig.requestedDataQuantity) {
          changeMoreDataStatus(false);
        }
      }
    }
  }

  ///get all categories - run at startup
  Future<void> getCategories() async {
    final data = await service.getAllCategories();
    if (data.isNotEmpty) {
      categories = data as List<String>;
    }
  }

  ///get all groups - run at startup
  Future<void> getGroups() async {
    final data = await service.getAllGroups();
    if (data.isNotEmpty) {
      groups = data as List<String>;
    }
  }

  ///search by filter
  void searchByFilter() async {
    cursor = -1;
    records = [];
    hasMoreData = true;
    await getRecords();
  }

  ///change filter
  void changeSelectedCategory(String? s) {
    selectedCategory = s;
    emit(FilterSelected());
  }

  void changeSelectedGroup(String? s) {
    selectedGroup = s;
    emit(FilterSelected());
  }

  ///change order
  void changeOrder() async {
    cursor = -1;
    orderBy = orderBy == 'asc' ? 'desc' : 'asc';
    records = [];
    hasMoreData = true;
    await getRecords();
  }

  ///SERVICE CALLS END

  ///delete
  Future<bool> deleteRecord(String id) {
    return service.deleteRecord(id);
  }

  ///post
  Future<String> postRecord(Record record) {
    return service.postRecord(record);
  }

  ///change page
  void changePage(int i) {
    pageIndex = i;
    emit(PageChangedState(pageIndex));
  }

  ///filter screen change visibility
  void changeFilterScreenVisibility(bool b) {
    isFilterScreenVisible = b;
    emit(FilterScreenVisibility(isFilterScreenVisible));
  }

  ///change hasMoreData property
  void changeMoreDataStatus(bool b) {
    hasMoreData = b;
    emit(HasMoreData(hasMoreData));
  }

  //record open state change
  void changeRecordState(bool b) {
    isRecordOpen = b;
    emit(RecordStateChanged(isRecordOpen));
  }

  ///record loading state change
  void changeRecordsLoading(bool b) {
    recordsLoading = b;
    emit(RecordsLoadingState(recordsLoading));
  }

  ///record scroll loading state change
  void changeRecordsScrollLoading(bool b) {
    recordsLoadingScroll = b;
    emit(RecordsLoadingScrollState(recordsLoadingScroll));
  }
}

abstract class AppState {}

class NotifyPipe extends AppState {}

class InitState extends AppState {}

///page state
class PageChangedState extends AppState {
  final int pageIndex;

  PageChangedState(this.pageIndex);
}

///visibility states
class FilterScreenVisibility extends AppState {
  final bool isVisible;

  FilterScreenVisibility(this.isVisible);
}

///Filter selected
class FilterSelected extends AppState {}

///record state
class RecordStateChanged extends AppState {
  final bool isRecordOpen;

  RecordStateChanged(this.isRecordOpen);
}

///records loading state
class RecordsLoadingState extends AppState {
  final bool isLoading;

  RecordsLoadingState(this.isLoading);
}

///records loading state
class RecordsLoadingScrollState extends AppState {
  final bool isLoading;

  RecordsLoadingScrollState(this.isLoading);
}

///records get success
class RecordsSuccess extends AppState {
  final List<Record> records;

  RecordsSuccess(this.records);
}

///records get fails
class RecordsFail extends AppState {}

///Has more data on server
class HasMoreData extends AppState {
  final bool hasMoreData;

  HasMoreData(this.hasMoreData);
}

///Order Changed State
class OrderChangedState extends AppState {
  final String orderBy;

  OrderChangedState(this.orderBy);
}
