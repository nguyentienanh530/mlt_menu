import 'package:mlt_menu/common/firebase/firebase_base.dart';
import 'package:mlt_menu/features/print/data/model/print_model.dart';
import 'package:print_repository/print_repository.dart';

import '../../../../../common/firebase/firebase_result.dart';

class PrintRepo extends FirebaseBase<PrintModel> {
  final PrintRepository _printRepository;

  PrintRepo({required PrintRepository printRepository})
      : _printRepository = printRepository;

  Future<FirebaseResult<List<PrintModel>>> getPrints() async {
    return await getItems(
        await _printRepository.getPrints(), PrintModel.fromJson);
  }
}
