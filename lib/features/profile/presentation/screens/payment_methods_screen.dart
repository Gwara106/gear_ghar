import 'package:flutter/material.dart';
import 'package:gear_ghar/shared/widgets/primary_app_bar.dart';
import '../../../../core/models/payment_method_model.dart';
import '../../../../core/services/payment_method_api_service.dart';
import 'add_edit_payment_method_screen.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final PaymentMethodApiService _paymentService = PaymentMethodApiService();
  List<PaymentMethod> _paymentMethods = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final paymentMethods = await _paymentService.getPaymentMethods();
      setState(() {
        _paymentMethods = paymentMethods;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deletePaymentMethod(PaymentMethod paymentMethod) async {
    try {
      await _paymentService.deletePaymentMethod(paymentMethod.id!);
      _loadPaymentMethods();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment method deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete payment method: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _setDefaultPaymentMethod(PaymentMethod paymentMethod) async {
    try {
      await _paymentService.setDefaultPaymentMethod(paymentMethod.id!);
      _loadPaymentMethods();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Default payment method updated'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to set default payment method: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: 'Payment Methods'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading payment methods',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(_error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadPaymentMethods,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _paymentMethods.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payment_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No payment methods yet',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text('Add your first payment method to get started'),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _navigateToAddEditPaymentMethod(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Payment Method'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadPaymentMethods,
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _paymentMethods.length,
                itemBuilder: (context, index) {
                  final paymentMethod = _paymentMethods[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildPaymentMethodCard(context, paymentMethod),
                  );
                },
              ),
            ),
      floatingActionButton: _paymentMethods.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _navigateToAddEditPaymentMethod(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    PaymentMethod paymentMethod,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: paymentMethod.isDefault == true
              ? Theme.of(context).primaryColor
              : Colors.grey.shade300,
          width: paymentMethod.isDefault == true ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _getPaymentIcon(paymentMethod),
                    const SizedBox(width: 12),
                    Text(
                      paymentMethod.displayText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (paymentMethod.isDefault == true)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'DEFAULT',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (paymentMethod.expiryDate.isNotEmpty)
                  Text(
                    'Expires ${paymentMethod.expiryDate}',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  )
                else
                  const SizedBox.shrink(),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () => _navigateToAddEditPaymentMethod(
                        paymentMethod: paymentMethod,
                      ),
                      color: Colors.grey[600],
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: paymentMethod.isDefault == true
                          ? null
                          : () =>
                                _showDeleteConfirmation(context, paymentMethod),
                      color: paymentMethod.isDefault == true
                          ? Colors.grey[400]
                          : Colors.red[400],
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
            if (paymentMethod.isDefault != true) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => _setDefaultPaymentMethod(paymentMethod),
                  child: const Text('Set as Default'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _getPaymentIcon(PaymentMethod paymentMethod) {
    switch (paymentMethod.type) {
      case 'card':
        if (paymentMethod.cardType == 'VISA') {
          return Image.asset(
            'assets/images/visa.png',
            height: 24,
            width: 40,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.credit_card, size: 24),
          );
        } else if (paymentMethod.cardType == 'MASTERCARD') {
          return Image.asset(
            'assets/images/mastercard.png',
            height: 24,
            width: 40,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.credit_card, size: 24),
          );
        }
        return const Icon(Icons.credit_card, size: 24);
      case 'paypal':
        return Image.asset(
          'assets/images/paypal.png',
          height: 24,
          width: 24,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.payment, size: 24),
        );
      case 'bank_account':
        return const Icon(Icons.account_balance, size: 24);
      default:
        return const Icon(Icons.credit_card, size: 24);
    }
  }

  void _navigateToAddEditPaymentMethod({PaymentMethod? paymentMethod}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddEditPaymentMethodScreen(paymentMethod: paymentMethod),
      ),
    ).then((_) => _loadPaymentMethods());
  }

  void _showDeleteConfirmation(
    BuildContext context,
    PaymentMethod paymentMethod,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Payment Method'),
          content: const Text(
            'Are you sure you want to remove this payment method?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deletePaymentMethod(paymentMethod);
              },
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
