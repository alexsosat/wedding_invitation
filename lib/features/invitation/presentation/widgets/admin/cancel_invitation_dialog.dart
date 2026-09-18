import "package:flutter/material.dart";
import "package:flutter_common_classes/extensions/theme_extension.dart";

import "../../../business/entities/invitation_entity.dart";

/// Dialog to confirm invitation cancellation
class CancelInvitationDialog extends StatelessWidget {
  /// Creates a [CancelInvitationDialog] instance
  const CancelInvitationDialog({
    required this.invitation,
    required this.onConfirm,
    super.key,
  });

  /// The invitation to cancel
  final InvitationEntity invitation;

  /// Callback when cancellation is confirmed
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.block,
              color: context.colorScheme.error,
              size: 26,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Cancelar Invitación",
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Text(
          "¿Estás seguro de que deseas cancelar la invitación para \"${invitation.groupName}\"? "
          "Sus invitados perderán acceso al enlace hasta que la reactives. Los datos e invitados no se eliminarán.",
          style: context.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Volver"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.colorScheme.error,
              foregroundColor: context.colorScheme.onError,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text("Cancelar Invitación"),
          ),
        ],
      );
}
