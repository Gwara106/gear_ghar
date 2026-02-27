import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/my_button.dart';
import '../widgets/my_textformfield.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/constants/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool rememberMe = false;
  bool _isPasswordVisible = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Login failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Image.asset(AppConstants.logoPath, width: 150),
                  Text(AppStrings.welcome, style: AppTextStyles.title),
                  const SizedBox(height: 5),
                  Container(
                    width: 380,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xFF474747),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        _buildLabel(AppStrings.email),
                        MyTextformfield(
                          labelText: 'example@gmail.com',
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildLabel(AppStrings.password),
                        MyTextformfield(
                          labelText: '*********',
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 23),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                AppStrings.forgotPassword,
                                style: const TextStyle(
                                  fontFamily: 'Jersey25',
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 29, 0, 133),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              },
                              activeColor: Colors.white,
                              checkColor: Colors.black,
                            ),
                            Text(
                              AppStrings.rememberMe,
                              style: const TextStyle(
                                fontFamily: 'Jersey25',
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return ElevatedButton(
                                onPressed: authProvider.isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF272727),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: authProvider.isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        AppStrings.login,
                                        style: const TextStyle(
                                          fontFamily: 'Jersey25',
                                          fontSize: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 20,
                          endIndent: 10,
                        ),
                      ),
                      const Text(
                        'Or With',
                        style: TextStyle(
                          fontFamily: 'Jersey25',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 10,
                          endIndent: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  MyButton(
                    onPressed: () async {
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      final success = await authProvider.signInWithFacebook();
                      
                      if (success && mounted) {
                          if (context.mounted) {
                              Navigator.pushReplacementNamed(context, '/main');
                          }
                      } else if (mounted) {
                          if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authProvider.errorMessage ?? 'Facebook login failed'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                          }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF474747),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/icons/facebook.png', width: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: const Text(
                            'Login with Facebook',
                            style: TextStyle(
                              fontFamily: 'Jersey25',
                              fontSize: 24,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    onPressed: () async {
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      final success = await authProvider.signInWithGoogle();
                      
                      if (success && mounted) {
                          if (context.mounted) {
                              Navigator.pushReplacementNamed(context, '/main');
                          }
                      } else if (mounted) {
                          if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authProvider.errorMessage ?? 'Google login failed'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                          }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF474747),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/icons/google.png', width: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: const Text(
                            'Login with Google',
                            style: TextStyle(
                              fontFamily: 'Jersey25',
                              fontSize: 24,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            fontFamily: 'Jersey25',
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: AppStrings.signup,
                          style: const TextStyle(
                            fontFamily: 'Jersey25',
                            fontSize: 20,
                            color: Color.fromARGB(255, 29, 0, 133),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 23),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Jersey25',
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
