import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_food/common/bloc/bloc_helper.dart';
import 'package:mlt_menu_food/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_food/features/table/data/model/table_model.dart';
import 'package:mlt_menu_food/features/table/data/provider/remote/table_repo.dart';
import 'package:table_repository/table_repository.dart';

part 'table_event.dart';

typedef Emit = Emitter<GenericBlocState<TableModel>>;

class TableBloc extends Bloc<TableEvent, GenericBlocState<TableModel>>
    with BlocHelper<TableModel> {
  TableBloc() : super(GenericBlocState.loading()) {
    on<TablesFetched>(_getTables);
    on<TableUpdated>(_updateTable);
  }
  final _tableRepository = TableRepo(
      tableRepository:
          TableRepository(firebaseFirestore: FirebaseFirestore.instance));

  FutureOr<void> _getTables(TablesFetched event, Emit emit) async {
    await getItems(_tableRepository.getTables(), emit);
  }

  FutureOr<void> _updateTable(TableUpdated event, Emit emit) async {
    await updateItem(
        _tableRepository.updateTable(table: event.tableModel), emit);
  }
}
