import 'package:saffrun_app/data_managment/reserve/reserve_networkservice.dart';
import 'package:saffrun_app/models/reserve/reserve.dart';

class ReserveRepository {
  late ReserveNetworkService reserveNetworkService;

  ReserveRepository() {
    reserveNetworkService = ReserveNetworkService();
  }

  Future<Map<String, dynamic>> getTimesForReserve(int adminId) async {
    try {
      // await Future.delayed(Duration(seconds: 1));
      dynamic result = await reserveNetworkService.getReserveTime(adminId);
      if (result == null || result["nearest"] == "")
        throw Exception();
      Reserve nearest = Reserve.fromNearest(result['nearest'], adminId);
      List<List<Reserve>> reserves = Reserve.fromJsonOfNextSeven(
          result['next_seven_days'], adminId, nearest.id);
      return {'nearest': nearest, 'list_reserve': reserves};
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> sendReserveId(int id) async {
    await reserveNetworkService.sendReserveId(id);
    return true;
  }
}
