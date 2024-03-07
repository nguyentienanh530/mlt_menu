part of 'order_bloc.dart';

class OrderEvent {}

final class OrderCreated extends OrderEvent {
  final OrderModel orderModel;

  OrderCreated({required this.orderModel});
}
