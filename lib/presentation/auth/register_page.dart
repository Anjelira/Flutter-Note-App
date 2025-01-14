import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_idn_notes_app/data/models/request/register_request_model.dart';
import 'package:flutter_idn_notes_app/pages/home_page.dart';
import 'package:flutter_idn_notes_app/presentation/auth/bloc/register/register_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register Page',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 64,
          ),
          FlutterLogo(
            size: 100,
          ),
          SizedBox(
            height: 32,
          ),
          Text(
            'Register Notes App',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Name'),
            ),
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
            child: BlocListener<RegisterBloc, RegisterState>(
              listener: (context, state) {
                if (state is RegisterSuccess) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const HomePage();
                  }));
                }
                if (state is RegisterFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message),
                    backgroundColor: Colors.red,
                    )
                  );
                }
              },
              child: BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  if (state is RegsiterLoadng) {
                    return Center(child: const CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: () async {
                      // register
                      final dataModel = RegisterRequestModel(
                        name: _nameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                      );

                      context
                          .read<RegisterBloc>()
                          .add(RegisterButtonPressed(data: dataModel));

                      // call register function
                      // AuthRemoteDatasource datasource = AuthRemoteDatasource();
                      // final response = await datasource.register(dataModel);

                      // // check response
                      // response.fold((error) {
                      //   ScaffoldMessenger.of(context)
                      //       .showSnackBar(SnackBar(content: Text('Error')));
                      // }, (success) {
                      //   ScaffoldMessenger.of(context)
                      //       .showSnackBar(SnackBar(content: Text('Success')));
                      //   Navigator.push(context, MaterialPageRoute(
                      //     builder: (context) {
                      //       return const LoginPage();
                      //     },
                      //   ));
                      // });
                    },
                    child: const Text('Register'),
                  );
                },
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('Already have an account?'),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Login'),
            )
          ])
        ],
      ),
    );
  }
}
