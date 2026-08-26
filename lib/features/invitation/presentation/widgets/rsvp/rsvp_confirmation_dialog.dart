import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_common_classes/extensions/theme_extension.dart";

import "../../../../../core/gen/adobe_fonts.dart";
import "../../../../../core/gen/fonts.gen.dart";
import "../../../business/entities/guest_entity.dart";
import "../../../business/entities/invitation_entity.dart";
import "../../cubits/invitation_cubit.dart";
import "../../cubits/invitation_state.dart";

/// Dialog for guests to confirm wedding attendance and dietary preferences
class RsvpConfirmationDialog extends StatelessWidget {
  /// Creates an [RsvpConfirmationDialog] instance
  const RsvpConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: const Color(0xFFFFF9FA),
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 540,
            maxHeight: 650,
          ),
          child: BlocConsumer<InvitationCubit, InvitationState>(
            listener: (context, state) {
              if (state is InvitationLoaded && state.rsvpErrorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.rsvpErrorMessage!),
                    backgroundColor: context.colorScheme.error,
                  ),
                );
                context.read<InvitationCubit>().clearRsvpMessages();
              }
            },
            builder: (context, state) => switch (state) {
              InvitationLoading() => const Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator.adaptive(),
                      SizedBox(height: 16),
                      Text("Cargando información..."),
                    ],
                  ),
                ),
              InvitationError(failure: final failure) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: context.colorScheme.error,
                        size: 44,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        failure.message,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cerrar"),
                      ),
                    ],
                  ),
                ),
              InvitationLoaded(
                invitation: final invitation,
                isUpdatingRsvp: final isUpdating,
                updatingGuestId: final updatingGuestId,
              ) =>
                _RsvpDialogContent(
                  invitation: invitation,
                  isUpdating: isUpdating,
                  updatingGuestId: updatingGuestId,
                ),
              _ => const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Text("No se encontró información de la invitación."),
                  ),
                ),
            },
          ),
        ),
      );
}

class _RsvpDialogContent extends StatelessWidget {
  const _RsvpDialogContent({
    required this.invitation,
    required this.isUpdating,
    required this.updatingGuestId,
  });

  final InvitationEntity invitation;
  final bool isUpdating;
  final String? updatingGuestId;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Confirmar Asistencia",
                        style: TextStyle(
                          fontFamily: AdobeFonts.altesse,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF682637),
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (invitation.groupName.trim().isNotEmpty)
                        Text(
                          invitation.groupName.trim(),
                          style: const TextStyle(
                            fontFamily: FontFamily.untoldHistory,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B4B60),
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        "Por favor selecciona tu asistencia y preferencia alimenticia para cada invitado:",
                        style: TextStyle(
                          fontFamily: FontFamily.untoldHistory,
                          fontSize: 12,
                          color: const Color(0xFF682637).withValues(alpha: 0.8),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF682637),
                    size: 22,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: "Cerrar",
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE2C4C9),
          ),

          /// Guest list
          Flexible(
            child: invitation.guests.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        "No hay invitados registrados en esta invitación.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    itemCount: invitation.guests.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final guest = invitation.guests[index];
                      final isCurrentUpdating = isUpdating &&
                          (updatingGuestId == guest.id ||
                              updatingGuestId == null);
                      return _GuestRsvpCard(
                        index: index,
                        guest: guest,
                        isUpdating: isCurrentUpdating,
                        onAttendanceChanged: (status) {
                          final updatedGuest =
                              status == AttendanceStatus.notAttending
                                  ? guest.copyWith(
                                      attendance: status,
                                      dietary: DietaryRequirement.none,
                                    )
                                  : guest.copyWith(attendance: status);
                          context.read<InvitationCubit>().updateGuestRsvp(
                                updatedGuest,
                              );
                        },
                        onDietaryChanged: (dietary) {
                          context.read<InvitationCubit>().updateGuestRsvp(
                                guest.copyWith(dietary: dietary),
                              );
                        },
                      );
                    },
                  ),
          ),

          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE2C4C9),
          ),

          /// Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                if (isUpdating)
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF682637),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Guardando cambios...",
                        style: TextStyle(
                          fontFamily: FontFamily.untoldHistory,
                          fontSize: 12,
                          color: Color(0xFF682637),
                        ),
                      ),
                    ],
                  ),
                const Spacer(),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFC88A96),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Listo",
                    style: TextStyle(
                      fontFamily: FontFamily.untoldHistory,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class _GuestRsvpCard extends StatelessWidget {
  const _GuestRsvpCard({
    required this.index,
    required this.guest,
    required this.isUpdating,
    required this.onAttendanceChanged,
    required this.onDietaryChanged,
  });

  final int index;
  final GuestEntity guest;
  final bool isUpdating;
  final ValueChanged<AttendanceStatus> onAttendanceChanged;
  final ValueChanged<DietaryRequirement> onDietaryChanged;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE2C4C9),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF682637).withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 420;
            final isAttending = guest.attendance == AttendanceStatus.attending;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Guest Header & Status Badge
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: const Color(0xFFE2C4C9),
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF682637),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        guest.fullName.isNotEmpty
                            ? guest.fullName
                            : "Invitado #${index + 1}",
                        style: const TextStyle(
                          fontFamily: FontFamily.untoldHistory,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF682637),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isUpdating)
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF682637),
                        ),
                      )
                    else
                      _AttendanceBadge(status: guest.attendance),
                  ],
                ),

                const SizedBox(height: 12),

                /// Dropdowns
                if (!isAttending)
                  _AttendanceDropdown(
                    value: guest.attendance,
                    onChanged: onAttendanceChanged,
                  )
                else if (isCompact) ...[
                  _AttendanceDropdown(
                    value: guest.attendance,
                    onChanged: onAttendanceChanged,
                  ),
                  const SizedBox(height: 10),
                  _DietaryDropdown(
                    value: guest.dietary,
                    onChanged: onDietaryChanged,
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: _AttendanceDropdown(
                          value: guest.attendance,
                          onChanged: onAttendanceChanged,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DietaryDropdown(
                          value: guest.dietary,
                          onChanged: onDietaryChanged,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            );
          },
        ),
      );
}

