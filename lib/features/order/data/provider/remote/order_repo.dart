import 'package:mlt_menu_food/common/firebase/firebase_base.dart';
import 'package:mlt_menu_food/features/order/data/model/order_model.dart';
import 'package:order_repository/order_repository.dart';

import '../../../../../common/firebase/firebase_result.dart';

class OrderRepo extends FirebaseBase<OrderModel> {
  final OrderRepository _orderRepository;

  OrderRepo({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Future<FirebaseResult<bool>> createOrder(
      {required OrderModel orderModel}) async {
    return await createItem(
        _orderRepository.createOrder(dataJson: orderModel.toJson()));
  }
}
