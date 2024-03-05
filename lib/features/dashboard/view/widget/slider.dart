import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_menu/common/widget/loading_screen.dart';
import 'package:mlt_menu/core/utils/utils.dart';
import '../../../../common/bloc/generic_bloc_state.dart';
import '../../../banner/bloc/banner_bloc.dart';
import '../../../banner/data/model/banner_model.dart';

class SliderImage extends StatelessWidget {
  const SliderImage({super.key});

  @override
  Widget build(BuildContext context) {
    var bannerState = context.watch<BannerBloc>().state;
    return (switch (bannerState.status) {
      Status.loading => const LoadingScreen(),
      Status.empty => Center(child: Text('', style: context.textStyleSmall)),
      Status.failure =>
        Center(child: Text(bannerState.error!, style: context.textStyleSmall)),
      Status.success => SizedBox(
          width: context.sizeDevice.width,
          height: context.sizeDevice.height * 0.20,
          child: CarouselSlider(
              options: CarouselOptions(
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                  autoPlayCurve: Curves.linearToEaseOut,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal),
              items: bannerState.datas!
                  .map((item) => _buildItemBanner(item))
                  .toList()))
    });
  }

  Widget _buildItemBanner(BannerModel item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Card(
          child: Container(
              width: double.infinity,
              // margin: EdgeInsets.symmetric(horizontal: defaultPadding),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(16)),
              clipBehavior: Clip.hardEdge,
              child: Image.network(item.image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                          ? child
                          : const LoadingScreen()))),
    );
  }
}
