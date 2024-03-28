import 'package:path/path.dart' as P;
import 'package:sqflite/sqflite.dart';
import 'package:v_card/models/contact_model.dart';

class DBHelper {
  final String _createTableContact = '''create table $tableContact(
  
  $tblContactColId integer primary key autoincrement, 
  $tblContactColName text,
  $tblContactColMobile text,
  $tblContactColEmail text,
  $tblContactColCompany text,
  $tblContactColAddress text,
  $tblContactColDesignation text,
  $tblContactColWebsite text,
  $tblContactColImage text,
  $tblContactColFavourite integer)''';

  Future<Database> _open() async {
    final root = await getDatabasesPath();
    final dbPath = P.join(root, 'contact.db');
    return openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute(_createTableContact);
    });
  }

  Future<int> insertContact(ContactModel contactModel) async {
    final db = await _open();
    return db.insert(
      tableContact,
      contactModel.toMap(),
    );
  }

  Future<List<ContactModel>> getAllContacts() async{
    final db = await _open();
    final mapList = await db.query(tableContact);
    return mapList.map((map) => ContactModel.fromMap(map)).toList();
  }

  Future<ContactModel> getContactsById(int id) async{
    final db = await _open();
    final mapList = await db.query(tableContact, where: '$tblContactColId = ?', whereArgs: [id]);
    return ContactModel.fromMap(mapList.first);
  }


  Future<List<ContactModel>> getAllFavoriteContacts() async{
    final db = await _open();
    final mapList = await db.query(tableContact, where: '$tblContactColFavourite = ?', whereArgs: [1]);
    return mapList.map((map) => ContactModel.fromMap(map)).toList();
  }

  Future<int> deleteContact(int id) async{
    final db = await _open();
    return db.delete(tableContact, where: '$tblContactColId = ?', whereArgs: [id]);
  }

  Future<int> updateFavorite(int id, int value) async{
    final db = await _open();
    return db.update(tableContact, {tblContactColFavourite : value}, where: '$tblContactColId = ?', whereArgs: [id]);
  }
}
