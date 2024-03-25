import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_food/features/table/data/model/table_model.dart';

class TableCubit extends Cubit<TableModel> {
  TableCubit() : super(TableModel());

  onTableChanged(TableModel newTable) => emit(newTable);
  onTableClear() => emit(TableModel());
}
