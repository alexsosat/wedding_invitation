import "package:flutter/material.dart";
import "package:flutter_common_classes/extensions/theme_extension.dart";

import "../../../business/entities/guest_entity.dart";

/// Editable item representing a single guest within the invitation form
class GuestFormItem extends StatelessWidget {
  /// Creates a [GuestFormItem] instance
  const GuestFormItem({
    required this.index,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.attendance,
    required this.dietary,
    required this.dietaryDetailsController,
    required this.onAttendanceChanged,
    required this.onDietaryChanged,
    required this.onRemove,
    super.key,
  });

  /// Index position of the guest
  final int index;

  /// Controller for first name
  final TextEditingController firstNameController;

  /// Controller for last name
  final TextEditingController lastNameController;

  /// Controller for phone number
  final TextEditingController phoneController;

  /// Selected attendance status
  final AttendanceStatus attendance;

  /// Selected dietary requirement
  final DietaryRequirement dietary;

  /// Controller for custom dietary notes
  final TextEditingController dietaryDetailsController;

  /// Callback when attendance changes
  final ValueChanged<AttendanceStatus> onAttendanceChanged;

  /// Callback when dietary changes
  final ValueChanged<DietaryRequirement> onDietaryChanged;

  /// Callback to remove this guest
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceBright,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.colorScheme.outline.withValues(alpha: 0.25),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 420;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: context.colorScheme.primaryContainer,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Invitado #${index + 1}",
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: context.colorScheme.error,
                        size: 20,
                      ),
                      tooltip: "Eliminar invitado",
                      onPressed: onRemove,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (isCompact) ...[
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: "Nombre(s) *",
                      isDense: true,
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? "Requerido"
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: "Apellidos",
                      isDense: true,
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: firstNameController,
                          decoration: const InputDecoration(
                            labelText: "Nombre(s) *",
                            isDense: true,
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? "Requerido"
                                  : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: lastNameController,
                          decoration: const InputDecoration(
                            labelText: "Apellidos",
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 10),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Teléfono (opcional)",
                    hintText: "+52 123 456 7890",
                    prefixIcon: Icon(Icons.phone_outlined, size: 18),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 10),
                if (isCompact) ...[
                  DropdownButtonFormField<AttendanceStatus>(
                    initialValue: attendance,
                    isDense: true,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: "Asistencia",
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: AttendanceStatus.pending,
                        child: Text("Pendiente"),
                      ),
                      DropdownMenuItem(
                        value: AttendanceStatus.attending,
                        child: Text("Confirmado"),
                      ),
                      DropdownMenuItem(
                        value: AttendanceStatus.notAttending,
                        child: Text("No asistirá"),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        onAttendanceChanged(val);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<DietaryRequirement>(
                    initialValue: dietary,
                    isDense: true,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: "Dieta",
                    ),
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
                      if (val != null) {
                        onDietaryChanged(val);
                      }
                    },
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<AttendanceStatus>(
                          initialValue: attendance,
                          isDense: true,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: "Asistencia",
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: AttendanceStatus.pending,
                              child: Text("Pendiente"),
                            ),
                            DropdownMenuItem(
                              value: AttendanceStatus.attending,
                              child: Text("Confirmado"),
                            ),
                            DropdownMenuItem(
                              value: AttendanceStatus.notAttending,
                              child: Text("No asistirá"),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              onAttendanceChanged(val);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<DietaryRequirement>(
                          initialValue: dietary,
                          isDense: true,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: "Dieta",
                          ),
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
                            if (val != null) {
                              onDietaryChanged(val);
                            }
                          },
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
