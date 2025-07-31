import 'package:dart_backend/models/event.dart';
import 'package:dart_backend/views/widgets/body_content.dart';
import 'package:dart_backend/views/widgets/input_field.dart';
import 'package:dart_backend/views/widgets/nav_bar.dart';
import 'package:dart_backend/views/widgets/select_option.dart';
import 'package:dart_backend/views/widgets/submit_form.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class EventForm extends StatefulWidget {
  final Event? model;
  const EventForm({super.key, this.model});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  late final Event? _model;
  late final TextEditingController _name;
  late final TextEditingController _note;
  int _selectedRemind = 5;
  final remindOptions = [5, 10, 15, 20];
  Color _selectedColor = Colors.green;

  String _selectedRepeat = 'None';
  final repeatOptions = ['None', 'Daily', 'Weekly', 'Monthly'];

  @override
  void initState() {
    super.initState();
    _model = widget.model;
    _name = TextEditingController(text: _model?.title ?? '');
    _note = TextEditingController(text: _model?.title ?? '');
    // _selectedRemind = _model.
  }

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;

    return BodyContent(
      header: NavBar(title: "Task"),
      content: SubmitForm(
        formKey: _formKey,
        children: [
          InputField(
            label: 'Title',
            controller: _name,
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
            color: _selectedColor,
            onColorChanged: (value) {
              setState(() {
                _selectedColor = value;
                debugPrint('The value: $_selectedColor');
              });
            },
          ),
        ],
        onPressed: () {
          if (!_formKey.currentState!.validate()) return;
        },
      ),
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
                initTime: DateTime.now(),
                timeFormat: 'd MMMM yyyy',
                onChange: (dateTime) {
                  debugPrint('The Datetime: $dateTime');
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
                initTime: DateTime.now(),
                onChange: (dateTime) {
                  debugPrint('The Datetime: $dateTime');
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
                initTime: DateTime.now(),
                onChange: (dateTime) {
                  debugPrint('The Datetime: $dateTime');
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
          hint: '$_selectedRemind minutes early',
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
            _selectedRemind = value!;
            debugPrint('The value: $_selectedRemind');
          }),
        ),
        SelectOption<String>(
          label: 'Repeat',
          hint: _selectedRepeat,
          options: repeatOptions.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) => setState(() {
            _selectedRepeat = value!;
            debugPrint('The value: $_selectedRepeat');
          }),
        ),
      ],
    );
  }
}
