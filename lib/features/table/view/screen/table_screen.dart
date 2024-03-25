import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu_food/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_food/common/widget/empty_screen.dart';
import 'package:mlt_menu_food/common/widget/error_screen.dart';
import 'package:mlt_menu_food/common/widget/loading_screen.dart';
import 'package:mlt_menu_food/core/utils/utils.dart';
import 'package:mlt_menu_food/features/table/bloc/table_bloc.dart';
import 'package:mlt_menu_food/features/table/cubit/table_cubit.dart';
import 'package:mlt_menu_food/features/table/data/model/table_model.dart';

class TableScreen extends StatelessWidget {
  const TableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TableBloc()..add(TablesFetched()),
        child: const TableView());
  }
}

class TableView extends StatelessWidget {
  const TableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppbar(context), body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    var tableState = context.watch<TableBloc>().state;
    return (switch (tableState.status) {
      Status.loading => const LoadingScreen(),
      Status.empty => const EmptyScreen(),
      Status.failure => ErrorScreen(errorMsg: tableState.error),
      Status.success => _buildLoadingSuccess(tableState.datas ?? <TableModel>[])
    });
  }

  Widget _buildLoadingSuccess(List<TableModel> tables) {
    var sortTables = [...tables];
    sortTables.sort((a, b) => a.name.compareTo(b.name));
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
            itemCount: tables.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
            itemBuilder: (context, index) =>
                _buildItemTable(context, sortTables[index])));
  }

  Widget _buildItemTable(BuildContext context, TableModel table) {
    // final fToast = FToast()..init(context);
    return GestureDetector(
        onTap: () {
          context.read<TableCubit>().onTableChanged(table);
          context.pop();
          // if (!table.isUse) {
          //   context.read<TableCubit>().onTableChanged(table);
          //   context.pop();
          // } else {
          //   fToast.showToast(
          //       child: AppAlerts.errorToast(msg: 'Bàn đang được sử dụng'));
          // }
        },
        child: Card(
            color: table.isUse ? Colors.green.shade700 : null,
            child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildString(table.name),
                      _buildString(table.seats.toString()),
                      _buildString(Ultils.tableStatus(table.isUse))
                    ]))));
  }

  Widget _buildString(String value) => FittedBox(child: Text(value));

  _buildAppbar(BuildContext context) => AppBar(
      centerTitle: true,
      title: Text('Danh sách bàn', style: context.titleStyleMedium));
}
