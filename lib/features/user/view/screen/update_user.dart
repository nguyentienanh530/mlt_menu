import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mlt_client_mobile/features/user/cubit/user_cubit.dart';
import '../../../../common/bloc/generic_bloc_state.dart';
import '../../../../common/dialog/app_alerts.dart';
import '../../../../common/dialog/progress_dialog.dart';
import '../../../../common/dialog/retry_dialog.dart';
import '../../../../common/widget/common_text_field.dart';
import '../../../../common/widget/loading_screen.dart';
import '../../bloc/user_bloc.dart';
import '../../../../core/utils/utils.dart';
import '../../data/model/user_model.dart';

enum Type { create, update }

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key, required this.user});
  final UserModel user;

  @override
  State<UpdateUser> createState() => _UpdateUserDialogState();
}

class _UpdateUserDialogState extends State<UpdateUser> {
  String userName = '';
  String email = "";
  String _image = '';
  String uid = '';
  String? phoneNumber = '';
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  var _imageFile;
  var _isLoading = false;

  @override
  void initState() {
    userName = widget.user.name;
    email = widget.user.email;
    _image = widget.user.image;
    uid = widget.user.id!;
    phoneNumber = widget.user.phoneNumber.toString();
    nameCtrl.text = userName;
    phoneCtrl.text = phoneNumber == '0' ? '' : phoneNumber!;
    super.initState();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(),
        body: SafeArea(
            child: !_isLoading
                ? Form(
                    key: _formKey,
                    child: Column(
                        children: [
                      Expanded(
                          child: SingleChildScrollView(
                              child: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Stack(children: [
                                          _buildImageProfile(),
                                          _buildIconEditImage()
                                        ]),
                                        const SizedBox(height: 15),
                                        _Name(nameCtrl: nameCtrl),
                                        const SizedBox(height: 15),
                                        _PhoneNumber(phoneCtrl: phoneCtrl),
                                        const SizedBox(height: 25),
                                      ])))),
                      Container(
                          padding: EdgeInsets.all(defaultPadding),
                          height: 80,
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () => _handleUpdateUser(),
                              child: Text("Cập nhật",
                                  style: context.titleStyleMedium!
                                      .copyWith(fontWeight: FontWeight.bold))))
                    ]
                            .animate(interval: 50.ms)
                            .slideX(
                                begin: -0.1,
                                end: 0,
                                curve: Curves.easeInOutCubic,
                                duration: 500.ms)
                            .fadeIn(
                                curve: Curves.easeInOutCubic,
                                duration: 500.ms)))
                : Center(
                    child: SpinKitCircle(
                        color: context.colorScheme.secondary, size: 30))));
  }

  Widget _buildIconEditImage() {
    return Positioned(
        top: context.sizeDevice.width * 0.3 - 25,
        left: (context.sizeDevice.width * 0.3 - 20) / 2,
        child: GestureDetector(
            onTap: () async => await pickImage().then((value) => setState(() {
                  _imageFile = value;
                })),
            child: const Icon(Icons.camera_alt_rounded)));
  }

  bool existImage() {
    var exist = false;
    if (_imageFile != null || _image.isNotEmpty) {
      exist = true;
    } else {
      exist = false;
    }
    return exist;
  }

  void _handleUpdateUser() async {
    bool isValid = _formKey.currentState?.validate() ?? false;
    var toast = FToast()..init(context);
    if (isValid && existImage()) {
      setState(() {
        _isLoading = true;
      });
      if (_imageFile != null) {
        _image = await uploadImage(path: 'profile', file: _imageFile);
      }

      var newUser = widget.user.copyWith(
          image: _image, name: nameCtrl.text, phoneNumber: phoneCtrl.text);
      logger.i(newUser);
      updateUser(newUser);
    } else {
      toast.showToast(
          child: AppAlerts.errorToast(msg: 'Chưa nhập đủ thông tin!'));
    }
  }

  updateUser(UserModel user) {
    context.read<UserBloc>().add(UserUpdated(user: user));
    showDialog(
        context: context,
        builder: (context) =>
            BlocBuilder<UserBloc, GenericBlocState<UserModel>>(
                builder: (context, state) => switch (state.status) {
                      Status.empty => const SizedBox(),
                      Status.loading => const SizedBox(),
                      Status.failure => RetryDialog(
                          title: state.error ?? "Error",
                          onRetryPressed: () => context
                              .read<UserBloc>()
                              .add(UserUpdated(user: user))),
                      Status.success => ProgressDialog(
                          descriptrion: "Cập nhật thành công!",
                          onPressed: () {
                            context.read<UserCubit>().onUserChanged(user);
                            setState(() {
                              _isLoading = false;
                            });
                            pop(context, 2);
                          },
                          isProgressed: false)
                    }));
  }

  Widget _buildImageProfile() {
    return _imageFile == null
        ? Container(
            height: context.sizeDevice.width * 0.3,
            width: context.sizeDevice.width * 0.3,
            decoration: BoxDecoration(
                border: Border.all(color: context.colorScheme.primary),
                shape: BoxShape.circle),
            child: Container(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.all(1),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: _image,
                  placeholder: (context, url) => const LoadingScreen(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.photo_library_outlined)),
            ))
        : Container(
            height: context.sizeDevice.width * 0.3,
            width: context.sizeDevice.width * 0.3,
            decoration: BoxDecoration(
                border: Border.all(color: context.colorScheme.primary),
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover, image: FileImage(_imageFile!))));
  }

  _buildAppbar() => AppBar(
      title: Text('Cập nhật thông tin',
          style:
              context.titleStyleMedium!.copyWith(fontWeight: FontWeight.bold)),
      centerTitle: true);
}

class _PhoneNumber extends StatelessWidget {
  final TextEditingController phoneCtrl;

  const _PhoneNumber({required this.phoneCtrl});
  @override
  Widget build(BuildContext context) {
    return CommonTextField(
        keyboardType: TextInputType.phone,
        controller: phoneCtrl,
        prefixIcon: const Icon(Icons.phone_android_rounded),
        hintText: "Số điện thoại",
        onChanged: (String value) {
          phoneCtrl.text = value;
        },
        validator: (String? value) {
          if (value!.contains(RegExp(r'^[0-9]+$'))) {
            return null;
          }
          return "Số điện thoại không hợp lệ";
        });
  }
}

class _Name extends StatelessWidget {
  final TextEditingController nameCtrl;

  const _Name({required this.nameCtrl});
  @override
  Widget build(BuildContext context) {
    return CommonTextField(
        controller: nameCtrl,
        hintText: "Họ và tên",
        prefixIcon: const Icon(Icons.person),
        onChanged: (String value) {
          nameCtrl.text = value;
        },
        validator: (String? value) {
          if (value!.isNotEmpty) return null;
          return "Tên không được để trống!";
        });
  }
}
