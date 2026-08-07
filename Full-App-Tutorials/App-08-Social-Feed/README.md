# App 08: Social Feed — Full Tutorial

> Instagram-lite: feed, like, comment count, profile, create post.

**Min level:** 07–11 · **Time:** 16–24 hours  

## Features
- Infinite scroll feed  
- Like toggle (optimistic)  
- Post detail + comments list  
- Create post (caption + image pick)  
- Profile grid  

## Backend path
1. Mock in-memory posts  
2. Firebase Firestore `posts` + Storage images  
3. Rules: auth read; author write  

## Models
`Post { id, authorId, authorName, imageUrl, caption, likeCount, likedByMe, createdAt }`  
`Comment { id, postId, authorId, text, createdAt }`

## Build order
Auth → feed stream → like → create → profile → comments

## Portfolio
> Social feed client with optimistic likes and Firebase-backed posts.
