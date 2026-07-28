import Foundation

/// A single message exchanged with the AI avatar.
public struct ChatMessage: Identifiable, Equatable {
    public enum Sender: Equatable {
        case user
        case avatar
    }

    public let id: UUID
    public let sender: Sender
    public let text: String
    public let timestamp: Date

    public init(id: UUID = UUID(), sender: Sender, text: String, timestamp: Date = Date()) {
        self.id = id
        self.sender = sender
        self.text = text
        self.timestamp = timestamp
    }
}
