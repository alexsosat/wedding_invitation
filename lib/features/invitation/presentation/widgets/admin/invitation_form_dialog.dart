import "package:flutter/material.dart";
import "package:flutter_common_classes/extensions/theme_extension.dart";

import "../../../business/entities/guest_entity.dart";
import "../../../business/entities/invitation_entity.dart";
import "guest_form_item.dart";

/// Dialog for creating or editing an invitation and its guest list
class InvitationFormDialog extends StatefulWidget {
  /// Creates an [InvitationFormDialog] instance
  const InvitationFormDialog({
    required this.onSave,
    this.invitation,
    super.key,
  });

  /// The invitation to edit, or null if creating a new one
  final InvitationEntity? invitation;

  /// Callback when saving the invitation
  final ValueChanged<InvitationEntity> onSave;

  @override
  State<InvitationFormDialog> createState() => _InvitationFormDialogState();
}

class _GuestDraft {
  _GuestDraft({
    required this.id,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.attendance,
    required this.dietary,
    required this.dietaryDetailsController,
  });

  final String id;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  AttendanceStatus attendance;
  DietaryRequirement dietary;
  final TextEditingController dietaryDetailsController;

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    dietaryDetailsController.dispose();
  }
}

class _InvitationFormDialogState extends State<InvitationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _groupNameController;
  late final TextEditingController _slugController;
  late bool _isSent;
  final List<_GuestDraft> _guests = [];

  @override
  void initState() {
    super.initState();
    final inv = widget.invitation;
    _groupNameController = TextEditingController(text: inv?.groupName ?? "");
    _slugController = TextEditingController(text: inv?.slug ?? "");
    _isSent = inv?.isSent ?? false;

    if (inv != null && inv.guests.isNotEmpty) {
      for (final g in inv.guests) {
        _guests.add(
          _GuestDraft(
            id: g.id,
            firstNameController: TextEditingController(text: g.firstName),
            lastNameController: TextEditingController(text: g.lastName),
            phoneController: TextEditingController(text: g.phone ?? ""),
            attendance: g.attendance,
            dietary: g.dietary,
            dietaryDetailsController:
                TextEditingController(text: g.dietaryDetails ?? ""),
          ),
        );
      }
    } else {
      _addNewGuest();
    }
  }

  void _addNewGuest() {
    setState(() {
      _guests.add(
        _GuestDraft(
          id: "",
          firstNameController: TextEditingController(),
          lastNameController: TextEditingController(),
          phoneController: TextEditingController(),
          attendance: AttendanceStatus.pending,
          dietary: DietaryRequirement.none,
          dietaryDetailsController: TextEditingController(),
        ),
      );
    });
  }

  void _removeGuest(int index) {
    if (_guests.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La invitación debe contener al menos un invitado"),
        ),
      );
      return;
    }
    setState(() {
      _guests.removeAt(index).dispose();
    });
  }

  void _autoGenerateSlug() {
    final text = _groupNameController.text.trim().toLowerCase();
    if (text.isEmpty) {
      return;
    }

    final slug = text
        .replaceAll(RegExp("[áàäâ]"), "a")
        .replaceAll(RegExp("[éèëê]"), "e")
        .replaceAll(RegExp("[íìïî]"), "i")
        .replaceAll(RegExp("[óòöô]"), "o")
        .replaceAll(RegExp("[úùüû]"), "u")
        .replaceAll(RegExp("[ñ]"), "n")
        .replaceAll(RegExp(r"[^a-z0-9\s-]"), "")
        .replaceAll(RegExp(r"\s+"), "-")
        .replaceAll(RegExp("-+"), "-");

    _slugController.text = slug;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final guestsEntities = _guests
        .map(
          (g) => GuestEntity(
            id: g.id,
            firstName: g.firstNameController.text.trim(),
            lastName: g.lastNameController.text.trim(),
            phone: g.phoneController.text.trim().isNotEmpty
                ? g.phoneController.text.trim()
                : null,
            attendance: g.attendance,
            dietary: g.dietary,
            dietaryDetails: null,
            invitationId: widget.invitation?.id ?? "",
          ),
        )
        .toList();

    final result = InvitationEntity(
      id: widget.invitation?.id ?? "",
      groupName: _groupNameController.text.trim(),
      slug: _slugController.text.trim(),
      isSent: _isSent,
      sentAt: _isSent ? (widget.invitation?.sentAt ?? DateTime.now()) : null,
      createdAt: widget.invitation?.createdAt ?? DateTime.now(),
      guests: guestsEntities,
    );

    widget.onSave(result);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _slugController.dispose();
    for (final g in _guests) {
      g.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.invitation != null;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 750),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        isEditing ? "Editar Invitación" : "Nueva Invitación",
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _groupNameController,
                        decoration: const InputDecoration(
                          labelText: "Nombre del Grupo / Familia *",
                          hintText: "Ej. Familia Sosa Pérez",
                          prefixIcon: Icon(Icons.group_outlined),
                        ),
                        onChanged: (_) {
                          if (!isEditing && _slugController.text.isEmpty) {
                            _autoGenerateSlug();
                          }
                        },
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? "Ingresa el nombre del grupo"
                                : null,
                      ),
                      const SizedBox(height: 14),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth < 360) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextFormField(
                                  controller: _slugController,
                                  decoration: const InputDecoration(
                                    labelText: "Slug de URL *",
                                    hintText: "ej. familia-sosa-perez",
                                    prefixIcon: Icon(Icons.link),
                                  ),
                                  validator: (value) =>
                                      value == null || value.trim().isEmpty
                                          ? "Ingresa un slug válido"
                                          : null,
                                ),
                                const SizedBox(height: 8),
                                OutlinedButton.icon(
                                  onPressed: _autoGenerateSlug,
                                  icon: const Icon(Icons.auto_awesome, size: 16),
                                  label: const Text("Generar Slug"),
                                ),
                              ],
                            );
                          }
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _slugController,
                                  decoration: const InputDecoration(
                                    labelText: "Slug de URL *",
                                    hintText: "ej. familia-sosa-perez",
                                    prefixIcon: Icon(Icons.link),
                                  ),
                                  validator: (value) =>
                                      value == null || value.trim().isEmpty
                                          ? "Ingresa un slug válido"
                                          : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: OutlinedButton.icon(
                                  onPressed: _autoGenerateSlug,
                                  icon: const Icon(Icons.auto_awesome, size: 16),
                                  label: const Text("Generar"),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Invitación enviada"),
                        subtitle: Text(
                          _isSent
                              ? "Marcada como entregada a los invitados"
                              : "Pendiente de envío",
                          style: context.textTheme.bodySmall,
                        ),
                        value: _isSent,
                        onChanged: (val) => setState(() => _isSent = val),
                      ),
                      const Divider(height: 32),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Text(
                            "Lista de Invitados (${_guests.length})",
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.primary,
                            ),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: _addNewGuest,
                            icon: const Icon(Icons.person_add_alt_1, size: 18),
                            label: const Text("Agregar"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      for (int i = 0; i < _guests.length; i++)
                        GuestFormItem(
                          key: ValueKey("guest_$i"),
                          index: i,
                          firstNameController: _guests[i].firstNameController,
                          lastNameController: _guests[i].lastNameController,
                          phoneController: _guests[i].phoneController,
                          attendance: _guests[i].attendance,
                          dietary: _guests[i].dietary,
                          dietaryDetailsController:
                              _guests[i].dietaryDetailsController,
                          onAttendanceChanged: (val) =>
                              setState(() => _guests[i].attendance = val),
                          onDietaryChanged: (val) =>
                              setState(() => _guests[i].dietary = val),
                          onRemove: () => _removeGuest(i),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancelar"),
                    ),
                    FilledButton(
                      onPressed: _submit,
                      child: Text(isEditing ? "Guardar Cambios" : "Crear"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