class _AttendanceBadge extends StatelessWidget {
  const _AttendanceBadge({required this.status});

  final AttendanceStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bgColor, textColor) = switch (status) {
      AttendanceStatus.attending => (
          "Asistirá",
          const Color(0xFFE8F5E9),
          const Color(0xFF2E7D32),
        ),
      AttendanceStatus.notAttending => (
          "No asistirá",
          const Color(0xFFFFEBEE),
          const Color(0xFFC62828),
        ),
      AttendanceStatus.pending => (
          "Pendiente",
          const Color(0xFFFFF8E1),
          const Color(0xFFF57F17),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: FontFamily.untoldHistory,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

class _AttendanceDropdown extends StatelessWidget {
  const _AttendanceDropdown({
    required this.value,
    required this.onChanged,
  });

  final AttendanceStatus value;
  final ValueChanged<AttendanceStatus> onChanged;

  @override
  Widget build(BuildContext context) =>
      DropdownButtonFormField<AttendanceStatus>(
        initialValue: value,
        isDense: true,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: "Asistencia",
          labelStyle: const TextStyle(
            fontFamily: FontFamily.untoldHistory,
            fontSize: 13,
            color: Color(0xFF682637),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          filled: true,
          fillColor: const Color(0xFFFFF9FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE2C4C9)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE2C4C9)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF682637), width: 1.5),
          ),
        ),
        style: const TextStyle(
          fontFamily: FontFamily.untoldHistory,
          fontSize: 13,
          color: Color(0xFF682637),
        ),
        dropdownColor: const Color(0xFFFFF9FA),
        items: const [
          DropdownMenuItem(
            value: AttendanceStatus.attending,
            child: Text("Sí asistiré (Confirmado)"),
          ),
          DropdownMenuItem(
            value: AttendanceStatus.notAttending,
            child: Text("No podré asistir"),
          ),
          DropdownMenuItem(
            value: AttendanceStatus.pending,
            child: Text("Pendiente"),
          ),
        ],
        onChanged: (val) {
          if (val != null && val != value) {
            onChanged(val);
          }
        },
      );
}

class _DietaryDropdown extends StatelessWidget {
  const _DietaryDropdown({
    required this.value,
    required this.onChanged,
  });

  final DietaryRequirement value;
  final ValueChanged<DietaryRequirement> onChanged;

  @override
  Widget build(BuildContext context) =>
      DropdownButtonFormField<DietaryRequirement>(
        initialValue: value,
        isDense: true,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: "Preferencia alimenticia",
          labelStyle: const TextStyle(
            fontFamily: FontFamily.untoldHistory,
            fontSize: 13,
            color: Color(0xFF682637),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          filled: true,
          fillColor: const Color(0xFFFFF9FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE2C4C9)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE2C4C9)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF682637), width: 1.5),
          ),
        ),
        style: const TextStyle(
          fontFamily: FontFamily.untoldHistory,
          fontSize: 13,
          color: Color(0xFF682637),
        ),
        dropdownColor: const Color(0xFFFFF9FA),
        items: const [
          DropdownMenuItem(
            value: DietaryRequirement.none,
            child: Text("No especificado"),
          ),
          DropdownMenuItem(
            value: DietaryRequirement.meat,
            child: Text("Carne"),
          ),
          DropdownMenuItem(
            value: DietaryRequirement.vegetarian,
            child: Text("Vegetariano"),
          ),
          DropdownMenuItem(
            value: DietaryRequirement.vegan,
            child: Text("Vegano"),
          ),
        ],
        onChanged: (val) {
          if (val != null && val != value) {
            onChanged(val);
          }
        },
      );
}
