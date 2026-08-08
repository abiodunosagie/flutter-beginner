import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/entitlements.dart';

class PaywallPage extends StatelessWidget {
  const PaywallPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ent = context.watch<Entitlements>();

    return Scaffold(
      appBar: AppBar(title: const Text('Go Pro')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Free plan', style: Theme.of(context).textTheme.titleLarge),
          const Text('Up to ${Entitlements.freeNoteLimit} notes.'),
          const SizedBox(height: 16),
          Text('Pro', style: Theme.of(context).textTheme.titleLarge),
          const Text('Unlimited notes + export (demo).'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: ent.isPro
                ? null
                : () async {
                    await context.read<Entitlements>().purchaseMockMonthly();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pro unlocked (mock purchase)')),
                      );
                      Navigator.of(context).pop(true);
                    }
                  },
            child: Text(ent.isPro ? 'Already Pro' : 'Subscribe monthly (mock)'),
          ),
          TextButton(
            onPressed: () => context.read<Entitlements>().restoreMock(),
            child: const Text('Restore purchases'),
          ),
          const SizedBox(height: 12),
          Text(
            'Production: swap purchaseMock for RevenueCat / StoreKit / Play Billing (Level 22).',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
