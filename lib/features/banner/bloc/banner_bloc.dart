import 'dart:async';

import 'package:mlt_menu_food/common/bloc/bloc_helper.dart';
import 'package:mlt_menu_food/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_food/features/banner/data/model/banner_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu_food/features/banner/data/provider/remote/banner_repo.dart';
part 'banner_event.dart';

typedef Emit = Emitter<GenericBlocState<BannerModel>>;

class BannerBloc extends Bloc<BannerEvent, GenericBlocState<BannerModel>>
    with BlocHelper<BannerModel> {
  BannerBloc() : super(GenericBlocState.loading()) {
    on<BannerFecthed>(_bannerFetch);
  }

  final _bannerRepository = BannerRepo();

  FutureOr<void> _bannerFetch(BannerFecthed event, Emit emit) async {
    await getItems(_bannerRepository.getBanners(), emit);
  }
}
