# App 08: Social Feed — Complete Tutorial

> Instagram-lite: scroll feed, like posts, open comments, create a post. Real social product shape.

**Time:** 16–24 hours  
**Minimum level:** 07–11  
**Backend:** start mock in memory, then Firebase Firestore + Storage  

---

## 1. What you are building

Users can:

1. Sign in (Firebase or mock user)  
2. See a reverse-chronological feed  
3. Like / unlike a post (optimistic UI)  
4. Open post detail with comments  
5. Create a post with caption (+ image optional)  
6. View a simple profile grid  

---

## 2. Features

- [ ] Feed list with author, caption, like count, time ago  
- [ ] Optimistic like (UI updates before server confirms; rollback on error)  
- [ ] Post detail  
- [ ] Comments list + add comment  
- [ ] Create post form  
- [ ] Empty feed state  
- [ ] Pull to refresh  
- [ ] Security: only author deletes own post (when using Firebase)  

---

## 3. Data model

```dart
class Post {
  final String id;
  final String authorId;
  final String authorName;
  final String caption;
  final String? imageUrl;
  final int likeCount;
  final bool likedByMe;
  final DateTime createdAt;
}

class Comment {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String text;
  final DateTime createdAt;
}
```

Firestore paths (phase 2):

```
posts/{postId}
posts/{postId}/comments/{commentId}
users/{uid}
```

---

## 4. Architecture

```
lib/
  models/
  data/post_repository.dart   # mock or firestore
  providers/feed_provider.dart
  pages/feed_page.dart
  pages/post_detail_page.dart
  pages/create_post_page.dart
  pages/profile_page.dart
  widgets/post_card.dart
  widgets/like_button.dart
```

---

## 5. Optimistic like (implement carefully)

```dart
Future<void> toggleLike(Post post) async {
  final previous = post;
  // 1) update local list immediately
  _patchLocal(post.id, liked: !post.likedByMe, likeCountDelta: post.likedByMe ? -1 : 1);
  notifyListeners();
  try {
    await repo.setLike(post.id, liked: !previous.likedByMe);
  } catch (e) {
    // 2) rollback
    _replace(previous);
    notifyListeners();
    rethrow;
  }
}
```

---

## 6. Build order

1. Mock list of 10 posts + Feed UI  
2. Like toggle local-only  
3. Detail + mock comments  
4. Create post adds to top of feed  
5. Wire Firebase auth + Firestore  
6. Image upload stretch with Storage  
7. Rules: read auth; create if authorId == uid  

---

## 7. Test script

1. Like a post → count +1; unlike → count −1  
2. Airplane mode like → rollback + error snackbar  
3. Add comment → appears in detail  
4. Create post → appears at top of feed  
5. Two users (Firebase): B sees A’s public posts  

---

## 8. Common mistakes

- Double-tap like creates double +2 without guard  
- Storing likes only on client  
- Huge images without compression  

---

## 9. Portfolio blurb

> Social feed client with optimistic likes, comments, and Firebase-backed posts.

## Done when

Feed → like → comment → create works on cold start.
