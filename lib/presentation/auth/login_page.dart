import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_idn_notes_app/presentation/auth/bloc/login/login_bloc.dart';
import 'package:flutter_idn_notes_app/presentation/auth/register_page.dart';
import 'package:flutter_idn_notes_app/presentation/notes/notes_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login Page',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 64,
          ),
          const FlutterLogo(
            size: 100,
          ),
          SizedBox(
            height: 32,
          ),
          Text(
            'Notes App',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Email'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Password'),
              obscureText: true,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ));
                }
                if (state is LoginSuccess) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const NotesPage();
                  }));
                }
              },
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ElevatedButton(
                    onPressed: () {
                      context.read<LoginBloc>().add(LoginButtonPessed(
                          email: _emailController.text,
                          password: _passwordController.text));
                    },
                    child: Text('Login'),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Don\'t have an account?'),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const RegisterPage();
                }));
              },
              child: Text('Register',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  )),
            )
          ])
        ],
      ),
    );
  }
}
