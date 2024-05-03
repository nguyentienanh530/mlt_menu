import 'package:mlt_client_mobile/common/firebase/firebase_base.dart';
import 'package:mlt_client_mobile/features/table/data/model/table_model.dart';
import 'package:table_repository/table_repository.dart';

import '../../../../../common/firebase/firebase_result.dart';

class TableRepo extends FirebaseBase<TableModel> {
  final TableRepository _tableRepository;

  TableRepo({required TableRepository tableRepository})
      : _tableRepository = tableRepository;

  Future<FirebaseResult<List<TableModel>>> getTables() async {
    return await getItems(
        await _tableRepository.getAllTable(), TableModel.fromJson);
  }

  Future<FirebaseResult<bool>> updateTable({required TableModel table}) async {
    return await updateItem(
        _tableRepository.updateStatusTable(dataJson: table.toJson()));
  }
}
