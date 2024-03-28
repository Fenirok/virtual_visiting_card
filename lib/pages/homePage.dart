import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:v_card/pages/contacts_details_page.dart';
import 'package:v_card/pages/scan_page.dart';
import 'package:v_card/provider/contact_provider.dart';
import 'package:v_card/util/helperfunction.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    Provider.of<ContactProvider>(context, listen: false).getAllContacts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(ScanPage.routeName);
        },
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          backgroundColor: Colors.blue[100],
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
            _fetchData();
          },
          currentIndex: selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'All',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favourites',
            ),
          ],
        ),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.contactList.length,
          itemBuilder: (BuildContext context, int index) {
            final contact = provider.contactList[index];
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: Container(
                padding: EdgeInsets.only(right: 20),
                alignment: Alignment.centerRight,
                color: Colors.red,
                child: Icon(
                  Icons.delete,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              confirmDismiss: _showConfirmationDialog,
              onDismissed: (_) async {
                await provider.deleteContact(contact.id);
                showMsg(context, 'Deleted');
              },
              child: ListTile(
                onTap: () => context.goNamed(ContactDetailsPage.routename, extra: contact.id),
                title: Text(contact.name),
                trailing: IconButton(
                  onPressed: () {
                    provider.updateFavorite(contact);
                  },
                  icon: Icon(contact.favourite
                      ? Icons.favorite
                      : Icons.favorite_border),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(DismissDirection direction) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Delete Contact'),
              content: Text('Are You sure to delete this contact?'),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    context.pop(false);
                  },
                  child: Text('NO'),
                ),
                OutlinedButton(
                  onPressed: () {
                    context.pop(true);
                  },
                  child: Text('YES'),
                ),

              ],
            ));
  }

  void _fetchData() {
    switch(selectedIndex) {
      case 0:
        Provider.of<ContactProvider>(context, listen: false).getAllContacts();
        break;
      case 1:
        Provider.of<ContactProvider>(context, listen: false).getAllFavoriteContacts();
        break;

    }
  }
}
