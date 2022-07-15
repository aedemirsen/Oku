import 'package:bloc/bloc.dart';

class CubitController extends Cubit<AppState> {
  CubitController() : super(InitState());

  //filter screen visibility
  bool isFilterScreenVisible = false;
  //record open/closed
  bool isRecordOpen = false;
  //selected page - default --> home page
  int pageIndex = 0;

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
