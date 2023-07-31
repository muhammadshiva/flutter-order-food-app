import 'package:bloc/bloc.dart';
import 'package:flutter_order_app/model/voucher_model.dart';
import 'package:flutter_order_app/repositories/order_repository.dart';
import 'package:meta/meta.dart';

part 'voucher_event.dart';
part 'voucher_state.dart';

class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  VoucherBloc() : super(VoucherInitial()) {
    on<VoucherEvent>((event, emit) async {
      if (event is Voucher) {
        try {
          emit(VoucherLoading());

          // final data = await OrderRepository().fetchVoucher(event.kode);

          final data = await OrderRepository().fetchVoucher(event.kode);

          emit(VoucherSuccess(data));
        } catch (e) {
          emit(VoucherFailed(e.toString()));
        }
      }
    });
  }
}
