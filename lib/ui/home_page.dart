import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:object_box/main.dart';

import '../model/journal.dart';
import '../objectbox.g.dart';
import 'journal_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Store _store;
  late Box _box;
  late Stream<List<Journal>> _stream;

  @override
  void initState() {
    super.initState();
    openJournalStore();
  }

  openJournalStore() async {
    _store = objectbox.store;
    _box = _store.box<Journal>();
    setState(() {
      _stream = _store.box<Journal>().query().watch(triggerImmediately: true).map((journal) => journal.find());
    });
  }

  @override
  void dispose() {
    _store.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JournalPage(null)),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Journal>>(
          stream: _stream,
          builder: (context, snapshot) {
            final docs = snapshot.data!.toList();
            if (snapshot.hasData) {
              return ListView.builder(
                  itemBuilder: (context, index) {
                    final document = docs[index];
                    return Card(
                      shadowColor: Colors.blue,
                      child: ListTile(
                        title: Text(document.title),
                        subtitle: Text('Last Modified: ${DateFormat('yyyy-MM-dd hh:mm:ss').format(document.date)}'),
                        trailing: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () {
                                _box.remove(document.id);
                              },
                              child: const Icon(Icons.delete)),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => JournalPage(document.id)),
                          );
                        },
                      ),
                    );
                  },
                  itemCount: snapshot.data!.length);
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
