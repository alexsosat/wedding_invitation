import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_common_classes/extensions/theme_extension.dart";

import "../../../business/entities/guest_entity.dart";
import "../../../business/entities/invitation_entity.dart";

/// Card widget to display a single invitation with guest details and actions
class InvitationCard extends StatelessWidget {
  /// Creates an [InvitationCard] instance
  const InvitationCard({
    required this.invitation,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleSent,
    super.key,
  });

  /// The invitation to display
  final InvitationEntity invitation;

  /// Callback when edit is pressed
  final VoidCallback onEdit;

  /// Callback when delete is pressed
  final VoidCallback onDelete;

  /// Callback when sent status is toggled
  final ValueChanged<bool> onToggleSent;

  void _copyInvitationLink(BuildContext context) {
    final link = "${Uri.base.origin}/#/${invitation.slug}";
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Enlace copiado al portapapeles: $link"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: context.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        color: context.colorScheme.surfaceBright,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Group Name & Sent Status Toggle
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invitation.groupName,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.link,
                              size: 16,
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "/${invitation.slug}",
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                                fontFamily: "monospace",
                              ),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () => _copyInvitationLink(context),
                              borderRadius: BorderRadius.circular(4),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                child: Icon(
                                  Icons.copy_rounded,
                                  size: 14,
                                  color: context.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Sent Status Badge & Toggle
                  InkWell(
                    onTap: () => onToggleSent(!invitation.isSent),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: invitation.isSent
                            ? Colors.green.withValues(alpha: 0.12)
                            : Colors.orange.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: invitation.isSent
                              ? Colors.green.withValues(alpha: 0.3)
                              : Colors.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            invitation.isSent
                                ? Icons.check_circle_outline
                                : Icons.schedule,
                            size: 15,
                            color: invitation.isSent
                                ? Colors.green.shade800
                                : Colors.orange.shade800,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            invitation.isSent ? "Enviada" : "Por enviar",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: invitation.isSent
                                  ? Colors.green.shade800
                                  : Colors.orange.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Guests Summary & Badges
              Row(
                children: [
                  Text(
                    "Invitados (${invitation.totalGuests}):",
                    style: context.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (invitation.attendingGuestsCount > 0)
                    _StatusCounterBadge(
                      count: invitation.attendingGuestsCount,
                      label: "Asiste",
                      color: Colors.green,
                    ),
                  if (invitation.declinedGuestsCount > 0)
                    _StatusCounterBadge(
                      count: invitation.declinedGuestsCount,
                      label: "Declina",
                      color: Colors.red,
                    ),
                  if (invitation.pendingGuestsCount > 0)
                    _StatusCounterBadge(
                      count: invitation.pendingGuestsCount,
                      label: "Pendiente",
                      color: Colors.orange,
                    ),
                ],
              ),
              const SizedBox(height: 10),

              // Guest Chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: invitation.guests
                    .map((guest) => _GuestChip(guest: guest))
                    .toList(),
              ),

              const SizedBox(height: 14),

              // Actions Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _copyInvitationLink(context),
                    icon: const Icon(Icons.share_outlined, size: 16),
                    label: const Text("Copiar Link"),
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonalIcon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text("Editar"),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outline,
                      color: context.colorScheme.error,
                      size: 20,
                    ),
                    tooltip: "Eliminar",
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

class _StatusCounterBadge extends StatelessWidget {
  const _StatusCounterBadge({
    required this.count,
    required this.label,
    required this.color,
  });

  final int count;
  final String label;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "$count $label",
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color.shade800,
          ),
        ),
      );
}

class _GuestChip extends StatelessWidget {
  const _GuestChip({required this.guest});

  final GuestEntity guest;

  @override
  Widget build(BuildContext context) {
    final (color, icon, _) = switch (guest.attendance) {
      AttendanceStatus.attending => (
          Colors.green,
          Icons.check_circle,
          "Confirmado"
        ),
      AttendanceStatus.notAttending => (
          Colors.red,
          Icons.cancel,
          "No asistirá"
        ),
      AttendanceStatus.pending => (
          Colors.orange,
          Icons.help_outline,
          "Pendiente"
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            guest.fullName,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (guest.dietary != DietaryRequirement.none) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: context.colorScheme.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                guest.dietary == DietaryRequirement.custom &&
                        guest.dietaryDetails != null &&
                        guest.dietaryDetails!.isNotEmpty
                    ? guest.dietaryDetails!
                    : guest.dietary.value,
                style: TextStyle(
                  fontSize: 10,
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
