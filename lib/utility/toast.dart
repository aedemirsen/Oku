import 'package:toast/toast.dart';

void showToastMessage(String message) {
  Toast.show(message, duration: 3, gravity: Toast.bottom);
}
