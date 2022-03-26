import 'package:objectbox/objectbox.dart';

@Entity()
class Journal {
  int id;
  String title;
  String reflection;
  DateTime date = DateTime.now();

  Journal({this.id = 0, required this.title, required this.reflection});
}