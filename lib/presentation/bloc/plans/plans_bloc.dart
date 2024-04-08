import 'package:bloc/bloc.dart';
import 'package:medace_app/data/models/purchase/all_plans_response.dart';
import 'package:medace_app/data/repository/purchase_repository.dart';
import 'package:meta/meta.dart';

part 'plans_event.dart';

part 'plans_state.dart';

class PlansBloc extends Bloc<PlansEvent, PlansState> {
  PlansBloc() : super(InitialPlansState()) {
    on<FetchEvent>((event, emit) async {
      var response = await _repository.getPlans();
      emit(LoadedPlansState(response));
    });
  }

  final PurchaseRepository _repository = PurchaseRepositoryImpl();
}
