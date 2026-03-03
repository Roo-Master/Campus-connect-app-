import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  GlobalKey<FormState> final_formKey = GlobalKey<FormState>();
  String eventName = '';
  DateTime eventDate = DateTime.now();
  bool isLoading = false;

  // Date Picker function
  Future<void> _selectEventDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: eventDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != eventDate) {
      setState(() {
        eventDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: final_formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Event Name TextFormField
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Event Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.event),
                  ),
                  onChanged: (value) => setState(() {
                    eventName = value;
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the event name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Event Date Picker Button
                InkWell(
                  onTap: () => _selectEventDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.blue),
                        const SizedBox(width: 10),
                        Text(
                          'Event Date: ${eventDate.toLocal()}'.split(' ')[0],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Create Event Button
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: () async {
                    if (final_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });

                      // Simulate a network request for event creation
                      await Future.delayed(const Duration(seconds: 2));

                      setState(() {
                        isLoading = false;
                      });

                      // Show success message or handle post-creation logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Event Created!')),
                      );
                    }
                  },
                  child: const Text('Create Event'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}