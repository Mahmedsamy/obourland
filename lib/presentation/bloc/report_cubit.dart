import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/report_repository.dart';
import '../../data/models/report_model.dart';


part 'report_state.dart';


class ReportCubit extends Cubit<ReportState> {
  final ReportRepository _repo;
  ReportCubit(this._repo) : super(ReportInitial());


  Future<void> submit(ReportModel model) async {
    emit(ReportLoading());
    try {
      await _repo.submitReport(model);
      emit(ReportSuccess());
    } catch (e) {
      emit(ReportFailure(e.toString()));
    }
  }
}