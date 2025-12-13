// Exercise 4: User Role System (Intermediate-Advanced)
// Topic: Mixins and Composition
//
// Create a user permission system using mixins:
// 1. Create these mixins for different capabilities:
//    - Readable: read(String resource) method
//    - Writable: write(String resource, String content) method
//    - Deletable: delete(String resource) method
//    - Executable: execute(String resource) method
//    - Auditable: logAction(String action) method with action history list
//
// 2. Create a base User class with:
//    - Properties: userId (String), username (String), email (String)
//    - Constructor that initializes all properties
//    - Method: displayInfo() to show user details
//
// 3. Create different user role classes that extend User and mix in appropriate capabilities:
//    - GuestUser: Only Readable
//    - RegularUser: Readable, Writable, Auditable
//    - Editor: Readable, Writable, Deletable, Auditable
//    - Administrator: All capabilities (Readable, Writable, Deletable, Executable, Auditable)
//
// 4. Add logging to each capability:
//    - Each action should log what was done using the Auditable mixin
//    - Administrator should have a viewAuditLog() method
//
// 5. Create a ResourceManager class with:
//    - Method: grantAccess(User user, String action, String resource)
//    - Check if user has the required capability before granting access
//    - Use 'is' operator to check for capabilities
//
// Test by creating different user types and attempting various operations.

void main() {
  // TODO: Create different user types
  // TODO: Test their capabilities
  // TODO: Try to perform unauthorized actions

}

// TODO: Implement Readable mixin


// TODO: Implement Writable mixin


// TODO: Implement Deletable mixin


// TODO: Implement Executable mixin


// TODO: Implement Auditable mixin


// TODO: Implement User class


// TODO: Implement GuestUser class


// TODO: Implement RegularUser class


// TODO: Implement Editor class


// TODO: Implement Administrator class


// TODO: Implement ResourceManager class
