import 'package:toast/toast.dart';

void showToastMessage(String message) {
  Toast.show(message, duration: 2, gravity: Toast.bottom);
}
