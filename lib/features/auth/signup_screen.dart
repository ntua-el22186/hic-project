import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      
      // Αποθήκευση στοιχείων
      await _storage.write(key: 'user_email', value: _emailController.text);
      await _storage.write(key: 'user_password', value: _passwordController.text);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account Created Successfully!")),
        );
        Navigator.pop(context); // Επιστροφή στο Login
      }
    } else {
      HapticFeedback.vibrate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, 
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildLogo(),
              const SizedBox(height: 20),
              const Text('Start building your vocabulary today', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              _buildField("Name", "Enter Name...", _nameController, false),
              const SizedBox(height: 15),
              _buildField("Email", "Enter Email...", _emailController, false),
              const SizedBox(height: 15),
              _buildField("Password", "Create Password...", _passwordController, true),
              const SizedBox(height: 15),
              _buildField("Confirm Password", "Confirm Password...", _confirmPasswordController, true),
              const SizedBox(height: 30),
              _buildButton("Sign Up", _handleSignUp),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF1D4ED8), borderRadius: BorderRadius.circular(15)),
      child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 40),
    );
  }

  Widget _buildField(String label, String hint, TextEditingController controller, bool isPass) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
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