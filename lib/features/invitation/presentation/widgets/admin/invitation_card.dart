import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_common_classes/extensions/theme_extension.dart";
import "package:url_launcher/url_launcher.dart";

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
                            Flexible(
                              child: Text(
                                "/${invitation.slug}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                  fontFamily: "monospace",
                                ),
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
                  const SizedBox(width: 8),
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
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                runSpacing: 6,
                children: [
                  Text(
                    "Invitados (${invitation.totalGuests}):",
                    style: context.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
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
                    .map(
                      (guest) => _GuestChip(
                        guest: guest,
                        invitationSlug: invitation.slug,
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 14),

              // Actions Row
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
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
                    FilledButton.tonalIcon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text("Editar"),
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
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
  const _GuestChip({
    required this.guest,
    required this.invitationSlug,
  });

  final GuestEntity guest;
  final String invitationSlug;

  Future<void> _makePhoneCall(BuildContext context, String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r"[^\+0-9]"), "");
    final uri = Uri(scheme: "tel", path: cleanPhone);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("No se pudo iniciar la llamada al $phone"),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al abrir llamada: $e"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _sendWhatsAppMessage(
    BuildContext context,
    GuestEntity guest,
    String invitationSlug,
  ) async {
    final rawPhone = guest.phone ?? "";
    var cleanPhone = rawPhone.replaceAll(RegExp("[^0-9]"), "");
    if (cleanPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("El invitado no tiene un teléfono válido."),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (cleanPhone.length == 10) {
      cleanPhone = "52$cleanPhone";
    }

    final link = "${Uri.base.origin}/#/$invitationSlug";
    final message =
        "¡Hola ${guest.firstName}! Te compartimos el enlace a tu invitación para nuestra boda (Mayte & Alex): $link\n\nPor favor entra al enlace para ver los detalles y confirmar tu asistencia. ¡Esperamos contar con tu presencia! ✨";

    final uri = Uri.parse(
      "https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}",
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text("No se pudo abrir WhatsApp para el número $rawPhone"),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al abrir WhatsApp: $e"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

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

    final hasPhone = guest.phone != null && guest.phone!.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6,
        runSpacing: 4,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          Text(
            guest.fullName,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (hasPhone)
            PopupMenuButton<String>(
              tooltip: "Contactar a ${guest.fullName}",
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(12),
              onSelected: (value) {
                if (value == "call") {
                  _makePhoneCall(context, guest.phone!.trim());
                } else if (value == "whatsapp") {
                  _sendWhatsAppMessage(context, guest, invitationSlug);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "whatsapp",
                  child: Row(
                    children: [
                      const Icon(
                        Icons.chat_rounded,
                        color: Colors.green,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Enviar WhatsApp",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "Invitación con enlace",
                              style: TextStyle(
                                fontSize: 11,
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: "call",
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        color: context.colorScheme.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Llamar",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              guest.phone!.trim(),
                              style: TextStyle(
                                fontSize: 11,
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryContainer
                      .withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: context.colorScheme.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: 10,
                      color: context.colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      guest.phone!.trim(),
                      style: TextStyle(
                        fontSize: 10,
                        color: context.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 12,
                      color: context.colorScheme.onPrimaryContainer,
                    ),
                  ],
                ),
              ),
            )
          else
            Tooltip(
              message: "Sin teléfono registrado",
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "${guest.fullName} no tiene teléfono registrado. Edita la invitación para agregarlo.",
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  child: Icon(
                    Icons.phone_disabled_outlined,
                    size: 13,
                    color: context.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.35),
                  ),
                ),
              ),
            ),
          if (guest.dietary != DietaryRequirement.none)
            () {
              final (dietColor, dietIcon) = switch (guest.dietary) {
                DietaryRequirement.meat => (
                    const Color(0xff9E5A22),
                    Icons.restaurant
                  ),
                DietaryRequirement.vegetarian => (
                    const Color(0xff2E7D32),
                    Icons.eco_outlined
                  ),
                DietaryRequirement.vegan => (
                    const Color(0xff558B2F),
                    Icons.spa_outlined
                  ),
                DietaryRequirement.none => (
                    context.colorScheme.secondary,
                    Icons.check
                  ),
              };

              final text = guest.dietary.label;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: dietColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: dietColor.withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      dietIcon,
                      size: 10,
                      color: dietColor,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 10,
                        color: dietColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }(),
        ],
      ),
    );
  }
}
