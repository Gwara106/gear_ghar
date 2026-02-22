import 'package:flutter/material.dart';
import '../../../../core/models/payment_method_model.dart';
import '../../../../core/services/payment_method_api_service.dart';

class AddEditPaymentMethodScreen extends StatefulWidget {
  final PaymentMethod? paymentMethod;

  const AddEditPaymentMethodScreen({super.key, this.paymentMethod});

  @override
  State<AddEditPaymentMethodScreen> createState() => _AddEditPaymentMethodScreenState();
}

class _AddEditPaymentMethodScreenState extends State<AddEditPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  final PaymentMethodApiService _paymentService = PaymentMethodApiService();
  
  final _cardNumberController = TextEditingController();
  final _expiryMonthController = TextEditingController();
  final _expiryYearController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardholderNameController = TextEditingController();
  final _paypalEmailController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankLastFourController = TextEditingController();

  String _selectedType = 'card';
  String _selectedCardType = 'VISA';
  String _selectedBankAccountType = 'checking';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.paymentMethod != null) {
      _populateFields(widget.paymentMethod!);
    }
  }

  void _populateFields(PaymentMethod paymentMethod) {
    _selectedType = paymentMethod.type ?? 'card';
    _selectedCardType = paymentMethod.cardType ?? 'VISA';
    _selectedBankAccountType = paymentMethod.bankAccountType ?? 'checking';
    
    if (paymentMethod.type == 'card') {
      _cardholderNameController.text = paymentMethod.cardholderName ?? '';
      _expiryMonthController.text = paymentMethod.expiryMonth ?? '';
      _expiryYearController.text = paymentMethod.expiryYear ?? '';
    } else if (paymentMethod.type == 'paypal') {
      _paypalEmailController.text = paymentMethod.paypalEmail ?? '';
    } else if (paymentMethod.type == 'bank_account') {
      _bankNameController.text = paymentMethod.bankName ?? '';
      _bankLastFourController.text = paymentMethod.bankLastFour ?? '';
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryMonthController.dispose();
    _expiryYearController.dispose();
    _cvvController.dispose();
    _cardholderNameController.dispose();
    _paypalEmailController.dispose();
    _bankNameController.dispose();
    _bankLastFourController.dispose();
    super.dispose();
  }

  Future<void> _savePaymentMethod() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      PaymentMethod paymentMethod;

      if (_selectedType == 'card') {
        paymentMethod = PaymentMethod(
          id: widget.paymentMethod?.id,
          type: _selectedType,
          cardType: _selectedCardType,
          lastFour: _cardNumberController.text.replaceAll(' ', '').substring(
            _cardNumberController.text.replaceAll(' ', '').length - 4
          ),
          expiryMonth: _expiryMonthController.text,
          expiryYear: _expiryYearController.text,
          cardholderName: _cardholderNameController.text,
          isDefault: widget.paymentMethod?.isDefault ?? false,
        );
      } else if (_selectedType == 'paypal') {
        paymentMethod = PaymentMethod(
          id: widget.paymentMethod?.id,
          type: _selectedType,
          paypalEmail: _paypalEmailController.text,
          isDefault: widget.paymentMethod?.isDefault ?? false,
        );
      } else {
        paymentMethod = PaymentMethod(
          id: widget.paymentMethod?.id,
          type: _selectedType,
          bankAccountType: _selectedBankAccountType,
          bankName: _bankNameController.text,
          bankLastFour: _bankLastFourController.text,
          isDefault: widget.paymentMethod?.isDefault ?? false,
        );
      }

      if (widget.paymentMethod == null) {
        await _paymentService.createPaymentMethod(paymentMethod);
      } else {
        await _paymentService.updatePaymentMethod(widget.paymentMethod!.id!, paymentMethod);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.paymentMethod == null 
                ? 'Payment method added successfully' 
                : 'Payment method updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save payment method: $e'),
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
      appBar: AppBar(
        title: Text(widget.paymentMethod == null ? 'Add Payment Method' : 'Edit Payment Method'),
        backgroundColor: Colors.white,
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
                // Payment Type Selection
                DropdownButtonFormField<String>(
                  initialValue: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Payment Method Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'card', child: Text('Credit/Debit Card')),
                    DropdownMenuItem(value: 'paypal', child: Text('PayPal')),
                    DropdownMenuItem(value: 'bank_account', child: Text('Bank Account')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Card Fields
                if (_selectedType == 'card') ...[
                  // Card Type
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCardType,
                    decoration: const InputDecoration(
                      labelText: 'Card Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'VISA', child: Text('Visa')),
                      DropdownMenuItem(value: 'MASTERCARD', child: Text('Mastercard')),
                      DropdownMenuItem(value: 'AMEX', child: Text('American Express')),
                      DropdownMenuItem(value: 'DISCOVER', child: Text('Discover')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCardType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Card Number
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Card Number',
                      hintText: '1234 5678 9012 3456',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.credit_card),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter card number';
                      }
                      if (value.replaceAll(' ', '').length < 13 || value.replaceAll(' ', '').length > 19) {
                        return 'Please enter a valid card number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Expiry Date and CVV
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _expiryMonthController,
                          decoration: const InputDecoration(
                            labelText: 'Expiry Month',
                            hintText: 'MM',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            final month = int.tryParse(value);
                            if (month == null || month < 1 || month > 12) {
                              return 'Invalid month';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _expiryYearController,
                          decoration: const InputDecoration(
                            labelText: 'Expiry Year',
                            hintText: 'YY',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            final year = int.tryParse(value);
                            if (year == null || year < DateTime.now().year % 100) {
                              return 'Invalid year';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _cvvController,
                          decoration: const InputDecoration(
                            labelText: 'CVV',
                            hintText: '123',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (value.length < 3 || value.length > 4) {
                              return 'Invalid CVV';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Cardholder Name
                  TextFormField(
                    controller: _cardholderNameController,
                    decoration: const InputDecoration(
                      labelText: 'Cardholder Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter cardholder name';
                      }
                      return null;
                    },
                  ),
                ],

                // PayPal Fields
                if (_selectedType == 'paypal') ...[
                  TextFormField(
                    controller: _paypalEmailController,
                    decoration: const InputDecoration(
                      labelText: 'PayPal Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter PayPal email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ],

                // Bank Account Fields
                if (_selectedType == 'bank_account') ...[
                  // Account Type
                  DropdownButtonFormField<String>(
                    initialValue: _selectedBankAccountType,
                    decoration: const InputDecoration(
                      labelText: 'Account Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'checking', child: Text('Checking')),
                      DropdownMenuItem(value: 'savings', child: Text('Savings')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedBankAccountType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Bank Name
                  TextFormField(
                    controller: _bankNameController,
                    decoration: const InputDecoration(
                      labelText: 'Bank Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter bank name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Account Number (Last 4)
                  TextFormField(
                    controller: _bankLastFourController,
                    decoration: const InputDecoration(
                      labelText: 'Account Number (Last 4 digits)',
                      hintText: '1234',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter last 4 digits';
                      }
                      if (value.length != 4) {
                        return 'Must be exactly 4 digits';
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _savePaymentMethod,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(widget.paymentMethod == null ? 'Add Payment Method' : 'Update Payment Method'),
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
