import 'package:flutter/material.dart';
import '../../widgets/media_picker.dart';

class RequestAProductScreen extends StatefulWidget {
  const RequestAProductScreen({super.key});

  @override
  State<RequestAProductScreen> createState() => _RequestAProductScreenState();
}

class _RequestAProductScreenState extends State<RequestAProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _customCategoryController = TextEditingController();

  String _selectedCategory = 'Farm Produce';
  bool _showCustomCategory = false;
  final List<String> _categories = [
    'Farm Produce',
    'Livestock',
    'Poultry',
    'Farm Inputs',
    'Machinery',
    'Business Supplies',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _budgetController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    _availabilityController.dispose();
    _descriptionController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  void _submitRequest() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleController.text.trim();
    final price = _budgetController.text.trim();
    final location = _locationController.text.trim();
    final quantity = _quantityController.text.trim();
    final availability = _availabilityController.text.trim();
    final description = _descriptionController.text.trim();
    final selectedCategory = _selectedCategory == 'Other'
        ? (_customCategoryController.text.trim().isNotEmpty
            ? _customCategoryController.text.trim()
            : 'Other')
        : _selectedCategory;

    final request = {
      'name': title,
      'seller': 'Buyer Request',
      'location': location.isEmpty ? 'Kenya' : location,
      'price': price.isEmpty ? 'Price flexible' : 'KSh $price',
      'unit': quantity.isEmpty ? '/request' : '/$quantity',
      'available': availability.isEmpty ? 'Flexible' : availability,
      'rating': 4.9,
      'reviews': 12,
      'category': 'REQUEST PRODUCT',
      'icon': Icons.assignment_outlined,
      'type': 'request',
      'description': description.isEmpty
          ? 'Buyer is looking for this item and is ready to purchase when the right offer is available.'
          : description,
      'categoryName': selectedCategory,
      'neededBy': availability.isEmpty ? 'Flexible' : availability,
      'budget': price.isEmpty ? 'Price flexible' : 'KSh $price',
      'quantityNeeded': quantity.isEmpty ? 'Flexible' : quantity,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product request posted successfully.'),
        backgroundColor: Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context, request);
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
          'Request a product',
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
                  'Tell sellers what you need',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Share as much detail as possible so sellers can respond with the right offer.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 26),
                _buildImageUploadTile(),
                const SizedBox(height: 22),
                _buildLabel('Product or item needed'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _titleController,
                  hintText: 'e.g. Fresh maize, greenhouse pipes, fertilizer',
                  icon: Icons.inventory_2_outlined,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Please describe the item you need.'
                      : null,
                ),
                const SizedBox(height: 18),
                _buildLabel('Category'),
                const SizedBox(height: 8),
                _buildDropdown(
                  value: _selectedCategory,
                  items: _categories,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                        _showCustomCategory = value == 'Other';
                      });
                    }
                  },
                ),
                if (_showCustomCategory) ...[
                 const SizedBox(height: 18),
                 _buildLabel('Custom product category'),
                 const SizedBox(height: 8),
                 _buildTextField(
                   controller: _customCategoryController,
                   hintText: 'e.g. Greenhouse equipment',
                   icon: Icons.edit_outlined,
                   validator: (value) => _selectedCategory == 'Other' &&
                           (value == null || value.trim().isEmpty)
                       ? 'Please enter a custom category.'
                       : null,
                 ),
                ],
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Expected price'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _budgetController,
                            hintText: 'e.g. 15000',
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
                          _buildLabel('Quantity needed'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _quantityController,
                            hintText: 'e.g. 50kg',
                            icon: Icons.scale_outlined,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _buildLabel('Location'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _locationController,
                  hintText: 'e.g. Nairobi, Kenya',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 18),
                _buildLabel('Availability need'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _availabilityController,
                  hintText: 'e.g. Within 2 weeks',
                  icon: Icons.calendar_today_outlined,
                ),
                const SizedBox(height: 18),
                _buildLabel('Description (optional)'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF0A0F1C),
                    hintText: 'Describe quality, quantity, preferred packaging or any special requirements.',
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
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _submitRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Post request',
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

  String? _referenceImagePath;

  Widget _buildImageUploadTile() {
    return GestureDetector(
      onTap: () async {
        // Lazy import usage
        try {
          final path = await MediaPicker.pickImage();
          if (path != null) {
            setState(() {
              _referenceImagePath = path;
            });
          }
        } catch (e) {
          // ignore errors for now
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
                _referenceImagePath == null ? Icons.add_photo_alternate_outlined : Icons.image_outlined,
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
                    _referenceImagePath == null ? 'Add reference photo (optional)' : 'Reference photo selected',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _referenceImagePath == null
                        ? 'Include an image of the product or item you need.'
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
