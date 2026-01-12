import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      String? savedEmail = await _storage.read(key: 'user_email');
      String? savedPassword = await _storage.read(key: 'user_password');

      if (_emailController.text == savedEmail && _passwordController.text == savedPassword) {
        HapticFeedback.lightImpact();
        if (mounted) Navigator.pushReplacementNamed(context, '/home');
      } else {
        HapticFeedback.vibrate();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Wrong email or password!"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 100),
              _buildLogo(),
              const SizedBox(height: 30),
              const Text('MyWordLoop', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Serif')),
              const Text('Expand your vocabulary, one word at a time', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 50),
              _buildField("Email", "Enter Email ...", _emailController, false),
              const SizedBox(height: 20),
              _buildField("Password", "Enter your Password ...", _passwordController, true),
              const SizedBox(height: 40),
              _buildButton("Log In", _handleLogin),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text("Don't have an account? Sign Up", style: TextStyle(color: Color(0xFF1D4ED8))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Τα ίδια Helper Widgets όπως παραπάνω για ομοιομορφία
  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF1D4ED8), borderRadius: BorderRadius.circular(15)),
      child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 50),
    );
  }

  Widget _buildField(String label, String hint, TextEditingController controller, bool isPass) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPass,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          validator: (v) => v!.isEmpty ? "Required field" : null,
        ),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPress) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1D4ED8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Η ΔΙΟΡΘΩΣΗ ΕΔΩ
        ),
        onPressed: onPress,
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}