import "package:flutter/material.dart";
import "package:flutter_common_classes/extensions/theme_extension.dart";

import "../../../business/entities/invitation_entity.dart";

/// Dialog to confirm invitation deletion
class DeleteInvitationDialog extends StatelessWidget {
  /// Creates a [DeleteInvitationDialog] instance
  const DeleteInvitationDialog({
    required this.invitation,
    required this.onConfirm,
    super.key,
  });

  /// The invitation to delete
  final InvitationEntity invitation;

  /// Callback when deletion is confirmed
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: context.colorScheme.error,
              size: 26,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Eliminar Invitación",
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Text(
          "¿Estás seguro de que deseas eliminar la invitación para \"${invitation.groupName}\" y sus ${invitation.totalGuests} invitados? Esta acción no se puede deshacer.",
          style: context.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar"),
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
            child: const Text("Eliminar"),
          ),
        ],
      );
}
