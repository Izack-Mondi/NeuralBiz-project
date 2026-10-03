import 'package:flutter/material.dart';

class PostProductScreen extends StatefulWidget {
  const PostProductScreen({super.key});

  @override
  State<PostProductScreen> createState() => _PostProductScreenState();
}

class _PostProductScreenState extends State<PostProductScreen> {
  final TextEditingController productNameController =
      TextEditingController();

  final TextEditingController priceController =
      TextEditingController();

  final TextEditingController quantityController =
      TextEditingController();

  final TextEditingController locationController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  String selectedSector = 'Agriculture';
  String selectedCategory = 'Produce';
  String selectedUnit = 'Per unit';

  final List<String> agricultureCategories = [
    'Produce',
    'Livestock',
    'Poultry',
    'Farm Inputs',
    'Farm Equipment',
    'Seeds',
    'Other',
  ];

  final List<String> businessCategories = [
    'Retail',
    'Wholesale',
    'Electronics',
    'Clothing',
    'Food & Beverage',
    'Construction',
    'Other',
  ];

  @override
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    locationController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),

      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
        ),

        title: const Text(
          'Post Product',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ==================================================
              // INTRO
              // ==================================================

              const Text(
                'Create your listing',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Provide accurate information to help buyers find your product.',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // PRODUCT PHOTOS
              // ==================================================

              const Text(
                'Product photos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Add clear photos of what you are selling.',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 13),

              Row(
                children: [
                  _buildPhotoBox(
                    icon: Icons.add_a_photo_outlined,
                    isMain: true,
                  ),

                  const SizedBox(width: 10),

                  _buildPhotoBox(
                    icon: Icons.add_photo_alternate_outlined,
                  ),

                  const SizedBox(width: 10),

                  _buildPhotoBox(
                    icon: Icons.add_photo_alternate_outlined,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ==================================================
              // PRODUCT NAME
              // ==================================================

              _buildLabel('Product name'),

              const SizedBox(height: 8),

              _buildTextField(
                controller: productNameController,
                hintText: 'e.g. Fresh Tomatoes',
                icon: Icons.shopping_bag_outlined,
              ),

              const SizedBox(height: 22),

              // ==================================================
              // SECTOR
              // ==================================================

              _buildLabel('Sector'),

              const SizedBox(height: 8),

              _buildDropdown(
                value: selectedSector,
                items: const [
                  'Agriculture',
                  'Business',
                ],
                icon: Icons.category_outlined,
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedSector = value;

                    if (selectedSector == 'Agriculture') {
                      selectedCategory =
                          agricultureCategories.first;
                    } else {
                      selectedCategory =
                          businessCategories.first;
                    }
                  });
                },
              ),

              const SizedBox(height: 22),

              // ==================================================
              // CATEGORY
              // ==================================================

              _buildLabel('Category'),

              const SizedBox(height: 8),

              _buildDropdown(
                value: selectedCategory,
                items: selectedSector == 'Agriculture'
                    ? agricultureCategories
                    : businessCategories,
                icon: Icons.grid_view_outlined,
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),

              const SizedBox(height: 22),

              // ==================================================
              // PRICE
              // ==================================================

              _buildLabel('Price'),

              const SizedBox(height: 8),

              _buildTextField(
                controller: priceController,
                hintText: 'e.g. 2500',
                icon: Icons.payments_outlined,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 22),

              // ==================================================
              // UNIT
              // ==================================================

              _buildLabel('Price unit'),

              const SizedBox(height: 8),

              _buildDropdown(
                value: selectedUnit,
                items: const [
                  'Per unit',
                  'Per kg',
                  'Per gram',
                  'Per bag',
                  'Per tray',
                  'Per litre',
                  'Per crate',
                  'Per acre',
                  'Negotiable',
                ],
                icon: Icons.straighten_outlined,
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedUnit = value;
                  });
                },
              ),

              const SizedBox(height: 22),

              // ==================================================
              // QUANTITY
              // ==================================================

              _buildLabel('Available quantity'),

              const SizedBox(height: 8),

              _buildTextField(
                controller: quantityController,
                hintText: 'e.g. 500',
                icon: Icons.inventory_2_outlined,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 22),

              // ==================================================
              // LOCATION
              // ==================================================

              _buildLabel('Location'),

              const SizedBox(height: 8),

              _buildTextField(
                controller: locationController,
                hintText: 'e.g. Machakos, Kenya',
                icon: Icons.location_on_outlined,
              ),

              const SizedBox(height: 22),

              // ==================================================
              // DESCRIPTION
              // ==================================================

              _buildLabel('Description'),

              const SizedBox(height: 8),

              _buildTextField(
                controller: descriptionController,
                hintText:
                    'Describe your product, condition, quality, delivery options...',
                icon: Icons.description_outlined,
                maxLines: 5,
              ),

              const SizedBox(height: 30),

              // ==================================================
              // SELLER INFORMATION
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: const Color(0xFF07150D),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFF22C55E).withValues(
                      alpha: 0.14,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E)
                            .withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Color(0xFF22C55E),
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 13),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your seller profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            'This listing will be connected to your Nexify profile. Buyers will be able to view your other listings.',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // POST BUTTON
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _postProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF22C55E),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.publish_outlined,
                        size: 21,
                      ),

                      SizedBox(width: 9),

                      Text(
                        'Post Listing',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Center(
                child: Text(
                  'You can edit your listing later.',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // PHOTO BOX
  // ==========================================================

  Widget _buildPhotoBox({
    required IconData icon,
    bool isMain = false,
  }) {
    return GestureDetector(
      onTap: () {
        _showPhotoMessage();
      },
      child: Container(
        width: 82,
        height: 82,
        decoration: BoxDecoration(
          color: const Color(0xFF0A0F1C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isMain
                ? const Color(0xFF22C55E).withValues(
                    alpha: 0.4,
                  )
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Icon(
          icon,
          color: isMain
              ? const Color(0xFF22C55E)
              : Colors.white54,
          size: 27,
        ),
      ),
    );
  }

  // ==========================================================
  // LABEL
  // ==========================================================

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // ==========================================================
  // TEXT FIELD
  // ==========================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      cursorColor: const Color(0xFF22C55E),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white38,
          fontSize: 13,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            left: 4,
            right: 8,
          ),
          child: Icon(
            icon,
            color: Colors.white54,
            size: 21,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 50,
        ),
        filled: true,
        fillColor: const Color(0xFF0A0F1C),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.07),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.07),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFF22C55E),
            width: 1.2,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // DROPDOWN
  // ==========================================================

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F1C),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        dropdownColor: const Color(0xFF0A0F1C),
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white54,
        ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.white54,
            size: 21,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  // ==========================================================
  // POST PRODUCT
  // ==========================================================

  void _postProduct() {
    if (productNameController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        quantityController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in the required product information.',
          ),
          backgroundColor: Color(0xFF166534),
        ),
      );

      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A0F1C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              25,
              24,
              30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 25),

                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E)
                        .withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF22C55E),
                    size: 36,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Listing ready',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Your product information has been captured. The marketplace backend will publish and associate it with your profile.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 23),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF22C55E),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // PHOTO MESSAGE
  // ==========================================================

  void _showPhotoMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Photo upload will be connected next.',
        ),
        backgroundColor: Color(0xFF166534),
      ),
    );
  }
}