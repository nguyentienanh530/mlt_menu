import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_client_mobile/common/bloc/bloc_helper.dart';
import 'package:mlt_client_mobile/common/bloc/generic_bloc_state.dart';
import 'package:mlt_client_mobile/features/order/data/model/order_model.dart';
import 'package:mlt_client_mobile/features/order/data/provider/remote/order_repo.dart';
import 'package:order_repository/order_repository.dart';

part 'order_event.dart';

typedef Emit = Emitter<GenericBlocState<OrderModel>>;

class OrderBloc extends Bloc<OrderEvent, GenericBlocState<OrderModel>>
    with BlocHelper<OrderModel> {
  OrderBloc() : super(GenericBlocState.loading()) {
    on<OrderCreated>(_createOrder);
  }
  final _orderRepository = OrderRepo(
      orderRepository:
          OrderRepository(firebaseFirestore: FirebaseFirestore.instance));

  FutureOr<void> _createOrder(OrderCreated event, Emit emit) async {
    await createItem(
        _orderRepository.createOrder(orderModel: event.orderModel), emit);
  }
}
