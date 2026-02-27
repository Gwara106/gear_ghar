import 'package:flutter/material.dart';
import '../../../../core/models/address_model.dart';
import '../../../../core/services/address_api_service.dart';

class AddEditAddressScreen extends StatefulWidget {
  final Address? address;

  const AddEditAddressScreen({super.key, this.address});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final AddressApiService _addressService = AddressApiService();
  
  final _nameController = TextEditingController();
  final _customNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  final _deliveryInstructionsController = TextEditingController();

  String _selectedName = 'Home';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _populateFields(widget.address!);
    } else {
      _countryController.text = 'USA';
    }
  }

  void _populateFields(Address address) {
    _selectedName = address.name ?? 'Home';
    _customNameController.text = address.customName ?? '';
    _streetController.text = address.streetAddress ?? '';
    _apartmentController.text = address.apartment ?? '';
    _cityController.text = address.city ?? '';
    _stateController.text = address.state ?? '';
    _postalController.text = address.postalCode ?? '';
    _countryController.text = address.country ?? 'USA';
    _phoneController.text = address.phoneNumber ?? '';
    _deliveryInstructionsController.text = address.deliveryInstructions ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _customNameController.dispose();
    _streetController.dispose();
    _apartmentController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _deliveryInstructionsController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final address = Address(
        id: widget.address?.id,
        name: _selectedName,
        customName: _selectedName == 'Other' ? _customNameController.text : null,
        streetAddress: _streetController.text,
        apartment: _apartmentController.text.isEmpty ? null : _apartmentController.text,
        city: _cityController.text,
        state: _stateController.text,
        postalCode: _postalController.text,
        country: _countryController.text,
        phoneNumber: _phoneController.text,
        deliveryInstructions: _deliveryInstructionsController.text.isEmpty 
            ? null 
            : _deliveryInstructionsController.text,
        isDefault: widget.address?.isDefault ?? false,
      );

      if (widget.address == null) {
        await _addressService.createAddress(address);
      } else {
        await _addressService.updateAddress(widget.address!.id!, address);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.address == null ? 'Address added successfully' : 'Address updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save address: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.address == null ? 'Add Address' : 'Edit Address',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.grey.shade800 
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                // Address Name
                DropdownButtonFormField<String>(
                  initialValue: _selectedName,
                  decoration: InputDecoration(
                    labelText: 'Address Type',
                    labelStyle: TextStyle(
                      color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.grey.shade700 
                            : Colors.grey.shade300,
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'Home', 
                      child: Text(
                        'Home',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Work', 
                      child: Text(
                        'Work',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Other', 
                      child: Text(
                        'Other',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedName = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Custom Name (only for "Other")
                if (_selectedName == 'Other') ...[
                  TextFormField(
                    controller: _customNameController,
                    decoration: InputDecoration(
                      labelText: 'Custom Name',
                      labelStyle: TextStyle(
                        color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? Colors.grey.shade700 
                              : Colors.grey.shade300,
                        ),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                    ),
                    validator: (value) {
                      if (_selectedName == 'Other' && (value == null || value.isEmpty)) {
                        return 'Please enter a custom name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Street Address
                TextFormField(
                  controller: _streetController,
                  decoration: InputDecoration(
                    labelText: 'Street Address',
                    labelStyle: TextStyle(
                      color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.grey.shade700 
                            : Colors.grey.shade300,
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter street address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Apartment (Optional)
                TextFormField(
                  controller: _apartmentController,
                  decoration: InputDecoration(
                    labelText: 'Apartment, Suite, etc. (Optional)',
                    labelStyle: TextStyle(
                      color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.grey.shade700 
                            : Colors.grey.shade300,
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  ),
                ),
                const SizedBox(height: 16),

                // City and State
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          labelText: 'City',
                          labelStyle: TextStyle(
                            color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.grey.shade700 
                                  : Colors.grey.shade300,
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _stateController,
                        decoration: InputDecoration(
                          labelText: 'State',
                          labelStyle: TextStyle(
                            color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.grey.shade700 
                                  : Colors.grey.shade300,
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Postal Code and Country
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _postalController,
                        decoration: InputDecoration(
                          labelText: 'Postal Code',
                          labelStyle: TextStyle(
                            color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.grey.shade700 
                                  : Colors.grey.shade300,
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _countryController,
                        decoration: InputDecoration(
                          labelText: 'Country',
                          labelStyle: TextStyle(
                            color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.grey.shade700 
                                  : Colors.grey.shade300,
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Phone Number
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(
                      color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.grey.shade700 
                            : Colors.grey.shade300,
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Delivery Instructions (Optional)
                TextFormField(
                  controller: _deliveryInstructionsController,
                  decoration: InputDecoration(
                    labelText: 'Delivery Instructions (Optional)',
                    labelStyle: TextStyle(
                      color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.grey.shade700 
                            : Colors.grey.shade300,
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                    hintText: 'e.g., Ring doorbell, leave at back door',
                    hintStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.grey.shade400 
                          : Colors.grey.shade600,
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark 
                          ? const Color(0xFF2A2A2A)
                          : Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            widget.address == null ? 'Add Address' : 'Update Address',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                    ],
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
