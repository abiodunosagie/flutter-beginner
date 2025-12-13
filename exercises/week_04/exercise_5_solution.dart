// Exercise 5: Library System (SOLUTION)

class Book {
  String title;
  String author;
  String isbn;
  bool isAvailable;

  Book({
    required this.title,
    required this.author,
    required this.isbn,
    this.isAvailable = true,
  });

  @override
  String toString() {
    return '$title by $author (ISBN: $isbn) - ${isAvailable ? "Available" : "Borrowed"}';
  }
}

class Member {
  String name;
  String memberID;
  List<Book> borrowedBooks;
  Map<Book, DateTime> dueDates;

  Member({
    required this.name,
    required this.memberID,
  })  : borrowedBooks = [],
        dueDates = {};

  void borrowBook(Book book, DateTime dueDate) {
    borrowedBooks.add(book);
    dueDates[book] = dueDate;
    book.isAvailable = false;
  }

  void returnBook(Book book) {
    borrowedBooks.remove(book);
    dueDates.remove(book);
    book.isAvailable = true;
  }
}

class Library {
  List<Book> books = [];
  List<Member> members = [];

  void addBook(Book book) {
    books.add(book);
    print('✓ Added book: ${book.title}');
  }

  void addMember(Member member) {
    members.add(member);
    print('✓ Added member: ${member.name} (${member.memberID})');
  }

  bool borrowBook(String memberID, String isbn) {
    // Find member
    Member? member;
    for (Member m in members) {
      if (m.memberID == memberID) {
        member = m;
        break;
      }
    }
    if (member == null) {
      print('❌ Member not found');
      return false;
    }

    // Find book
    Book? book;
    for (Book b in books) {
      if (b.isbn == isbn && b.isAvailable) {
        book = b;
        break;
      }
    }
    if (book == null) {
      print('❌ Book not available');
      return false;
    }

    // Borrow book (due in 14 days)
    DateTime dueDate = DateTime.now().add(Duration(days: 14));
    member.borrowBook(book, dueDate);
    print('✓ ${member.name} borrowed "${book.title}" (Due: ${dueDate.toString().split(' ')[0]})');
    return true;
  }

  double returnBook(String memberID, String isbn) {
    // Find member
    Member? member;
    for (Member m in members) {
      if (m.memberID == memberID) {
        member = m;
        break;
      }
    }
    if (member == null) {
      print('❌ Member not found');
      return 0;
    }

    // Find book in borrowed books
    Book? book;
    for (Book b in member.borrowedBooks) {
      if (b.isbn == isbn) {
        book = b;
        break;
      }
    }
    if (book == null) {
      print('❌ Book not found in borrowed books');
      return 0;
    }

    // Calculate fine if overdue
    DateTime dueDate = member.dueDates[book]!;
    DateTime now = DateTime.now();
    double fine = 0;

    if (now.isAfter(dueDate)) {
      int daysLate = now.difference(dueDate).inDays;
      fine = daysLate * 0.50; // $0.50 per day
      print('⚠️  Book is $daysLate days overdue. Fine: \$${fine.toStringAsFixed(2)}');
    }

    member.returnBook(book);
    print('✓ ${member.name} returned "${book.title}"');
    return fine;
  }

  void displayAvailableBooks() {
    print('\n=== Available Books ===');
    bool hasAvailable = false;
    for (Book book in books) {
      if (book.isAvailable) {
        print('• $book');
        hasAvailable = true;
      }
    }
    if (!hasAvailable) {
      print('No books available');
    }
  }

  void displayMemberBooks(String memberID) {
    Member? member;
    for (Member m in members) {
      if (m.memberID == memberID) {
        member = m;
        break;
      }
    }
    if (member == null) {
      print('Member not found');
      return;
    }

    print('\n=== Books borrowed by ${member.name} ===');
    if (member.borrowedBooks.isEmpty) {
      print('No books borrowed');
    } else {
      for (Book book in member.borrowedBooks) {
        DateTime due = member.dueDates[book]!;
        print('• ${book.title} (Due: ${due.toString().split(' ')[0]})');
      }
    }
  }
}

void main() {
  print('=== Library Management System ===\n');

  Library library = Library();

  // Add books
  library.addBook(Book(title: 'Flutter Basics', author: 'John Doe', isbn: '001'));
  library.addBook(Book(title: 'Dart Programming', author: 'Jane Smith', isbn: '002'));
  library.addBook(Book(title: 'Mobile Development', author: 'Bob Johnson', isbn: '003'));

  print('');

  // Add members
  library.addMember(Member(name: 'Alice', memberID: 'M001'));
  library.addMember(Member(name: 'Bob', memberID: 'M002'));

  // Display available books
  library.displayAvailableBooks();

  // Borrow books
  print('\n--- Borrowing Books ---');
  library.borrowBook('M001', '001');
  library.borrowBook('M001', '002');
  library.borrowBook('M002', '003');

  // Display available books after borrowing
  library.displayAvailableBooks();

  // Display member's borrowed books
  library.displayMemberBooks('M001');

  // Return book
  print('\n--- Returning Books ---');
  double fine = library.returnBook('M001', '001');
  if (fine > 0) {
    print('Total fine: \$${fine.toStringAsFixed(2)}');
  }

  // Display updated available books
  library.displayAvailableBooks();
}
