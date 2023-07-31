part of 'voucher_bloc.dart';

@immutable
abstract class VoucherState {}

class VoucherInitial extends VoucherState {}

class VoucherLoading extends VoucherState {}

class VoucherFailed extends VoucherState {
  final String e;
  VoucherFailed(this.e);
}

class VoucherSuccess extends VoucherState {
  final List<VoucherModel> voucher;
  VoucherSuccess(this.voucher);
}
