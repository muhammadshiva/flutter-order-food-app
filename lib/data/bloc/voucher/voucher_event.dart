part of 'voucher_bloc.dart';

@immutable
abstract class VoucherEvent {}

// ignore: must_be_immutable
class Voucher extends VoucherEvent {
  String kode;
  Voucher(this.kode);
}
