import 'package:dart_backend/controllers/event_controller.dart';
import 'package:dart_backend/models/event.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:dart_backend/utils/toastification.dart';
import 'package:dart_backend/views/widgets/input_field.dart';
import 'package:dart_backend/views/widgets/select_option.dart';
import 'package:dart_backend/views/widgets/submit_form.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class EventForm extends StatefulWidget {
  final Event? model;
  final EventController controller;

  const EventForm({super.key, this.model, required this.controller});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  late final Event? _model;
  late final EventController _controller;
  late final TextEditingController _name;
  late final TextEditingController _note;
  late int _remind;
  final remindOptions = [5, 10, 15, 20];
  late Color _color;
  late DateTime _date, _start, _end;
  late EventStatus _status;
  late RepeatRule _repeat;

  @override
  void initState() {
    super.initState();
    _model = widget.model;
    _controller = widget.controller;

    _name = TextEditingController(text: _model?.title ?? '');
    _note = TextEditingController(text: _model?.note ?? '');
    _remind = _model?.remindMin ?? 5;
    _repeat = _model?.repeatRule ?? RepeatRule.none;
    _status = _model?.status ?? EventStatus.pending;
    _color = _model?.color ?? Colors.green;
    _date = _model?.eventDate == null ? dateNow() : strDate(_model!.eventDate);
    _start = _model?.startTime == null ? dateNow() : strDate(_model!.startTime);
    _end = _model?.endTime == null
        ? dateNow().add(const Duration(minutes: 10))
        : strDate(_model!.endTime);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SubmitForm(
      formKey: _formKey,
      onPressed: () async {
        if (!_formKey.currentState!.validate()) return;
        final name = _name.text.trim();
        final note = _note.text.trim();
        final date = _date.toIso8601String();
        final start = _start.toIso8601String();
        final end = _end.toIso8601String();
        final err = _controller.errorMessage.value;

        if (_model == null) {
          await _controller.store(
            Event(
              title: name,
              note: note,
              eventDate: date,
              startTime: start,
              endTime: end,
              color: _color,
              remindMin: _remind,
              repeatRule: _repeat,
              status: _status,
            ),
          );

          if (!context.mounted) return;

          if (err.isNotEmpty) {
            showToast(
              context,
              type: Toast.error,
              autoClose: 5,
              title: 'Creating Failed!',
              message: err,
            );
            debugPrint("Failed: $err");
          } else {
            showToast(
              context,
              type: Toast.info,
              title: 'Created New',
              message: 'Created successfully.',
            );
            await _controller.index();
            _formKey.currentState!.reset();
            Get.back();
          }
        } else {
          await _controller.change(
            _model!.copyWith(
              title: name,
              note: note,
              eventDate: date,
              startTime: start,
              endTime: end,
              color: _color,
              remindMin: _remind,
              repeatRule: _repeat,
              status: _status,
            ),
          );
          if (!context.mounted) return;

          if (err.isNotEmpty) {
            showToast(
              context,
              type: Toast.error,
              autoClose: 5,
              title: 'Modifying Failed!',
              message: err,
            );
            debugPrint("Failed: $err");
          } else {
            showToast(
              context,
              title: 'Modified Existing',
              message: 'Updated successfully.',
            );

            _formKey.currentState!.reset();
            Get.back();
          }
        }
      },
      labelBtn: _model == null ? 'Save' : 'Update',
      iconBtn: _model == null ? Icons.save : Icons.update,
      colorBtn: _model == null ? colors.primary : colors.outline,
      children: [
        InputField(
          label: 'Title',
          controller: _name,
          autofocus: true,
          validator: (v) =>
              (v == null || v.isEmpty) ? 'This field is required' : null,
        ),
        _dateTime(),
        _selectOption(),
        InputField(
          label: 'Note',
          controller: _note,
          maxLines: 2,
          validator: (v) =>
              (v == null || v.isEmpty) ? 'This field is required' : null,
        ),
        ColorPicker(
          color: _color,
          onColorChanged: (value) {
            setState(() {
              _color = value;
            });
          },
        ),
      ],
    );
  }

  Widget _dateTime() {
    return Container(
      margin: EdgeInsets.only(top: 2, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date'),
              TimePickerSpinnerPopUp(
                mode: CupertinoDatePickerMode.date,
                initTime: _date,
                timeFormat: 'd MMMM yyyy',
                onChange: (dateTime) {
                  setState(() {
                    _date = dateTime;
                  });
                },
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Start time'),
              TimePickerSpinnerPopUp(
                mode: CupertinoDatePickerMode.time,
                initTime: _start,
                onChange: (dateTime) {
                  setState(() {
                    _start = dateTime;
                  });
                },
                timeFormat: 'h:m a',
                use24hFormat: false,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('End time'),
              TimePickerSpinnerPopUp(
                mode: CupertinoDatePickerMode.time,
                initTime: _end,
                onChange: (dateTime) {
                  setState(() {
                    _end = dateTime;
                  });
                },
                timeFormat: 'h:m a',
                use24hFormat: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _selectOption() {
    return Wrap(
      children: [
        SelectOption<int>(
          label: 'Remind',
          hint: '$_remind minutes early',
          options: remindOptions.map((item) {
            return DropdownMenuItem<int>(
              value: item,
              child: Text(
                '$item minutes early',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) => setState(() {
            _remind = value!;
          }),
        ),
        SelectOption<RepeatRule>(
          label: 'Repeat',
          hint: _repeat.label,
          options: RepeatRule.values.map((item) {
            return DropdownMenuItem<RepeatRule>(
              value: item,
              child: Text(
                item.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) => setState(() {
            _repeat = value!;
          }),
        ),
        SelectOption<EventStatus>(
          label: 'Status',
          hint: _status.label,
          options: EventStatus.values.map((item) {
            return DropdownMenuItem<EventStatus>(
              value: item,
              child: Text(
                item.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) => setState(() {
            _status = value!;
          }),
        ),
      ],
    );
  }
}
