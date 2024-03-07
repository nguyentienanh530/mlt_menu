part of 'table_bloc.dart';

class TableEvent {}

final class TablesFetched extends TableEvent {}

final class TableUpdated extends TableEvent {
  final TableModel tableModel;

  TableUpdated({required this.tableModel});
}
