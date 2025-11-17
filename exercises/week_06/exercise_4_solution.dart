// Exercise 4: User Role System (Intermediate-Advanced)
// Topic: Mixins and Composition

// Mixin for reading capability
mixin Readable {
  void read(String resource) {
    print('Reading: $resource');
    if (this is Auditable) {
      (this as Auditable).logAction('READ: $resource');
    }
  }
}

// Mixin for writing capability
mixin Writable {
  void write(String resource, String content) {
    print('Writing to $resource: $content');
    if (this is Auditable) {
      (this as Auditable).logAction('WRITE: $resource');
    }
  }
}

// Mixin for deleting capability
mixin Deletable {
  void delete(String resource) {
    print('Deleting: $resource');
    if (this is Auditable) {
      (this as Auditable).logAction('DELETE: $resource');
    }
  }
}

// Mixin for executing capability
mixin Executable {
  void execute(String resource) {
    print('Executing: $resource');
    if (this is Auditable) {
      (this as Auditable).logAction('EXECUTE: $resource');
    }
  }
}

// Mixin for audit logging
mixin Auditable {
  final List<String> _auditLog = [];

  void logAction(String action) {
    String timestamp = DateTime.now().toString();
    String logEntry = '[$timestamp] $action';
    _auditLog.add(logEntry);
  }

  void viewAuditLog() {
    print('\n=== AUDIT LOG ===');
    if (_auditLog.isEmpty) {
      print('No actions logged.');
    } else {
      for (int i = 0; i < _auditLog.length; i++) {
        print('${i + 1}. ${_auditLog[i]}');
      }
    }
    print('=================\n');
  }

  int get auditLogSize => _auditLog.length;
}

// Base User class
class User {
  String userId;
  String username;
  String email;

  User(this.userId, this.username, this.email);

  void displayInfo() {
    print('User ID: $userId');
    print('Username: $username');
    print('Email: $email');
    print('Role: ${getRoleName()}');
  }

  String getRoleName() {
    return 'User';
  }
}

// Guest user - can only read
class GuestUser extends User with Readable {
  GuestUser(String userId, String username, String email)
      : super(userId, username, email);

  @override
  String getRoleName() => 'Guest';
}

// Regular user - can read and write
class RegularUser extends User with Readable, Writable, Auditable {
  RegularUser(String userId, String username, String email)
      : super(userId, username, email);

  @override
  String getRoleName() => 'Regular User';
}

// Editor - can read, write, and delete
class Editor extends User with Readable, Writable, Deletable, Auditable {
  Editor(String userId, String username, String email)
      : super(userId, username, email);

  @override
  String getRoleName() => 'Editor';
}

// Administrator - has all capabilities
class Administrator extends User
    with Readable, Writable, Deletable, Executable, Auditable {
  Administrator(String userId, String username, String email)
      : super(userId, username, email);

  @override
  String getRoleName() => 'Administrator';

  void manageUsers() {
    print('Managing users...');
    logAction('MANAGE: Users');
  }

  void configureSystem() {
    print('Configuring system settings...');
    logAction('CONFIGURE: System');
  }
}

// Resource manager to check permissions
class ResourceManager {
  void grantAccess(User user, String action, String resource) {
    print('\n--- Access Request ---');
    print('User: ${user.username}');
    print('Action: $action');
    print('Resource: $resource');

    bool granted = false;

    switch (action.toUpperCase()) {
      case 'READ':
        if (user is Readable) {
          user.read(resource);
          granted = true;
        }
        break;
      case 'WRITE':
        if (user is Writable) {
          user.write(resource, 'Sample content');
          granted = true;
        }
        break;
      case 'DELETE':
        if (user is Deletable) {
          user.delete(resource);
          granted = true;
        }
        break;
      case 'EXECUTE':
        if (user is Executable) {
          user.execute(resource);
          granted = true;
        }
        break;
      default:
        print('Unknown action: $action');
    }

    if (!granted && action.toUpperCase() != 'UNKNOWN') {
      print('ACCESS DENIED! User lacks required permission.');
    }
    print('-------------------\n');
  }

  void checkCapabilities(User user) {
    print('\n=== CAPABILITIES FOR ${user.username} ===');
    print('Can Read: ${user is Readable}');
    print('Can Write: ${user is Writable}');
    print('Can Delete: ${user is Deletable}');
    print('Can Execute: ${user is Executable}');
    print('Has Audit Log: ${user is Auditable}');
    print('=====================================\n');
  }
}

void main() {
  // Create resource manager
  ResourceManager manager = ResourceManager();

  // Create different user types
  print('=== CREATING USERS ===\n');

  GuestUser guest = GuestUser('G001', 'guest_user', 'guest@example.com');
  guest.displayInfo();

  print('');
  RegularUser regular = RegularUser('R001', 'john_doe', 'john@example.com');
  regular.displayInfo();

  print('');
  Editor editor = Editor('E001', 'jane_editor', 'jane@example.com');
  editor.displayInfo();

  print('');
  Administrator admin = Administrator('A001', 'admin_alice', 'alice@example.com');
  admin.displayInfo();

  // Check capabilities
  print('\n=== CHECKING CAPABILITIES ===');
  manager.checkCapabilities(guest);
  manager.checkCapabilities(regular);
  manager.checkCapabilities(editor);
  manager.checkCapabilities(admin);

  // Test guest user
  print('=== GUEST USER TESTS ===');
  manager.grantAccess(guest, 'READ', 'public_document.txt');
  manager.grantAccess(guest, 'WRITE', 'document.txt'); // Should fail
  manager.grantAccess(guest, 'DELETE', 'file.txt'); // Should fail

  // Test regular user
  print('=== REGULAR USER TESTS ===');
  manager.grantAccess(regular, 'READ', 'data.json');
  manager.grantAccess(regular, 'WRITE', 'notes.txt');
  manager.grantAccess(regular, 'DELETE', 'temp.txt'); // Should fail
  regular.viewAuditLog();

  // Test editor
  print('=== EDITOR TESTS ===');
  manager.grantAccess(editor, 'READ', 'article.md');
  manager.grantAccess(editor, 'WRITE', 'article.md');
  manager.grantAccess(editor, 'DELETE', 'old_article.md');
  manager.grantAccess(editor, 'EXECUTE', 'script.sh'); // Should fail
  editor.viewAuditLog();

  // Test administrator
  print('=== ADMINISTRATOR TESTS ===');
  manager.grantAccess(admin, 'READ', 'config.yaml');
  manager.grantAccess(admin, 'WRITE', 'config.yaml');
  manager.grantAccess(admin, 'DELETE', 'old_config.yaml');
  manager.grantAccess(admin, 'EXECUTE', 'deploy.sh');
  admin.manageUsers();
  admin.configureSystem();
  admin.viewAuditLog();

  // Polymorphism example
  print('=== POLYMORPHISM DEMO ===');
  List<User> allUsers = [guest, regular, editor, admin];

  for (User user in allUsers) {
    print('Processing ${user.username} (${user.getRoleName()})');
    if (user is Readable) {
      print('  - Has read access');
    }
    if (user is Auditable) {
      print('  - Actions logged: ${user.auditLogSize}');
    }
  }
}
