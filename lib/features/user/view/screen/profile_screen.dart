import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_client_mobile/common/widget/loading_screen.dart';
import 'package:mlt_client_mobile/features/print/cubit/is_use_print_cubit.dart';
import 'package:mlt_client_mobile/features/print/data/print_data_source/print_data_source.dart';
import 'package:mlt_client_mobile/features/user/cubit/user_cubit.dart';

import '../../../../common/widget/common_bottomsheet.dart';
import '../../../../core/config/config.dart';
import '../../../../core/utils/utils.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../bloc/user_bloc.dart';
import '../../data/model/user_model.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, required this.userModel});
  final UserModel userModel;
  var isUsePrint = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppbar(context), body: _buildBody(context));
  }

  _buildAppbar(BuildContext context) => AppBar(
      centerTitle: true,
      title: Text('Thông tin', style: context.titleStyleMedium));

  Widget _buildBody(BuildContext context) {
    return Builder(builder: (context) {
      var a = context.select((UserCubit userCubit) => userCubit).state;
      logger.d(a);
      return SafeArea(
          child: Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: _buildListAction(context, a)));
    });
  }

  Widget _buildListAction(BuildContext context, UserModel user) {
    return ListView(
        shrinkWrap: true,
        children: [
          _CardProfife(user: user),
          Column(children: [
            _ItemProfile(
                svgPath: 'assets/icon/user_config.svg',
                title: 'Cập nhật thông tin',
                onTap: () => _handleUserUpdated(context, user)),
            _ItemProfile(
                svgPath: 'assets/icon/lock.svg',
                title: 'Đổi mật khẩu',
                onTap: () => context.push(RouteName.changePassword)),
            _buildItemPrint(context),
            _ItemProfile(
                svgPath: 'assets/icon/logout.svg',
                title: 'Đăng xuất',
                onTap: () => _handleLogout(context))
          ])
        ]
            .animate(interval: 50.ms)
            .slideX(
                begin: -0.1,
                end: 0,
                curve: Curves.easeInOutCubic,
                duration: 500.ms)
            .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms));
  }

  Widget _buildItemPrint(BuildContext context) {
    var isUsePrint = context.watch<IsUsePrintCubit>().state;

    return Column(children: [
      GestureDetector(
          onTap: () {},
          child: Card(
              child: SizedBox(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                Row(children: [
                  Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: SvgPicture.asset('assets/icon/print.svg',
                          colorFilter: ColorFilter.mode(
                              context.colorScheme.primary, BlendMode.srcIn))),
                  const Text('Sử dụng máy in')
                ]),
                Transform.scale(
                    scale: 0.8,
                    child: Switch(
                        activeTrackColor: context.colorScheme.secondary,
                        value: isUsePrint,
                        onChanged: (value) {
                          context
                              .read<IsUsePrintCubit>()
                              .onUsePrintChanged(value);
                          PrintDataSource.setIsUsePrint(value);
                        }))
              ])))),
      isUsePrint
          ? _ItemProfile(
              svgPath: 'assets/icon/file_setting.svg',
              title: 'Cấu hình máy in',
              onTap: () => context.push(RouteName.printSeting))
          : const SizedBox()
    ]);
  }

  _handleUserUpdated(BuildContext context, UserModel user) {
    context.push<bool>(RouteName.updateUser, extra: user);
  }

  refreshUserData(BuildContext context) {
    var userID = context.read<AuthBloc>().state.user.id;
    context.read<UserBloc>().add(UserFecthed(userID: userID));
  }

  _handleLogout(BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (context) => CommonBottomSheet(
            title: 'Chắc chắn muốn đăng xuất?',
            textCancel: 'Hủy',
            textConfirm: 'Đăng xuất',
            textConfirmColor: context.colorScheme.errorContainer,
            onConfirm: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              context.go(RouteName.login);
            }));
  }
}

class _ItemProfile extends StatelessWidget {
  const _ItemProfile(
      {required this.svgPath, required this.title, required this.onTap});
  final String svgPath;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
            child: SizedBox(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
              Row(children: [
                Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: SvgPicture.asset(svgPath,
                        colorFilter: ColorFilter.mode(
                            context.colorScheme.primary, BlendMode.srcIn))),
                Text(title)
              ]),
              Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: const Icon(Icons.arrow_forward_ios_rounded, size: 15))
            ]))));
  }
}

class _CardProfife extends StatelessWidget {
  const _CardProfife({required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: defaultPadding),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // user.image.isEmpty
              //     ? _buildImageAsset(context)
              //     : _buildImageNetwork(context),
              _buildImageNetwork(context),
              SizedBox(height: defaultPadding),
              Text(user.name),
              SizedBox(height: defaultPadding / 4),
              _buildItem(context, Icons.email_rounded, user.email),
              SizedBox(height: defaultPadding / 4),
              user.phoneNumber.isEmpty
                  ? const SizedBox()
                  : _buildItem(context, Icons.phone_android_rounded,
                      user.phoneNumber.toString())
            ])));
  }

  Widget _buildImageNetwork(BuildContext context) {
    return Container(
        height: context.sizeDevice.width * 0.2,
        width: context.sizeDevice.width * 0.2,
        decoration: BoxDecoration(
            border: Border.all(color: context.colorScheme.primary),
            shape: BoxShape.circle),
        child: Container(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.all(1),
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: user.image,
              placeholder: (context, url) => const LoadingScreen(),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.photo_library_outlined)),
        ));
  }

  Widget _buildItem(BuildContext context, IconData icon, String title) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 15),
      const SizedBox(width: 3),
      Text(title, style: TextStyle(color: Colors.white.withOpacity(0.5)))
    ]);
  }
}
