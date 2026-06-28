import 'package:flutter/material.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/theme/spacing.dart';
import 'package:moto_orbito/core/widgets/app_button.dart';

final class AccountDeletionDialog extends StatefulWidget {
  const AccountDeletionDialog({super.key});

  @override
  State<AccountDeletionDialog> createState() => _AccountDeletionDialogState();
}

final class _AccountDeletionDialogState extends State<AccountDeletionDialog> {
  final _ctrl = TextEditingController();
  bool _isConfirmed = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Account'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'This action is irreversible. All your data will be permanently deleted.',
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: Spacing.md),
          Text(
            'Type DELETE to confirm:',
            style: context.textTheme.labelLarge,
          ),
          const SizedBox(height: Spacing.sm),
          TextField(
            controller: _ctrl,
            decoration: const InputDecoration(
              hintText: 'DELETE',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() => _isConfirmed = value.trim() == 'DELETE');
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Delete',
          isDisabled: !_isConfirmed,
          onTap: _isConfirmed
              ? () => Navigator.of(context).pop(true)
              : null,
        ),
      ],
    );
  }
}
