// Exercise 5: Contact Manager (SOLUTION)

class Contact {
  String name;
  List<String> phoneNumbers;
  Set<String> emails; // Use Set to ensure unique emails
  Set<String> tags;

  Contact({
    required this.name,
    required this.phoneNumbers,
    required this.emails,
    required this.tags,
  });

  @override
  String toString() {
    return '''
Name: $name
Phones: ${phoneNumbers.join(', ')}
Emails: ${emails.join(', ')}
Tags: ${tags.join(', ')}''';
  }
}

void main() {
  print('=== Contact Manager ===\n');

  // Create contacts
  List<Contact> contacts = [
    Contact(
      name: 'John Doe',
      phoneNumbers: ['555-1234', '555-5678'],
      emails: {'john@email.com', 'john.doe@work.com'},
      tags: {'friend', 'work'},
    ),
    Contact(
      name: 'Jane Smith',
      phoneNumbers: ['555-8765'],
      emails: {'jane@email.com'},
      tags: {'family', 'emergency'},
    ),
    Contact(
      name: 'Bob Johnson',
      phoneNumbers: ['555-4321', '555-9999'],
      emails: {'bob@email.com', 'bjohnson@company.com'},
      tags: {'work', 'client'},
    ),
  ];

  print('✓ Added ${contacts.length} contacts\n');

  // Search by name
  String searchName = 'Jane';
  print('Searching for "$searchName":');
  for (Contact contact in contacts) {
    if (contact.name.contains(searchName)) {
      print(contact);
    }
  }

  // Search by phone
  print('\n---\nSearching for phone "555-4321":');
  String searchPhone = '555-4321';
  for (Contact contact in contacts) {
    if (contact.phoneNumbers.contains(searchPhone)) {
      print('Found: ${contact.name}');
    }
  }

  // Search by email
  print('\n---\nSearching for email "bob@email.com":');
  String searchEmail = 'bob@email.com';
  for (Contact contact in contacts) {
    if (contact.emails.contains(searchEmail)) {
      print('Found: ${contact.name}');
    }
  }

  // Group by tag
  print('\n---\nContacts tagged as "work":');
  for (Contact contact in contacts) {
    if (contact.tags.contains('work')) {
      print('• ${contact.name}');
    }
  }

  // Display all contacts
  print('\n---\nAll Contacts:');
  for (int i = 0; i < contacts.length; i++) {
    print('\n${i + 1}. ${contacts[i]}');
  }
}
