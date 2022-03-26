import 'package:flutter/material.dart';
import 'package:object_box/main.dart';
import 'package:object_box/model/journal.dart';

class JournalPage extends StatefulWidget {
  final int? id;

  JournalPage(this.id);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  String title = '';
  String reflection = '';
  final GlobalKey<FormState> _key = GlobalKey();
  late Journal? journal;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      final journalId = widget.id;
      journal = objectbox.store.box<Journal>().get(journalId!);
      title = journal!.title;
      reflection = journal!.reflection;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Journal'),
      ),
      body: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: title,
                  onChanged: (value) {
                    title = value;
                  },
                  validator: (inputValue) {
                    if (inputValue!.isEmpty) {
                      return 'Please enter title';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Input title here',
                    filled: true,
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                    errorStyle: TextStyle(color: Colors.teal),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Reflection',
                    style: TextStyle(fontSize: 18, height: 2, color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: reflection,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 10,
                  onChanged: (value) {
                    reflection = value;
                  },
                  validator: (inputValue) {
                    if (inputValue!.isEmpty) {
                      return 'Please enter reflection';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Input text here',
                    filled: true,
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                    errorStyle: TextStyle(color: Colors.teal),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 60.0,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
            onPressed: () {
              if (_key.currentState!.validate()) {
                if (widget.id != null) {
                  updateJournal();
                  Navigator.pop(context);
                } else {
                  createJournal();
                  Navigator.pop(context);
                }
              }
            },
            child: Text(
              widget.id != null ? 'Update Journal' : 'Create Journal',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  createJournal() {
    Journal journal = Journal(title: title, reflection: reflection);
    objectbox.store.box<Journal>().put(journal);
  }

  updateJournal() {
    journal!.title = title;
    journal!.reflection = reflection;
    journal!.date = DateTime.now();
    objectbox.store.box<Journal>().put(journal!);
  }
}
