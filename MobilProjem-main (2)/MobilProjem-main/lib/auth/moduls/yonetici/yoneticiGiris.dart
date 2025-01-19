import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:randevu_sistemi/utils/service/auth/auth_service.dart';
import 'package:randevu_sistemi/utils/ui/button/randevu_button.dart';
import 'package:randevu_sistemi/utils/ui/input/randevu_textfield.dart';
import 'package:randevu_sistemi/utils/ui/sized/randevu_sized_box.dart';

class YoneticiGiris extends StatefulWidget {
  const YoneticiGiris({super.key});

  @override
  State<YoneticiGiris> createState() => _YoneticiGirisState();
}

class _YoneticiGirisState extends State<YoneticiGiris> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool showError = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: _boxDecoration(),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _logo(),
                const RandevuSizedBox(),
                _emailTextField(),
                const RandevuSizedBox(),
                _passwordTextField(),
                const RandevuSizedBox(),
                _yoneticiButonu(context),
                const RandevuSizedBox(),
                showError ? _hataMesaji() : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 18, 42, 255),
          Color.fromARGB(255, 255, 255, 255),
        ],
        begin: Alignment.topCenter,
      ),
    );
  }

  FlutterLogo _logo() {
    return const FlutterLogo(size: 100);
  }

  RandevuTextfield _emailTextField() {
    return RandevuTextfield(
      textEditingController: emailController,
      hintText: "Email",
      keyboardType: TextInputType.emailAddress,
    );
  }

  RandevuTextfield _passwordTextField() {
    return RandevuTextfield(
      textEditingController: passwordController,
      obscureText: true,
      hintText: "Password",
      keyboardType: TextInputType.text,
    );
  }

  RandevuButton _yoneticiButonu(BuildContext context) {
    return RandevuButton(
      buttonTitle: "Giriş Yap",
      onPressed: () => _validateInputs(context),
    );
  }

  Text _hataMesaji() {
    return Text(
      errorMessage ?? '',
      style: const TextStyle(
        color: Colors.red,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  void _validateInputs(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _hataGoster("Lütfen Boş Alanları Doldurunuz!");
    } else if (!EmailValidator.validate(emailController.text)) {
      _hataGoster("Geçersiz Email Formatı!");
    } else {
      try {
        bool isAdmin = await _authService.signInAdmin(
          emailController.text,
          passwordController.text,
        );

        print('Is Admin: $isAdmin');

        if (isAdmin) {
          _hataGizle();
          Navigator.pushReplacementNamed(context, '/AdminAnaEkrani');
        } else {
          final user = await _authService.signIn(
            emailController.text,
            passwordController.text,
          );

          if (user != null) {
            _hataGizle();
            Navigator.pushReplacementNamed(context, '/AnaEkran');
          } else {
            _hataGoster("Giriş Başarısız");
          }
        }
      } catch (e) {
        _hataGoster("Giriş Başarısız: ${e.toString()}");
      }
    }
  }

  void _hataGoster(String message) {
    setState(() {
      showError = true;
      errorMessage = message;
    });
  }

  void _hataGizle() {
    setState(() {
      showError = false;
    });
  }
}
