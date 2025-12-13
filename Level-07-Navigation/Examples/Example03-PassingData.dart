// Example 03: Passing Data Between Screens
// Learn to send and receive data during navigation

import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════
// MODELS
// ═══════════════════════════════════════════════════════════════

class Contact {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;

  const Contact({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
  });
}

// Sample data
final contacts = [
  const Contact(
    id: '1',
    name: 'Alice Johnson',
    email: 'alice@example.com',
    phone: '+1 234 567 8901',
    avatar: '👩',
  ),
  const Contact(
    id: '2',
    name: 'Bob Smith',
    email: 'bob@example.com',
    phone: '+1 234 567 8902',
    avatar: '👨',
  ),
  const Contact(
    id: '3',
    name: 'Carol Williams',
    email: 'carol@example.com',
    phone: '+1 234 567 8903',
    avatar: '👩‍🦰',
  ),
  const Contact(
    id: '4',
    name: 'David Brown',
    email: 'david@example.com',
    phone: '+1 234 567 8904',
    avatar: '👨‍🦱',
  ),
  const Contact(
    id: '5',
    name: 'Eva Martinez',
    email: 'eva@example.com',
    phone: '+1 234 567 8905',
    avatar: '👩‍🦳',
  ),
];

// ═══════════════════════════════════════════════════════════════
// MAIN APP
// ═══════════════════════════════════════════════════════════════

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Passing Data Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const ContactListScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN 1: CONTACT LIST (Sends data forward)
// ═══════════════════════════════════════════════════════════════

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  Contact? selectedContact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            tooltip: 'Pick a Color',
            onPressed: () async {
              // ─────────────────────────────────────────
              // RECEIVE DATA BACK FROM COLOR PICKER
              // ─────────────────────────────────────────
              final color = await Navigator.push<Color>(
                context,
                MaterialPageRoute(
                  builder: (context) => const ColorPickerScreen(),
                ),
              );

              if (color != null && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You picked a color!'),
                    backgroundColor: color,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Show selected contact
          if (selectedContact != null)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(selectedContact!.avatar, style: const TextStyle(fontSize: 40)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Viewed: ${selectedContact!.name}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          selectedContact!.email,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Contact list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: Text(contact.avatar, style: const TextStyle(fontSize: 24)),
                    ),
                    title: Text(contact.name),
                    subtitle: Text(contact.email),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      // ─────────────────────────────────────────
                      // SEND DATA FORWARD: Pass entire object
                      // ─────────────────────────────────────────
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactDetailScreen(
                            contact: contact,  // Pass the contact object
                          ),
                        ),
                      );

                      // Update UI if contact was viewed
                      if (result == true) {
                        setState(() {
                          selectedContact = contact;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // ─────────────────────────────────────────
          // RECEIVE NEW CONTACT FROM ADD SCREEN
          // ─────────────────────────────────────────
          final newContact = await Navigator.push<Contact>(
            context,
            MaterialPageRoute(
              builder: (context) => const AddContactScreen(),
            ),
          );

          if (newContact != null && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Added ${newContact.name}!'),
              ),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Contact'),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN 2: CONTACT DETAIL (Receives data, returns result)
// ═══════════════════════════════════════════════════════════════

class ContactDetailScreen extends StatelessWidget {
  // ─────────────────────────────────────────
  // RECEIVE DATA: Contact passed via constructor
  // ─────────────────────────────────────────
  final Contact contact;

  const ContactDetailScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final edited = await Navigator.push<Contact>(
                context,
                MaterialPageRoute(
                  builder: (context) => EditContactScreen(contact: contact),
                ),
              );

              if (edited != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${edited.name} updated!')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.teal.shade100,
              child: Text(contact.avatar, style: const TextStyle(fontSize: 60)),
            ),
            const SizedBox(height: 20),

            // Name
            Text(
              contact.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Contact details cards
            _DetailCard(
              icon: Icons.email,
              label: 'Email',
              value: contact.email,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _DetailCard(
              icon: Icons.phone,
              label: 'Phone',
              value: contact.phone,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            _DetailCard(
              icon: Icons.badge,
              label: 'ID',
              value: contact.id,
              color: Colors.purple,
            ),

            const SizedBox(height: 40),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.phone,
                  label: 'Call',
                  color: Colors.green,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Calling ${contact.phone}...')),
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.message,
                  label: 'Message',
                  color: Colors.blue,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening chat with ${contact.name}...')),
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.email,
                  label: 'Email',
                  color: Colors.orange,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sending email to ${contact.email}...')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ─────────────────────────────────────────
          // RETURN DATA: Send result back to previous screen
          // ─────────────────────────────────────────
          Navigator.pop(context, true);  // Return true = viewed
        },
        tooltip: 'Done',
        child: const Icon(Icons.check),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN 3: ADD CONTACT (Returns new contact)
// ═══════════════════════════════════════════════════════════════

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedAvatar = '👤';

  final avatars = ['👤', '👩', '👨', '👩‍🦰', '👨‍🦱', '👩‍🦳', '👴', '👵'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Avatar picker
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.teal.shade100,
                    child: Text(_selectedAvatar, style: const TextStyle(fontSize: 50)),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: avatars.map((avatar) {
                      final isSelected = avatar == _selectedAvatar;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAvatar = avatar;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.teal.shade100 : null,
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(color: Colors.teal, width: 2)
                                : null,
                          ),
                          child: Text(avatar, style: const TextStyle(fontSize: 28)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Name field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Email field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Phone field
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 30),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);  // Cancel - return nothing
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.isNotEmpty) {
                        // ─────────────────────────────────────────
                        // RETURN NEW CONTACT
                        // ─────────────────────────────────────────
                        final newContact = Contact(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: _nameController.text,
                          email: _emailController.text.isEmpty
                              ? 'no-email@example.com'
                              : _emailController.text,
                          phone: _phoneController.text.isEmpty
                              ? '+1 000 000 0000'
                              : _phoneController.text,
                          avatar: _selectedAvatar,
                        );
                        Navigator.pop(context, newContact);
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN 4: EDIT CONTACT (Receives data, returns edited data)
// ═══════════════════════════════════════════════════════════════

class EditContactScreen extends StatefulWidget {
  final Contact contact;

  const EditContactScreen({super.key, required this.contact});

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact.name);
    _emailController = TextEditingController(text: widget.contact.email);
    _phoneController = TextEditingController(text: widget.contact.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Contact'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final edited = Contact(
                  id: widget.contact.id,
                  name: _nameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                  avatar: widget.contact.avatar,
                );
                Navigator.pop(context, edited);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN 5: COLOR PICKER (Returns color selection)
// ═══════════════════════════════════════════════════════════════

class ColorPickerScreen extends StatelessWidget {
  const ColorPickerScreen({super.key});

  static const colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a Color'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final color = colors[index];
          return GestureDetector(
            onTap: () {
              // ─────────────────────────────────────────
              // RETURN SELECTED COLOR
              // ─────────────────────────────────────────
              Navigator.pop(context, color);
            },
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DetailCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
          child: Icon(icon),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}

/*
 * ═══════════════════════════════════════════════════════════════
 * KEY CONCEPTS DEMONSTRATED:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Passing Data Forward (Constructor)
 *    - Pass data directly to screen constructor
 *    - ContactDetailScreen(contact: contact)
 *
 * 2. Receiving Data Back (await Navigator.push)
 *    - Use async/await to get result
 *    - final result = await Navigator.push<Type>(...)
 *
 * 3. Returning Data (Navigator.pop with result)
 *    - Pass data back: Navigator.pop(context, data)
 *    - Return null: Navigator.pop(context) or just back button
 *
 * 4. Generic Type Safety
 *    - Navigator.push<Color>(...) - expects Color return
 *    - Navigator.push<Contact>(...) - expects Contact return
 *
 * ═══════════════════════════════════════════════════════════════
 * DATA FLOW PATTERNS:
 * ═══════════════════════════════════════════════════════════════
 *
 *   Forward Only:
 *   List ─────[contact]────> Detail
 *
 *   Round Trip:
 *   List ─────[push]─────> Picker
 *   List <────[color]───── Picker
 *
 *   Create Flow:
 *   List ─────[push]─────> Add
 *   List <──[newContact]── Add
 *
 *   Edit Flow:
 *   Detail ──[contact]──> Edit
 *   Detail <─[edited]──── Edit
 *
 */
