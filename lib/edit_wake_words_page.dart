import 'package:flutter/material.dart';

class EditWakeWordsPage extends StatefulWidget {
  final Map<String, String> appWakeWords;
  final Function(Map<String, String>) onSave;

  const EditWakeWordsPage({
    super.key,
    required this.appWakeWords,
    required this.onSave,
  });

  @override
  _EditWakeWordsPageState createState() => _EditWakeWordsPageState();
}

class _EditWakeWordsPageState extends State<EditWakeWordsPage> {
  late Map<String, String> _editedWakeWords;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _editedWakeWords = Map.from(widget.appWakeWords);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Wake Words'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              widget.onSave(_editedWakeWords);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _editedWakeWords.length,
        itemBuilder: (context, index) {
          String packageName = _editedWakeWords.keys.elementAt(index);
          String wakeWord = _editedWakeWords[packageName] ?? '';

          if (!_controllers.containsKey(packageName)) {
            _controllers[packageName] = TextEditingController(text: wakeWord);
          }

          return ListTile(
            title: Text(packageName),
            subtitle: TextField(
              decoration: const InputDecoration(labelText: 'Wake Word'),
              controller: _controllers[packageName],
              onChanged: (value) {
                setState(() {
                  _editedWakeWords[packageName] = value;
                });
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
