import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/api_client.dart';
import '../../data/auth_controller.dart';
import '../app_shell.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key, this.isEditing = false, this.userId, this.email, this.password});

  final bool isEditing;
  final String? userId;
  final String? email;
  final String? password;

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  String? _selectedCountry;
  String? _selectedLocation;
  final Set<String> _selectedInterests = <String>{};

  final List<String> _countries = [
    'Kenya',
    'Uganda',
    'Tanzania',
    'Rwanda',
    'Nigeria',
    'South Africa',
    'Ghana',
    'Eritrea',
    'Burundi',
  ];

  final Map<String, List<String>> _locations = {
    'Kenya': ['Nairobi', 'Mombasa', 'Kisumu', 'Nakuru', 'Eldoret', 'Other'],
    'Uganda': ['Kampala', 'Entebbe', 'Jinja', 'Other'],
    'Tanzania': ['Dar es Salaam', 'Arusha', 'Dodoma', 'Other'],
    'Rwanda': ['Kigali', 'Other'],
    'Nigeria': ['Lagos', 'Abuja', 'Kano', 'Other'],
    'South Africa': ['Johannesburg', 'Cape Town', 'Durban', 'Other'],
    'Ghana': ['Accra', 'Kumasi', 'Other'],
    'Ethiopia': ['Addis Ababa'],
    'Burundi':['Bunjumbura'],
  };

  bool _isSubmitting = false;

  bool get _canContinue =>
      _nameController.text.trim().isNotEmpty &&
      _selectedCountry != null &&
      _selectedLocation != null &&
      _selectedInterests.isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  Future<void> _continue() async {
    if (_isSubmitting) {
      return;
    }

    if (!_canContinue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please complete your profile and select at least one interest.',
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final controller = context.read<AuthController>();
      if (widget.isEditing) {
        await controller.updateProfile(
          fullName: _nameController.text.trim(),
          country: _selectedCountry!,
          location: _selectedLocation!,
          interests: _selectedInterests.toList(),
        );
      } else {
        final userId = widget.userId;
        final email = widget.email;
        final password = widget.password;
        if (userId == null || email == null || password == null) {
          throw const ApiException('Session expired. Please try registering again.');
        }
        await controller.completeProfileAndLogin(
          userId: userId,
          email: email,
          fullName: _nameController.text.trim(),
          country: _selectedCountry!,
          location: _selectedLocation!,
          interests: _selectedInterests.toList(),
          password: password,
        );
      }
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
    if (widget.isEditing) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AppShell()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationOptions = _selectedCountry == null
        ? <String>[]
        : _locations[_selectedCountry] ?? const <String>[];

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
                const SizedBox(height: 28),
                Center(
                  child: Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0F1C),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF22C55E),
                        width: 1.2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF22C55E),
                      size: 38,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'Complete your profile',
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
                    'Tell us a little about yourself so Nexify can personalize your experience.',
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
                  'Full name',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your full name',
                    hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF8B95A5),
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
                const SizedBox(height: 24),
                const Text(
                  'Country',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0F1C),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFF182131)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedCountry,
                      hint: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Select your country',
                          style: TextStyle(color: Colors.white60),
                        ),
                      ),
                      dropdownColor: const Color(0xFF0A0F1C),
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white70,
                        ),
                      ),
                      items: _countries
                          .map(
                            (country) => DropdownMenuItem<String>(
                              value: country,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  country,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedCountry = value;
                          _selectedLocation = null;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0F1C),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: _selectedCountry == null
                          ? const Color(0xFF182131)
                          : const Color(0xFF22C55E),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedLocation,
                      hint: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _selectedCountry == null
                              ? 'Choose a country first'
                              : 'Select your location',
                          style: const TextStyle(color: Colors.white60),
                        ),
                      ),
                      dropdownColor: const Color(0xFF0A0F1C),
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white70,
                        ),
                      ),
                      items: locationOptions
                          .map(
                            (location) => DropdownMenuItem<String>(
                              value: location,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  location,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: _selectedCountry == null
                          ? null
                          : (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() => _selectedLocation = value);
                            },
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Interests',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children:
                      [
                        'Farming',
                        'Business',
                        'Logistics',
                        'Agri-Tech',
                        'Supply Chain',
                        'Food Processing',
                        'Sustainability',
                        'Finance',
                      ].map((interest) {
                        final selected = _selectedInterests.contains(interest);
                        return ChoiceChip(
                          label: Text(interest),
                          selected: selected,
                          onSelected: (_) => _toggleInterest(interest),
                          selectedColor: const Color(0xFF22C55E),
                          backgroundColor: const Color(0xFF0A0F1C),
                          labelStyle: TextStyle(
                            color: selected ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          side: BorderSide(
                            color: selected
                                ? const Color(0xFF22C55E)
                                : Colors.white.withValues(alpha: 0.12),
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSubmitting || !_canContinue
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
}
