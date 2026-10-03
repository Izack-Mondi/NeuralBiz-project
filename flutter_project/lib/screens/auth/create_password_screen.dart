import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/api_client.dart';
import '../../data/auth_controller.dart';
import 'profile_setup.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key, required this.userId});

  final String userId;

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  bool get _hasMinimumLength => _passwordController.text.length >= 8;
  bool get _hasUppercase => _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _passwordController.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecialCharacter =>
      _passwordController.text.contains(RegExp(r'[^A-Za-z0-9]'));
  bool get _passwordsMatch =>
      _passwordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text;

  bool get _isPasswordValid =>
      _hasMinimumLength &&
      _hasUppercase &&
      _hasNumber &&
      _hasSpecialCharacter &&
      _passwordsMatch;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_isSubmitting) {
      return;
    }

    if (!_isPasswordValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please make sure your password meets all requirements and matches the confirmation.',
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await context.read<AuthController>().completePasswordSetup(
        widget.userId,
        _passwordController.text,
      );
    } on ApiException catch (error) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);
    final authController = context.read<AuthController>();
    final email = authController.pendingSignup?.email;
    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session expired. Please try registering again.')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ProfileSetupScreen(userId: widget.userId, email: email, password: _passwordController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final password = _passwordController.text;
    int strength = 0;

    if (password.isNotEmpty) {
      if (_hasMinimumLength) strength++;
      if (_hasUppercase) strength++;
      if (_hasNumber) strength++;
      if (_hasSpecialCharacter) strength++;
    }

    String strengthText;
    if (strength <= 1) {
      strengthText = 'Weak';
    } else if (strength == 2) {
      strengthText = 'Fair';
    } else if (strength == 3) {
      strengthText = 'Good';
    } else {
      strengthText = 'Strong';
    }

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  tooltip: 'Back',
                ),
                const SizedBox(height: 35),
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0F1C),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFF22C55E)),
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF22C55E),
                      size: 34,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Center(
                  child: Text(
                    'Create your password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'Create a strong password to keep your Nexify account secure.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Color(0xFFB8C0CC),
                    ),
                  ),
                ),
                const SizedBox(height: 38),
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Create a password',
                    hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF8B95A5),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF8B95A5),
                      ),
                      tooltip: _obscurePassword
                          ? 'Show password'
                          : 'Hide password',
                    ),
                    filled: true,
                    fillColor: const Color(0xFF0A0F1C),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFF182131)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFF22C55E),
                        width: 1.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                if (password.isNotEmpty)
                  Row(
                    children: [
                      Text(
                        'Password strength: $strengthText',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _isPasswordValid ? 'Ready' : 'Needs work',
                        style: TextStyle(
                          color: _isPasswordValid
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFFFC857),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 18),
                const Text(
                  'Confirm password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _continue(),
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Re-enter your password',
                    hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF8B95A5),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF8B95A5),
                      ),
                      tooltip: _obscureConfirmPassword
                          ? 'Show password'
                          : 'Hide password',
                    ),
                    filled: true,
                    fillColor: const Color(0xFF0A0F1C),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFF182131)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFF22C55E),
                        width: 1.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildRequirementChip('8+ chars', _hasMinimumLength),
                    _buildRequirementChip('Uppercase', _hasUppercase),
                    _buildRequirementChip('Number', _hasNumber),
                    _buildRequirementChip('Symbol', _hasSpecialCharacter),
                    _buildRequirementChip('Match', _passwordsMatch),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSubmitting || !_isPasswordValid
                        ? null
                        : _continue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementChip(String label, bool isMet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isMet ? const Color(0xFF16351F) : const Color(0xFF0A0F1C),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isMet
              ? const Color(0xFF22C55E)
              : Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isMet ? const Color(0xFF22C55E) : Colors.white70,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
