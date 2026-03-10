import "package:flutter/material.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:get/get.dart";

import "../../../invitation/business/entities/guest_rsvp_form_entity.dart";
import "../getX/rsvp_controller.dart";

/// Page to display the RSVP form.
class RsvpPage extends StatelessWidget {
  /// Page to display the RSVP form.
  const RsvpPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: GetX<RsvpController>(
          builder: (controller) {
            final forms = controller.guestRsvpForms;

            if (forms.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: forms.length,
                    itemBuilder: (context, index) => _GuestRsvpForm(
                      form: forms[index],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.submitRsvp,
                      child: const Text("Guardar"),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
}

class _GuestRsvpForm extends StatelessWidget {
  const _GuestRsvpForm({
    required this.form,
  });

  final GuestRsvpFormEntity form;

  @override
  Widget build(BuildContext context) => Card(
        key: ValueKey(
          "${form.guest.documentId}-${form.attendance}-${form.food}",
        ),
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FormBuilder(
            key: form.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  form.guest.name,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                FormBuilderDropdown<AttendanceOption>(
                  name: "attendance",
                  initialValue: form.attendance,
                  decoration: const InputDecoration(
                    labelText: "Asistencia",
                    border: OutlineInputBorder(),
                  ),
                  items: AttendanceOption.values
                      .map(
                        (o) => DropdownMenuItem(
                          value: o,
                          child: Text(o.label),
                        ),
                      )
                      .toList(),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 12),
                FormBuilderDropdown<FoodOption>(
                  name: "food",
                  initialValue: form.food,
                  decoration: const InputDecoration(
                    labelText: "Comida",
                    border: OutlineInputBorder(),
                  ),
                  items: FoodOption.values
                      .map(
                        (o) => DropdownMenuItem(
                          value: o,
                          child: Text(o.label),
                        ),
                      )
                      .toList(),
                  validator: FormBuilderValidators.required(),
                ),
              ],
            ),
          ),
        ),
      );
}
