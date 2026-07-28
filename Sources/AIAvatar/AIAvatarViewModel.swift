import Foundation
import SwiftUI

/// Drives the AI avatar chat: holds conversation state and produces answers
/// via the offline `AIKnowledgeBase`.
@MainActor
public final class AIAvatarViewModel: ObservableObject {
    @Published public private(set) var messages: [ChatMessage]
    @Published public var draft: String = ""
    @Published public private(set) var isThinking: Bool = false

    private let knowledgeBase: AIKnowledgeBase
    private let thinkingDelay: Duration

    public init(knowledgeBase: AIKnowledgeBase = AIKnowledgeBase(), thinkingDelay: Duration = .milliseconds(400)) {
        self.knowledgeBase = knowledgeBase
        self.thinkingDelay = thinkingDelay
        self.messages = [
            ChatMessage(
                sender: .avatar,
                text: "Hi! I'm your AI avatar. Ask me anything about artificial intelligence — what it is, how it works, or things like machine learning and large language models."
            )
        ]
    }

    public func send() {
        let question = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !question.isEmpty else { return }

        messages.append(ChatMessage(sender: .user, text: question))
        draft = ""

        Task {
            isThinking = true
            try? await Task.sleep(for: thinkingDelay)
            let reply = knowledgeBase.answer(for: question)
            messages.append(ChatMessage(sender: .avatar, text: reply))
            isThinking = false
        }
    }
}
