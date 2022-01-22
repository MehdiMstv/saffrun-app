import 'package:intl/intl.dart' as intl;
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:saffrun_app/constants/const.dart';

import '../../models/user/user_2.dart';

String getImageUrl() {
  if (DefaultImage == UserProfile.userLogin.image) return DefaultImage;
  if (UserProfile.userLogin.image.contains("saffrun.mehdi-mostafavi.ir")) {
    return UserProfile.userLogin.image;
  }
  return "https://saffrun.mehdi-mostafavi.ir" + UserProfile.userLogin.image;
}

String getImageUrlUsers(String url) {
  if (DefaultImage == url) return DefaultImage;
  return "https://saffrun.mehdi-mostafavi.ir" + url;
}

DateTime getTime(String time) {
  print(time);
  DateTime date = DateTime.parse(time);
  return date.toLocal();
}

bool isRTL(String text) {
  return intl.Bidi.detectRtlDirectionality(text);
}

String formatTimeString(DateTime dateTime) {
  Jalali date = Jalali.fromDateTime(dateTime);
  var f = date.formatter;
  var hour = '0' + dateTime.hour.toString();
  var minute = '0' + dateTime.minute.toString();

  return f.dd +
      ' ' +
      f.mN +
      ' ' +
      f.yyyy +
      ' | ' +
      (hour).substring(hour.length - 2, hour.length) +
      ':' +
      (minute).substring(minute.length - 2, minute.length);
}

String getDateForm(DateTime dateTime) {
  Jalali date = Jalali.fromDateTime(dateTime);
  var f = date.formatter;
  return f.dd + ' ' + f.mN + ' ' + f.yyyy;
}

String formatTimeReserveString(DateTime dateTime) {
  Jalali date = Jalali.fromDateTime(dateTime);
  var f = date.formatter;
  return dateTime.hour.toString() + ':' + dateTime.minute.toString();
}

String formatDateReserveString(DateTime dateTime) {
  Jalali date = Jalali.fromDateTime(dateTime);
  var f = date.formatter;
  return f.dd + ' ' + f.mN + ' ' + f.yyyy;
}

String getDateForCircle(DateTime dateTime) {
  Jalali date = Jalali.fromDateTime(dateTime);
  var f = date.formatter;
  return f.dd + ' ' + f.mN;
}
