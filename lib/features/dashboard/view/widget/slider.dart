import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlt_client_mobile/common/widget/error_widget.dart';
import 'package:mlt_client_mobile/common/widget/loading_screen.dart';
import 'package:mlt_client_mobile/core/utils/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../common/bloc/generic_bloc_state.dart';
import '../../../banner/bloc/banner_bloc.dart';
import '../../../banner/data/model/banner_model.dart';

class SliderImage extends StatelessWidget {
  SliderImage({super.key});
  final controller = PageController(viewportFraction: 0.8, keepPage: true);
  final indexPage = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    var bannerState = context.watch<BannerBloc>().state;
    return (switch (bannerState.status) {
      Status.loading => const SizedBox(),
      Status.empty =>
        Center(child: Text('empty', style: context.textStyleSmall)),
      Status.failure =>
        ErrorWidgetCustom(errorMessage: bannerState.error ?? ''),
      Status.success => SizedBox(
          width: context.sizeDevice.width,
          child: ValueListenableBuilder(
              valueListenable: indexPage,
              builder: (context, value, child) => Column(children: [
                    CarouselSlider.builder(
                        // carouselController: controller,
                        itemBuilder: (context, index, realIndex) =>
                            _buildItemBanner(bannerState.datas![index]),
                        itemCount: bannerState.datas!.length,
                        options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              indexPage.value = index;
                            },
                            height: context.sizeDevice.height * 0.2,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 1000),
                            autoPlayCurve: Curves.linearToEaseOut,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal)),
                    SizedBox(
                        height: context.sizeDevice.height * 0.02,
                        child:
                            _buildIndicator(context, bannerState.datas!.length))
                  ])))
    });
  }

  Widget _buildIndicator(BuildContext context, int length) {
    return AnimatedSmoothIndicator(
        activeIndex: indexPage.value,
        count: length,
        effect: SwapEffect(
            activeDotColor: context.colorScheme.secondary,
            dotHeight: 8,
            dotWidth: 8,
            type: SwapType.zRotation));
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
                child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: item.image,
                    placeholder: (context, url) => const LoadingScreen(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.photo_library_outlined)))));
  }
}
