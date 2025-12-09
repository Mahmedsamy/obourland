import '../../core/network/dio_helper.dart';
import '../models/report_model.dart';


class ReportRepository {
  Future<void> submitReport(ReportModel model) async {
    await DioHelper.post('/reports/submit', data: model.toJson());
  }
}