import 'package:bloc/bloc.dart';

class CubitController extends Cubit<AppState> {
  CubitController() : super(InitState());

  //filter screen visibility
  bool isFilterScreenVisible = false;
  //record open/closed
  bool isRecordOpen = false;

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
