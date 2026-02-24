import 'package:flutter/material.dart';
import 'package:veto_app/services/api_service.dart';
import 'home_screen.dart';

class RegisterOwnerPage extends StatefulWidget {
  final String role;
  const RegisterOwnerPage({super.key, required this.role});

  @override
  State<RegisterOwnerPage> createState() => _RegisterOwnerPageState();
}

class _RegisterOwnerPageState extends State<RegisterOwnerPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;
  String? _firstNameError;
  String? _lastNameError;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    firstName.dispose();
    lastName.dispose();
    super.dispose();
  }

  void _handleRegistration() async {
    // Réinitialiser les erreurs
    setState(() {
      _emailError = null;
      _passwordError = null;
      _firstNameError = null;
      _lastNameError = null;
    });

    // Validation
    String? fnError = ApiService.validateName(firstName.text);
    String? lnError = ApiService.validateName(lastName.text);
    String? pwError = ApiService.validatePassword(password.text);

    if (fnError != null || lnError != null || pwError != null ||
        email.text.isEmpty || !ApiService.isValidEmail(email.text)) {
      setState(() {
        _firstNameError = fnError;
        _lastNameError = lnError;
        _passwordError = pwError;
        if (email.text.isEmpty) {
          _emailError = 'L\'email ne peut pas être vide';
        } else if (!ApiService.isValidEmail(email.text)) {
          _emailError = 'Email invalide';
        }
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      var userData = await ApiService.register(
        email: email.text.trim(),
        password: password.text,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        role: widget.role,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inscription réussie !'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushAndRemoveUntilNamed(
          'home',
          (route) => false,
          arguments: userData,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inscription ${widget.role}"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.person_add, size: 80, color: Colors.teal),
            const SizedBox(height: 30),
            TextField(
              controller: firstName,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: "Prénom",
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
                errorText: _firstNameError,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: lastName,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: "Nom",
                prefixIcon: const Icon(Icons.family_restroom),
                border: const OutlineInputBorder(),
                errorText: _lastNameError,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: email,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email),
                border: const OutlineInputBorder(),
                errorText: _emailError,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: password,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: "Mot de passe",
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                errorText: _passwordError,
                helperText: 'Min. 6 caractères',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegistration,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        "S'inscrire",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}