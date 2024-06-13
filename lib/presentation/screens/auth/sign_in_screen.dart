import 'package:assignment_manager/presentation/screens/assignment/bottom_nav_screen.dart';
import 'package:assignment_manager/presentation/widgets/app_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../data/models/response_model.dart';
import '../../../data/services/api_service.dart';
import '../../../data/utils/network_const.dart';
import '../../utils/toast_util.dart';
import 'email_verify_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isSignInProgress = false;


  Future<void> _signIn() async {
    _isSignInProgress = true;
    setState(() {});
    // api call
    Map<String, dynamic> inputParams = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text.trim(),
    };

    ResponseModel response = await ApiService.postRequest(
      NetworkConst.login,
      inputParams,
    );

    _isSignInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      //show message
      if (mounted) {
        ToastUtil.showSnackBarMessage(
            context, 'Login Success!');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavScreen()));
      } else {
        //show error message
        if (mounted) {
          ToastUtil.showSnackBarMessage(
            context,
            'Login Failed! Please try again.',
            isErrorMessage: true,
          );
        }
      }
    }
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: AppBackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Gap(100),
                  Text('Let\'s Start with Us!',
                      style: theme.textTheme.titleLarge),
                  const Gap(16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(hintText: 'Enter your email'),
                  ),
                  const Gap(16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(hintText: 'Enter your password'),
                  ),
                  const Gap(24),
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _isSignInProgress == false,
                      replacement: const  Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: (){
                          _signIn();
                        },
                        child: const Text('Sign In'),
                      ),
                    )
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EmailVerifyScreen(),
                          ),
                        );
                      },
                      child: const Text('Forgot Password?')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an Account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: const Text('Sign Up')),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
