import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:saffrun_app/data_managment/calendar/calendar_repository.dart';
import 'package:saffrun_app/models/event/event_modle.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  late CalendarRepository calendarRepository;

  CalendarCubit() : super(CalendarInitial()) {
    calendarRepository = CalendarRepository();
  }

  Future<void> selectDate(DateTime date) async {
    emit(CalendarSelectDate(date));
    try {
      List<Event> events = await calendarRepository.getEventOfDate(date);
      emit(CalendarLoadedData(date, events));
    } catch (e) {
      emit(CalendarErrorData(date: date));
    }
  }

  Future<Map<DateTime, List<dynamic>>> initCalendar() async {
    emit(CalendarLoadingDateEvent());
    try {
      dynamic days = await calendarRepository.getDateOfEvents();
      emit(CalendarLoadedDateEvent(days));
      return days;
    } catch (e) {
      emit(CalendarErrorData());
      return {};
    }
  }
}
