import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/api_client.dart';
import '../../data/auth_controller.dart';
import '../../widgets/nexify_transitions.dart';
import 'create_password_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.destination, required this.userId, this.verificationMethod = 'EMAIL'});

  final String destination;
  final String userId;
  final String verificationMethod;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;

  int _secondsRemaining = 50;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    setState(() {
      _secondsRemaining = 50;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();

        if (mounted) {
          setState(() {
            _secondsRemaining = 0;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      }
    });
  }

  void _handleCodeInput(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _enteredCode {
    return _controllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyCode() async {
    final code = _enteredCode;

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 6-digit verification code.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await context.read<AuthController>().verifyRegistration(widget.userId, code);
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
    Navigator.push(
      context,
      NexifyTransitions.fadeSlide(CreatePasswordScreen(userId: widget.userId)),
    );
  }

  Future<void> _resendCode() async {
    if (_secondsRemaining > 0 || _isSubmitting) {
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await context.read<AuthController>().resendVerificationCode(
        widget.userId,
        widget.destination,
        widget.verificationMethod,
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
    for (final controller in _controllers) {
      controller.clear();
    }

    _focusNodes.first.requestFocus();

    _startTimer();

    final message = widget.verificationMethod == 'PHONE'
        ? 'A new verification code has been sent to your phone.'
        : 'A new verification code has been sent to your email.';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();

    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');

    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BACK BUTTON
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
              ),

              const SizedBox(height: 40),

              // VERIFICATION ICON
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0F1C),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFF22C55E),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.verified_user_outlined,
                    color: Color(0xFF22C55E),
                    size: 34,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // TITLE
              const Center(
                child: Text(
                  'Verify your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // DESCRIPTION
              Center(
                child: Text(
                  widget.verificationMethod == 'PHONE'
                      ? 'We sent a 6-digit verification code to\n'
                          '${widget.destination}'
                      : 'We sent a 6-digit verification code to\n'
                          '${widget.destination}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Color(0xFFB8C0CC),
                  ),
                ),
              ),

              const SizedBox(height: 42),

              // OTP BOXES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 46,
                    height: 58,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                      onChanged: (value) {
                        _handleCodeInput(value, index);
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: const Color(0xFF0A0F1C),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF182131),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF22C55E),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),

              // TIMER
              Center(
                child: Text(
                  _secondsRemaining > 0
                      ? 'Code expires in $minutes:$seconds'
                      : 'Your code has expired',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8B95A5),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // RESEND CODE
              Center(
                child: TextButton(
                  onPressed: _secondsRemaining > 0 || _isSubmitting
                      ? null
                      : _resendCode,
                  child: Text(
                    _secondsRemaining > 0
                        ? 'Resend code'
                        : 'Resend verification code',
                    style: TextStyle(
                      color: _secondsRemaining > 0
                          ? const Color(0xFF4B5563)
                          : const Color(0xFF22C55E),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // VERIFY BUTTON
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _verifyCode,
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
                          'Verify',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 22),

              // CHANGE EMAIL OR PHONE
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Use a different email or phone number',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFB8C0CC), fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
