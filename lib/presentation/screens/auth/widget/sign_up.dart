import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medace_app/core/utils/utils.dart';
import 'package:medace_app/main.dart';
import 'package:medace_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:medace_app/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:medace_app/presentation/screens/auth/components/google_signin.dart';
import 'package:medace_app/presentation/screens/auth/widget/socials_widget.dart';
import 'package:medace_app/presentation/screens/main_screens.dart';
import 'package:medace_app/presentation/widgets/alert_dialogs.dart';
import 'package:medace_app/presentation/widgets/flutter_toast.dart';
import 'package:medace_app/presentation/widgets/loader_widget.dart';
import 'package:medace_app/theme/app_color.dart';
import 'package:medace_app/theme/const_dimensions.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _loginController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _focusNode = FocusNode();

  bool passwordVisible = true;
  bool enableInputs = true;

  @override
  void dispose() {
    _loginController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // SignUpState
        if (state is SuccessSignUpState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Navigator.pushReplacementNamed(
              context,
              MainScreen.routeName,
              arguments: MainScreenArgs(selectedIndex: 4),
            ),
          );
        }

        if (state is ErrorSignUpState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => showFlutterToast(title: state.message),
          );
        }

        // DemoAuthState
        if (state is SuccessDemoAuthState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Navigator.pushReplacementNamed(
              context,
              MainScreen.routeName,
              arguments: MainScreenArgs(selectedIndex: 4),
            ),
          );
        }

        if (state is ErrorDemoAuthState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => showAlertDialog(
              context,
              content: state.message,
              onPressed: () => BlocProvider.of<AuthBloc>(context).add(CloseDialogEvent()),
            ),
          );
        }

        // SocialsState
        if (state is SuccessAuthSocialsState) {
          if (state.photoUrl != null) {
            BlocProvider.of<EditProfileBloc>(context).add(UploadPhotoProfileEvent(state.photoUrl));
          }

          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Navigator.pushReplacementNamed(
              context,
              MainScreen.routeName,
              arguments: MainScreenArgs(selectedIndex: 4),
            ),
          );
        }

        if (state is ErrorAuthSocialsState) {
          GoogleSignInProvider().logoutGoogle();
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => showAlertDialog(
              context,
              content: state.message,
              onPressed: () => BlocProvider.of<AuthBloc>(context).add(CloseDialogEvent()),
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          bool enableInputs = state is! LoadingSignUpState;
          return Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                    child: TextFormField(
                      controller: _loginController,
                      enabled: enableInputs,
                      cursorColor: ColorApp.mainColor,
                      decoration: InputDecoration(
                        labelText: localizations.getLocalization('login_label_text'),
                        helperText: localizations.getLocalization('login_registration_helper_text'),
                        filled: true,
                        labelStyle: TextStyle(
                          color: _focusNode.hasFocus ? Colors.red : Colors.black,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorApp.mainColor),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return localizations.getLocalization('login_empty_error_text');
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: TextFormField(
                      controller: _emailController,
                      enabled: enableInputs,
                      cursorColor: ColorApp.mainColor,
                      decoration: InputDecoration(
                        labelText: localizations.getLocalization('email_label_text'),
                        helperText: localizations.getLocalization('email_helper_text'),
                        filled: true,
                        labelStyle: TextStyle(
                          color: _focusNode.hasFocus ? Colors.red : Colors.black,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorApp.mainColor),
                        ),
                      ),
                      validator: validateEmail,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: TextFormField(
                      controller: _passwordController,
                      enabled: enableInputs,
                      obscureText: passwordVisible,
                      cursorColor: ColorApp.mainColor,
                      decoration: InputDecoration(
                        labelText: localizations.getLocalization('password_label_text'),
                        helperText: localizations.getLocalization('password_registration_helper_text'),
                        filled: true,
                        labelStyle: TextStyle(
                          color: _focusNode.hasFocus ? Colors.red : Colors.black,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorApp.mainColor),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                          color: ColorApp.mainColor,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return localizations.getLocalization('password_empty_error_text');
                        }
                        if (value.length < 8) {
                          return localizations.getLocalization('password_register_characters_count_error_text');
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: SizedBox(
                      height: kButtonHeight,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorApp.mainColor,
                        ),
                        onPressed: state is LoadingSignUpState
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<AuthBloc>(context).add(
                                    SignUpEvent(
                                      _loginController.text,
                                      _emailController.text,
                                      _passwordController.text,
                                    ),
                                  );
                                }
                              },
                        child: state is LoadingSignUpState
                            ? LoaderWidget()
                            : Text(
                                localizations.getLocalization('registration_button'),
                                textScaleFactor: 1.0,
                              ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: demoEnabled ?? true,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: kButtonHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorApp.mainColor,
                          ),
                          onPressed: state is LoadingDemoAuthState
                              ? null
                              : () {
                                  BlocProvider.of<AuthBloc>(context).add(DemoAuthEvent());
                                },
                          child: state is LoadingDemoAuthState
                              ? LoaderWidget()
                              : Text(
                                  localizations.getLocalization('registration_demo_button'),
                                  textScaleFactor: 1.0,
                                ),
                        ),
                      ),
                    ),
                  ),
                  SocialsWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
