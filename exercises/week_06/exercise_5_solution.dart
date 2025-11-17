// Exercise 5: Social Media Platform (Advanced)
// Topic: Complete OOP - Inheritance, Polymorphism, Abstract Classes, Mixins

// Mixin for likeable content
mixin Likeable {
  int _likes = 0;

  void like() {
    _likes++;
  }

  void unlike() {
    if (_likes > 0) _likes--;
  }

  int getLikes() => _likes;
}

// Mixin for commentable content
mixin Commentable {
  final List<String> _comments = [];

  void addComment(String comment) {
    _comments.add(comment);
  }

  List<String> getComments() => List.unmodifiable(_comments);
  int getCommentCount() => _comments.length;
}

// Mixin for shareable content
mixin Shareable {
  int _shares = 0;

  void share() {
    _shares++;
  }

  int getShares() => _shares;
}

// Mixin for timestamp tracking
mixin Timestamped {
  DateTime? createdAt;
  DateTime? updatedAt;

  void markCreated() {
    createdAt = DateTime.now();
  }

  void markUpdated() {
    updatedAt = DateTime.now();
  }

  String getTimeSinceCreation() {
    if (createdAt == null) return 'Unknown';

    Duration diff = DateTime.now().difference(createdAt!);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}

// Abstract Content class
abstract class Content {
  String id;
  String authorId;
  String content;

  Content(this.id, this.authorId, this.content);

  String getContentType();
  void display();

  int getEngagement() {
    int total = 0;
    if (this is Likeable) {
      total += (this as Likeable).getLikes();
    }
    if (this is Commentable) {
      total += (this as Commentable).getCommentCount();
    }
    if (this is Shareable) {
      total += (this as Shareable).getShares();
    }
    return total;
  }
}

// Post class
class Post extends Content with Likeable, Commentable, Shareable, Timestamped {
  Post(String id, String authorId, String content)
      : super(id, authorId, content) {
    markCreated();
  }

  @override
  String getContentType() => 'Post';

  @override
  void display() {
    print('\n📝 POST [$id]');
    print('Author: $authorId');
    print('Content: $content');
    print('Posted: ${getTimeSinceCreation()}');
    print('❤️  ${getLikes()} | 💬 ${getCommentCount()} | 🔄 ${getShares()}');
  }
}

// Photo class
class Photo extends Content with Likeable, Commentable, Shareable, Timestamped {
  String imageUrl;

  Photo(String id, String authorId, String content, this.imageUrl)
      : super(id, authorId, content) {
    markCreated();
  }

  @override
  String getContentType() => 'Photo';

  @override
  void display() {
    print('\n📷 PHOTO [$id]');
    print('Author: $authorId');
    print('Caption: $content');
    print('Image: $imageUrl');
    print('Posted: ${getTimeSinceCreation()}');
    print('❤️  ${getLikes()} | 💬 ${getCommentCount()} | 🔄 ${getShares()}');
  }
}

// Video class
class Video extends Content with Likeable, Commentable, Shareable, Timestamped {
  String videoUrl;
  int durationSeconds;

  Video(
    String id,
    String authorId,
    String content,
    this.videoUrl,
    this.durationSeconds,
  ) : super(id, authorId, content) {
    markCreated();
  }

  @override
  String getContentType() => 'Video';

  String getFormattedDuration() {
    int minutes = durationSeconds ~/ 60;
    int seconds = durationSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void display() {
    print('\n🎥 VIDEO [$id]');
    print('Author: $authorId');
    print('Title: $content');
    print('URL: $videoUrl');
    print('Duration: ${getFormattedDuration()}');
    print('Posted: ${getTimeSinceCreation()}');
    print('❤️  ${getLikes()} | 💬 ${getCommentCount()} | 🔄 ${getShares()}');
  }
}

// Story class (expires after 24h)
class Story extends Content with Likeable, Timestamped {
  DateTime expiresAt;

  Story(String id, String authorId, String content)
      : expiresAt = DateTime.now().add(Duration(hours: 24)),
        super(id, authorId, content) {
    markCreated();
  }

  bool isExpired() {
    return DateTime.now().isAfter(expiresAt);
  }

  String getTimeRemaining() {
    if (isExpired()) return 'Expired';

    Duration remaining = expiresAt.difference(DateTime.now());
    if (remaining.inHours > 0) return '${remaining.inHours}h left';
    if (remaining.inMinutes > 0) return '${remaining.inMinutes}m left';
    return 'Expiring soon';
  }

  @override
  String getContentType() => 'Story';

  @override
  void display() {
    print('\n⭕ STORY [$id] ${isExpired() ? "[EXPIRED]" : ""}');
    print('Author: $authorId');
    print('Content: $content');
    print('Time: ${getTimeRemaining()}');
    print('❤️  ${getLikes()}');
  }
}

// User class
class User {
  String userId;
  String username;
  String email;
  int followersCount;
  List<Content> myContent = [];

  User(this.userId, this.username, this.email, {this.followersCount = 0});

  Post createPost(String id, String content) {
    Post post = Post(id, userId, content);
    myContent.add(post);
    return post;
  }

  Photo createPhoto(String id, String caption, String imageUrl) {
    Photo photo = Photo(id, userId, caption, imageUrl);
    myContent.add(photo);
    return photo;
  }

  Video createVideo(String id, String title, String videoUrl, int duration) {
    Video video = Video(id, userId, title, videoUrl, duration);
    myContent.add(video);
    return video;
  }

  Story createStory(String id, String content) {
    Story story = Story(id, userId, content);
    myContent.add(story);
    return story;
  }

  int getTotalEngagement() {
    int total = 0;
    for (Content content in myContent) {
      total += content.getEngagement();
    }
    return total;
  }

  void displayProfile() {
    print('\n========== USER PROFILE ==========');
    print('Username: @$username');
    print('Email: $email');
    print('Followers: $followersCount');
    print('Posts: ${myContent.length}');
    print('Total Engagement: ${getTotalEngagement()}');
    print('==================================\n');
  }
}

// Feed class
class Feed {
  List<Content> _contentItems = [];

  void addContent(Content content) {
    _contentItems.add(content);
  }

  void removeExpiredStories() {
    int initialCount = _contentItems.length;
    _contentItems.removeWhere((content) =>
      content is Story && content.isExpired()
    );
    int removed = initialCount - _contentItems.length;
    if (removed > 0) {
      print('Removed $removed expired stories');
    }
  }

  List<Content> getContentByType(String type) {
    return _contentItems
        .where((content) => content.getContentType() == type)
        .toList();
  }

  Content? getMostEngagedContent() {
    if (_contentItems.isEmpty) return null;

    Content? mostEngaged = _contentItems[0];
    int maxEngagement = mostEngaged.getEngagement();

    for (Content content in _contentItems) {
      int engagement = content.getEngagement();
      if (engagement > maxEngagement) {
        maxEngagement = engagement;
        mostEngaged = content;
      }
    }

    return mostEngaged;
  }

  void displayFeed() {
    print('\n========== FEED ==========');
    if (_contentItems.isEmpty) {
      print('No content in feed');
    } else {
      for (Content content in _contentItems) {
        content.display();
      }
    }
    print('==========================\n');
  }

  int get contentCount => _contentItems.length;
}

void main() {
  print('=== CREATING USERS ===');
  User alice = User('U001', 'alice_codes', 'alice@example.com', followersCount: 1500);
  User bob = User('U002', 'bob_designs', 'bob@example.com', followersCount: 850);
  User charlie = User('U003', 'charlie_photos', 'charlie@example.com', followersCount: 3200);

  print('=== CREATING CONTENT ===');
  // Alice creates content
  Post post1 = alice.createPost('P001', 'Just finished learning Dart OOP! 🎉');
  Photo photo1 = alice.createPhoto(
    'PH001',
    'My coding setup',
    'https://example.com/setup.jpg',
  );

  // Bob creates content
  Video video1 = bob.createVideo(
    'V001',
    'Flutter UI Design Tutorial',
    'https://example.com/video1.mp4',
    480,
  );
  Story story1 = bob.createStory('S001', 'Working on a new project! 🚀');

  // Charlie creates content
  Photo photo2 = charlie.createPhoto(
    'PH002',
    'Sunset at the beach',
    'https://example.com/sunset.jpg',
  );
  Post post2 = charlie.createPost('P002', 'Photography is life! 📸');

  // Create feed and add content
  Feed feed = Feed();
  feed.addContent(post1);
  feed.addContent(photo1);
  feed.addContent(video1);
  feed.addContent(story1);
  feed.addContent(photo2);
  feed.addContent(post2);

  print('=== SIMULATING INTERACTIONS ===');
  // Interactions on post1
  post1.like();
  post1.like();
  post1.like();
  post1.addComment('Great job!');
  post1.addComment('Keep it up!');
  post1.share();

  // Interactions on photo1
  photo1.like();
  photo1.like();
  photo1.like();
  photo1.like();
  photo1.addComment('Nice setup!');
  photo1.share();
  photo1.share();

  // Interactions on video1
  video1.like();
  video1.like();
  video1.like();
  video1.like();
  video1.like();
  video1.addComment('Very helpful!');
  video1.addComment('Thanks for sharing!');
  video1.addComment('Subscribed!');
  video1.share();
  video1.share();
  video1.share();

  // Interactions on photo2
  photo2.like();
  photo2.like();
  photo2.like();
  photo2.like();
  photo2.like();
  photo2.like();
  photo2.like();
  photo2.addComment('Stunning!');
  photo2.addComment('Amazing shot!');
  photo2.share();
  photo2.share();
  photo2.share();
  photo2.share();

  // Display feed
  feed.displayFeed();

  // User profiles
  alice.displayProfile();
  bob.displayProfile();
  charlie.displayProfile();

  // Analytics
  print('=== FEED ANALYTICS ===');
  print('Total content items: ${feed.contentCount}');

  List<Content> posts = feed.getContentByType('Post');
  List<Content> photos = feed.getContentByType('Photo');
  List<Content> videos = feed.getContentByType('Video');
  List<Content> stories = feed.getContentByType('Story');

  print('Posts: ${posts.length}');
  print('Photos: ${photos.length}');
  print('Videos: ${videos.length}');
  print('Stories: ${stories.length}');

  Content? mostEngaged = feed.getMostEngagedContent();
  if (mostEngaged != null) {
    print('\n=== MOST ENGAGED CONTENT ===');
    mostEngaged.display();
    print('Total Engagement: ${mostEngaged.getEngagement()}');
  }

  // Remove expired stories
  print('\n=== CLEANING UP ===');
  feed.removeExpiredStories();
  print('Feed now has ${feed.contentCount} items');

  // Polymorphism demo
  print('\n=== POLYMORPHISM DEMO ===');
  for (Content content in feed._contentItems) {
    print('${content.getContentType()}: ${content.getEngagement()} engagement');
  }
}
