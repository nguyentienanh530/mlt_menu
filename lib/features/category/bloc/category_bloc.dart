import 'dart:async';

import 'package:category_repository/category_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_client_mobile/common/bloc/bloc_helper.dart';
import 'package:mlt_client_mobile/common/bloc/generic_bloc_state.dart';
import 'package:mlt_client_mobile/features/category/data/model/category_model.dart';
import 'package:mlt_client_mobile/features/category/data/provider/remote/category_repo.dart';

part 'category_event.dart';

typedef Emit = Emitter<GenericBlocState<CategoryModel>>;

class CategoryBloc extends Bloc<CategoryEvent, GenericBlocState<CategoryModel>>
    with BlocHelper<CategoryModel> {
  CategoryBloc() : super(GenericBlocState.loading()) {
    on<CategoryFetched>(_categoryFetch);
  }

  final _categoryRepository = CategoryRepo(
      CategoryRepository(firebaseFirestore: FirebaseFirestore.instance));

  FutureOr<void> _categoryFetch(CategoryFetched event, Emit emit) async {
    await getItems(_categoryRepository.getCategories(), emit);
  }
}
