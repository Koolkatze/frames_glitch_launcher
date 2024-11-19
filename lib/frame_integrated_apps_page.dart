import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:frames_glitch_launcher/home_page.dart';
import 'dart:io';
import 'dart:convert';

class FrameIntegratedAppsPage extends StatefulWidget {
  const FrameIntegratedAppsPage({Key? key}) : super(key: key);

  @override
  _FrameIntegratedAppsPageState createState() =>
      _FrameIntegratedAppsPageState();
}

class _FrameIntegratedAppsPageState extends State<FrameIntegratedAppsPage> {
  List<Map<String, dynamic>> _apps = [];
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _wakeWordController = TextEditingController();
  final _dartCodeController = TextEditingController();
  final _luaFileNameController = TextEditingController();
  final _luaCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/frame_integrated_apps.json');
    if (await file.exists()) {
      final contents = await file.readAsString();
      setState(() {
        _apps = List<Map<String, dynamic>>.from(json.decode(contents));
      });
    }
  }

  Future<void> _saveApps() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/frame_integrated_apps.json');
    await file.writeAsString(json.encode(_apps));
  }

  Future<void> _saveDartFile(String appName, String dartCode) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/lib/$appName.dart');
    await file.create(recursive: true);
    await file.writeAsString(dartCode);
  }

  Future<void> _saveLuaFile(String luaFileName, String luaCode) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/assets/$luaFileName.lua');
    await file.create(recursive: true);
    await file.writeAsString(luaCode);
  }

  void _addApp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _apps.add({
          'name': _nameController.text,
          'wakeWord': _wakeWordController.text,
          'dartCode': _dartCodeController.text,
          'luaFileName': _luaFileNameController.text,
          'luaCode': _luaCodeController.text,
        });
      });
      _saveApps();
      _saveDartFile(_nameController.text, _dartCodeController.text);
      _saveLuaFile(_luaFileNameController.text, _luaCodeController.text);
      _nameController.clear();
      _wakeWordController.clear();
      _dartCodeController.clear();
      _luaFileNameController.clear();
      _luaCodeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
        title: const Text('Frame Integrated Apps'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                          labelText: 'App Name (.dart file)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an app name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _wakeWordController,
                      decoration: const InputDecoration(labelText: 'Wake Word'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a wake word';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _dartCodeController,
                      decoration: const InputDecoration(labelText: 'Dart Code'),
                      maxLines: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Dart code';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _luaFileNameController,
                      decoration:
                          const InputDecoration(labelText: 'Lua File Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Lua file name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _luaCodeController,
                      decoration: const InputDecoration(labelText: 'Lua Code'),
                      maxLines: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Lua code';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addApp,
                      child: const Text('Add App'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text('Saved Apps',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _apps.length,
                itemBuilder: (context, index) {
                  final app = _apps[index];
                  return Card(
                    child: ListTile(
                      title: Text(app['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Wake Word: ${app['wakeWord']}'),
                          Text('Lua File: ${app['luaFileName']}.lua'),
                        ],
                      ),
                      onTap: () {
                        // TODO: Implement edit functionality
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
