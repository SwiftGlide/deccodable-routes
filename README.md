# Decodable Routing

Decodable routing helpers for Glide.

### Example

```swift
app.get("/\("categoryID", as: Int.self)/\("slug")", transform: decodePath()) { (post: Post) in
  // ...
}

app.get("/\("categoryID", as: Int.self)/\("slug")", .urlPath) { (post: Post) in
  // ...
}
```

Available decoding strategies:

- URL path parameters
- URL query parameters
- Body JSON
- Body URL-encoded form
