import 'package:flutter/material.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/glass_container.dart';
import '../../../widgets/animated_card.dart';
import '../../../utils/app_colors.dart';

void proceedToCheckout(
  BuildContext context, {
  required double totalPrice,
  VoidCallback? clearCart,
}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: GlassContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.success, Colors.green.shade400],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.payment_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Payment Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Total Amount: ৳${totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                buildPaymentOption(
                    context, 'bKash', Icons.phone_android_rounded, AppColors.accent, clearCart),
                const SizedBox(height: 12),
                buildPaymentOption(
                    context, 'Nagad', Icons.account_balance_wallet_rounded, AppColors.warning, clearCart),
                const SizedBox(height: 12),
                buildPaymentOption(
                    context, 'Cash on Delivery', Icons.local_shipping_rounded, AppColors.primary, clearCart),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildPaymentOption(
  BuildContext context,
  String title,
  IconData icon,
  Color color,
  VoidCallback? clearCart,
) {
  return AnimatedCard(
    onTap: () => processPayment(context, title, clearCart),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
        ],
      ),
    ),
  );
}

void processPayment(
  BuildContext context,
  String method,
  VoidCallback? clearCart,
) {
  Navigator.pop(context); // Close payment dialog ONLY

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: GlassContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 20),
            Text('Processing payment via $method...'),
          ],
        ),
      ),
    ),
  );

  Future.delayed(const Duration(seconds: 2), () {
    Navigator.pop(context); // Close processing dialog

    if (clearCart != null) {
      clearCart(); // Call only if provided
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
            'Order placed successfully! Your items will be delivered soon.'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  });
}

