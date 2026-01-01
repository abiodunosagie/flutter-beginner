# Level 2: Real-World Apps Using These Concepts

See how control flow powers the logic in real applications!

---

## If-Else Statements

### Decisions Make Apps Smart!

**Netflix**
```dart
if (hasSubscription) {
  playMovie();
} else {
  showSubscriptionPage();
}
```

**Uber**
```dart
if (driverNearby && rideRequested) {
  showDriverArriving();
} else if (noDriversAvailable) {
  showWaitMessage();
} else {
  searchForDrivers();
}
```

**Banking Apps**
```dart
if (balance >= withdrawalAmount) {
  processWithdrawal();
} else {
  showInsufficientFundsError();
}
```

---

## Switch Statements

### Handling Multiple Options!

**Spotify**
```dart
switch (repeatMode) {
  case 'off':
    playOnce();
    break;
  case 'one':
    repeatCurrentSong();
    break;
  case 'all':
    repeatPlaylist();
    break;
}
```

**Food Delivery Apps**
```dart
switch (orderStatus) {
  case 'placed':
    showOrderConfirmation();
    break;
  case 'preparing':
    showCookingAnimation();
    break;
  case 'on_the_way':
    showDriverLocation();
    break;
  case 'delivered':
    askForReview();
    break;
}
```

---

## For Loops

### Repeating Actions Efficiently!

**Instagram Feed**
```dart
for (var post in posts) {
  displayPost(post);  // Shows each post in your feed
}
```

**Spotify Playlist**
```dart
for (int i = 0; i < songs.length; i++) {
  print('${i + 1}. ${songs[i].title}');  // Numbered song list
}
```

**Email Apps**
```dart
for (var email in inbox) {
  if (!email.isRead) {
    markAsUnread(email);
  }
}
```

---

## While Loops

### Keep Going Until Done!

**Game Apps (Candy Crush)**
```dart
while (livesRemaining > 0 && !levelComplete) {
  playTurn();
}
```

**Download Managers**
```dart
while (!downloadComplete) {
  downloadNextChunk();
  updateProgressBar();
}
```

**Chat Apps (Real-time)**
```dart
while (chatOpen) {
  checkForNewMessages();
  displayNewMessages();
}
```

---

## Break and Continue

### Smart Loop Control!

**Search Features**
```dart
for (var product in products) {
  if (product.name.contains(searchTerm)) {
    displayResult(product);
    break;  // Found it! Stop searching
  }
}
```

**Filter Lists**
```dart
for (var item in items) {
  if (item.isHidden) {
    continue;  // Skip hidden items
  }
  showItem(item);
}
```

---

## Real Apps Using These Patterns

| App | Control Flow Used |
|-----|------------------|
| **Amazon** | if/else for cart validation, loops for product lists |
| **Twitter/X** | Switch for different tweet types, loops for timeline |
| **Google Maps** | Loops for route steps, conditions for traffic |
| **Duolingo** | Conditions for correct answers, loops for exercises |
| **TikTok** | Loops for video feed, conditions for likes/follows |

---

## Build It Yourself!

After this level, you could build:

1. **Grade Calculator** - If/else for letter grades
2. **Day of Week App** - Switch for day names
3. **Countdown Timer** - While loop for counting
4. **Number Guessing Game** - Loops and conditions combined
5. **Simple Quiz App** - Score tracking with loops

---

## FizzBuzz in Real Apps

The classic FizzBuzz you learned shows up in:

**Calendar Apps**
```dart
for (int day = 1; day <= 30; day++) {
  if (day % 7 == 0) {
    highlightWeekend();
  }
}
```

**Notification Batching**
```dart
for (int i = 0; i < notifications.length; i++) {
  if (i % 5 == 0) {
    sendBatchNotification();  // Send every 5
  }
}
```

---

**Control flow is the brain of every app - it makes decisions and repeats tasks!**
