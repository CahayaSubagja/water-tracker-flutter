import 'package:flutter/material.dart';

class InputScreen extends StatefulWidget {
  final void Function(int, DateTime) onSave;
  const InputScreen({super.key, required this.onSave});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController amountController = TextEditingController(text: '300');
  DateTime chosenTime = DateTime.now();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void changeAmount(int difference) {
    int oldAmount = int.tryParse(amountController.text) ?? 0;
    int newAmount = oldAmount + difference;
    if (newAmount < 0) newAmount = 0;
    setState(() => amountController.text = '$newAmount');
  }

  Future<void> chooseTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(chosenTime),
    );
    if (picked != null) {
      setState(() {
        chosenTime = DateTime(chosenTime.year, chosenTime.month, chosenTime.day, picked.hour, picked.minute);
      });
    }
  }

  void saveDrink() {
    int? amount = int.tryParse(amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount of water')),
      );
    } else {
      widget.onSave(amount, chosenTime);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6F8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('How much did you drink?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: const Color(0xFFE1E1E1), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    IconButton(onPressed: () => changeAmount(-50), icon: const Icon(Icons.remove_circle, color: Color(0xFF83AFE9))),
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(suffixText: 'ml', border: InputBorder.none),
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(onPressed: () => changeAmount(50), icon: const Icon(Icons.add_circle, color: Color(0xFF83AFE9))),
                    const Icon(Icons.local_drink_outlined, size: 44, color: Colors.black54),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                tileColor: const Color(0xFFE1E1E1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                title: const Text('Input Time'),
                trailing: TextButton(
                  onPressed: chooseTime,
                  child: Text('${chosenTime.hour.toString().padLeft(2, '0')}:${chosenTime.minute.toString().padLeft(2, '0')}'),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveDrink,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF83AFE9), foregroundColor: Colors.black87, padding: const EdgeInsets.all(16)),
                  child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
