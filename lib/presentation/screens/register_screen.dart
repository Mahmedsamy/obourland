import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_cubit.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});


  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _emailCtrl, decoration: InputDecoration(hintText: 'Email')),
            const SizedBox(height: 12),
            TextField(controller: _passCtrl, obscureText: true, decoration: InputDecoration(hintText: 'Password')),
            const SizedBox(height: 20),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) Navigator.pop(context);
                if (state is AuthFailure) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
              },
              builder: (context, state) {
                if (state is AuthLoading) return CircularProgressIndicator();
                return ElevatedButton(onPressed: () => context.read<AuthCubit>().register(_emailCtrl.text.trim(), _passCtrl.text.trim()), child: const Text('Register'));
              },
            )
          ],
        ),
      ),
    );
  }
}