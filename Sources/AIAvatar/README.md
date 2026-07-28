# AIAvatar

A SwiftUI chat screen where an avatar answers general questions about
artificial intelligence — what AI/ML/neural networks are, how large language
models work, AI safety, bias, hallucinations, and more.

- `AIAvatarView` — the chat UI (avatar header, message list, input bar).
- `AIAvatarViewModel` — holds conversation state and talks to the knowledge base.
- `AIKnowledgeBase` — offline, keyword-based Q&A engine. No network access or
  API key required, so the avatar works out of the box.

## Usage

```swift
import AIAvatar

struct ContentView: View {
    var body: some View {
        AIAvatarView()
    }
}
```

## Extending

To broaden what the avatar can answer, add entries to
`AIKnowledgeBase.defaultTopics`: each topic pairs a list of keywords with an
answer, and the topic with the most keyword overlap with the user's question
wins.
