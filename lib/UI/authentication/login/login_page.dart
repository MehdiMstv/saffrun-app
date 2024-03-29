import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:saffrun_app/constants/const.dart';
import 'package:saffrun_app/state_managment/authentication/auth_cubit.dart';

import 'theme_login_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: const Scaffold(
        body: LoginBody(),
      ),
    );
  }
}

class LoginBody extends StatelessWidget {
  const LoginBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FlutterLogin(
        onLogin: (LoginData) async {
          bool status = await BlocProvider.of<AuthCubit>(context)
              .loginHandler(LoginData.name, LoginData.password);
          if (status) {
            Navigator.pushReplacementNamed(context, HOME_PAGE_PATH);
          } else {
            return 'نام کاربری یا رمز عبور اشتباه است';
          }
        },
        onSignup: (LoginData) async {
          bool status = await BlocProvider.of<AuthCubit>(context)
              .signUpHandler(LoginData.name ?? "", LoginData.password ?? "");
          if (status) {
          } else {
            return 'ثبت نام با مشکل مواجه شده است';
          }
        },
        onRecoverPassword: (userName) async {
          bool status = await BlocProvider.of<AuthCubit>(context)
              .recoverPassword(userName);
          if (status) {
          } else {
            return "در ارسال مشکلی وجود دارد";
          }
        },
        title: 'صَفران',
        logo: 'assets/images/logo.png',
        theme: loginTheme,
        userValidator: (value) {
          if (value == "") {
            return "نام کاربری را وارد نمایید";
          }
        },
        passwordValidator: (value) {
          if (value == "") {
            return "رمزعبور را وارد نمایید";
          }
        },
        disableCustomPageTransformer: true,
        loginAfterSignUp: false,
        messages: LoginMessages(
          userHint: 'نام کاربری',
          passwordHint: 'رمز عبور',
          confirmPasswordHint: 'تایید رمزعبور',
          loginButton: 'ورود',
          signupButton: 'ثبت نام',
          forgotPasswordButton: 'فراموشی رمزعبور؟',
          recoverPasswordButton: 'ارسال رمز',
          goBackButton: 'برگشت',
          confirmPasswordError: 'کد تایید شباهت ندارد',
          recoverPasswordDescription:
              'برای فراموشی رمزعبور نام کاربری خود را وارد نمایید',
          recoverPasswordSuccess: 'رمز عبور با موفقیت بازگردانده شد',
          recoveryCodeHint: 'بازگردانی رمزعبور',
          recoverPasswordIntro: 'بازگردانی رمزعبور',
          signUpSuccess: 'ثبت نام با موفقیت انجام شد',
        ),
      ),
    );
  }
}
