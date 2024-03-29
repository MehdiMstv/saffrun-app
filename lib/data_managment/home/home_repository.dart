import 'package:saffrun_app/data_managment/home/home_networkservice.dart';

import '../../models/admin/admin_model.dart';
import '../../models/event/event_model.dart';
import '../../models/reserve/reserve.dart';

class HomeRepository {
  late HomeNetworkService homeNetworkService;

  HomeRepository() {
    homeNetworkService = HomeNetworkService();
  }

  Future<Map<String, dynamic>> fetchHomePageRepository() async {
    try {
      dynamic result = await homeNetworkService.getHomePageFromServer();
      if (result == null) {
        return {'events': <Event>[], 'reserves': <Reserve>[]};
      }
      print(result);
      List<Event> events = Event.fromJsonListEvents(result['list_event']);
      List<Reserve> reserves =
          Reserve.fromJsonListHomePage(result['list_reserve']);
      return {'events': events, 'reserves': reserves};
    } catch (e) {
      print(e);
      return {'events': <Event>[], 'reserves': <Reserve>[]};
    }
  }

  Future<Map<String, dynamic>> getOfferList() async {
    try {
      dynamic result = await homeNetworkService.getOfferPageFromServer();
      print(result);
      if (result == null) {
        return {'events': <Event>[], 'businesses': <Reserve>[]};
      }
      print(result);
      List<Event> events = Event.fromJsonListEvents(result['events']);
      List<Admin> reserves = Admin.fromJsonList(result['businesses']);
      return {'events': events, 'businesses': reserves};
    } catch (e) {
      print(e);
      return {'events': <Event>[], 'businesses': <Reserve>[]};
    }
  }
}
