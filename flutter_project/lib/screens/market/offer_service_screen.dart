import 'package:flutter/material.dart';
import '../../widgets/media_picker.dart';

class OfferServiceScreen extends StatefulWidget {
  const OfferServiceScreen({super.key});

  @override
  State<OfferServiceScreen> createState() => _OfferServiceScreenState();
}

class _OfferServiceScreenState extends State<OfferServiceScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _videoController = TextEditingController();
  final TextEditingController _customCategoryController = TextEditingController();

  String _selectedService = 'Veterinary Services';
  bool _showCustomCategory = false;
  String? _imageFilePath;
  String? _videoFilePath;

  final List<String> _serviceTypes = [
    'Veterinary Services',
    'Stock Management',
    'Inventory Management',
    'Farm Machinery Services',
    'Agricultural Training',
    'Agri-Tech Consulting',
    'Farm Equipment Rental',
    'Agricultural Marketing',
    'Supply Chain Solutions',
    'Accounting and Bookkeeping',
    'Farm Advisory',
    'Business Advisory',
    'Other',
  ];

  @override
  void dispose() {
    _serviceNameController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _availabilityController.dispose();
    _descriptionController.dispose();
    _videoController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  void _submitService() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _serviceNameController.text.trim();
    final price = _priceController.text.trim();
    final location = _locationController.text.trim();
    final availability = _availabilityController.text.trim();
    final description = _descriptionController.text.trim();
    final videoLink = _videoController.text.trim();
    final bool isOtherCategory = _selectedService == 'Other';
    final String customSpecialization = isOtherCategory
        ? _customCategoryController.text.trim()
        : '';
    final String categoryValue = isOtherCategory ? 'Other' : _selectedService;

    final serviceListing = {
      'name': name,
      'seller': 'Service Provider',
      'location': location.isEmpty ? 'Kenya' : location,
      'price': price.isEmpty ? 'Price negotiable' : 'KSh $price',
      'unit': '/session',
      'available': availability.isEmpty ? 'Available on request' : availability,
      'rating': 4.8,
      'reviews': 15,
      'category': 'SERVICE',
      'icon': Icons.handyman_outlined,
      'type': 'service',
      'description': description.isEmpty
          ? 'I offer professional support in this area and can deliver trusted, practical solutions for clients.'
          : description,
      'imagePath': _imageFilePath,
      'videoLink': videoLink.isEmpty ? 'No video uploaded yet' : videoLink,
      'videoFilePath': _videoFilePath,
      'serviceCategory': categoryValue,
      'customSpecialization': customSpecialization,
      'displayCategory': customSpecialization.isNotEmpty
          ? customSpecialization
          : categoryValue,
      'rate': price.isEmpty ? 'Price negotiable' : 'KSh $price',
      'availabilityText': availability.isEmpty ? 'Available on request' : availability,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Service published successfully.'),
        backgroundColor: Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context, serviceListing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 21),
        ),
        title: const Text(
          'Offer a Service',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Showcase your expertise',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Promote your skills and trusted service to buyers, farms, and businesses in your network.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                _buildImageTile(),
                const SizedBox(height: 16),
                _buildVideoTile(),
                const SizedBox(height: 22),
                _buildLabel('Service title'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _serviceNameController,
                  hintText: 'e.g. Poultry health support and vaccination',
                  icon: Icons.miscellaneous_services_outlined,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Please enter a service title.'
                      : null,
                ),
                const SizedBox(height: 18),
                _buildLabel('Service category'),
                const SizedBox(height: 8),
                _buildDropdown(
                 value: _selectedService,
                 items: _serviceTypes,
                 onChanged: (value) {
                   if (value != null) {
                     setState(() {
                       _selectedService = value;
                       _showCustomCategory = value == 'Other';
                       if (value != 'Other') {
                         _customCategoryController.clear();
                       }
                     });
                   }
                 },
                ),
                AnimatedSwitcher(
                 duration: const Duration(milliseconds: 220),
                 switchInCurve: Curves.easeOutCubic,
                 switchOutCurve: Curves.easeInCubic,
                 child: _showCustomCategory
                     ? Column(
                         key: const ValueKey('custom_service_category'),
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           const SizedBox(height: 18),
                           _buildLabel('Specify your specialization'),
                           const SizedBox(height: 8),
                           _buildTextField(
                             controller: _customCategoryController,
                             hintText:
                                 'e.g. Poultry farm management, bookkeeping, graphic design...',
                             icon: Icons.edit_outlined,
                             validator: (value) => _selectedService == 'Other' &&
                                     (value == null || value.trim().isEmpty)
                                 ? 'Please specify your area of specialization.'
                                 : null,
                           ),
                         ],
                       )
                     : const SizedBox.shrink(key: ValueKey('service_category_hidden')),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Price / package'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _priceController,
                            hintText: 'e.g. 5000',
                            icon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Location'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _locationController,
                            hintText: 'Nairobi',
                            icon: Icons.location_on_outlined,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _buildLabel('Availability'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _availabilityController,
                  hintText: 'e.g. Monday to Saturday',
                  icon: Icons.calendar_today_outlined,
                ),
                const SizedBox(height: 18),
                _buildLabel('Describe the service'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF0A0F1C),
                    hintText: 'Explain the service, your experience, what clients can expect, and the results you deliver.',
                    hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                    prefixIcon: const Icon(Icons.description_outlined, color: Color(0xFF8B95A5)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF182131)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF22C55E), width: 1.3),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 18),
                _buildLabel('Video link or upload note (optional)'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _videoController,
                  hintText: 'Paste a YouTube URL or describe the video file you’ll share',
                  icon: Icons.video_library_outlined,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _submitService,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Publish service',
                      style: TextStyle(
                        fontSize: 15,
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

  Widget _buildImageTile() {
    return GestureDetector(
      onTap: () async {
        try {
          final path = await MediaPicker.pickImage();
          if (path != null) {
            setState(() {
              _imageFilePath = path;
            });
          }
        } catch (e) {
          // ignore
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0F1C),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF22C55E).withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _imageFilePath == null ? Icons.image_outlined : Icons.image,
                color: const Color(0xFF22C55E),
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _imageFilePath == null ? 'Upload a service image' : 'Image selected',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _imageFilePath == null
                        ? 'Add a banner or profile image to help clients recognize your service.'
                        : 'Tap to replace the selected image.',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoTile() {
    return GestureDetector(
      onTap: () async {
        try {
          final path = await MediaPicker.pickVideo();
          if (path != null) {
            setState(() {
              _videoFilePath = path;
            });
          }
        } catch (e) {
          // ignore
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0F1C),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF22C55E).withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _videoFilePath == null ? Icons.videocam_outlined : Icons.video_file,
                color: const Color(0xFF22C55E),
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _videoFilePath == null ? 'Upload a service video or demo' : 'Video selected',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _videoFilePath == null
                        ? 'Show your process, skill, or a quick before-and-after proof.'
                        : 'Tap to replace the selected video.',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF0A0F1C),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF6B7280)),
        prefixIcon: Icon(icon, color: const Color(0xFF8B95A5)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF182131)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF22C55E), width: 1.3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F1C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF182131)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF0A0F1C),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
