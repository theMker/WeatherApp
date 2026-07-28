import SwiftUI

/// A chat-style screen presenting an avatar that answers general AI questions.
public struct AIAvatarView: View {
    @StateObject private var viewModel: AIAvatarViewModel
    @FocusState private var isInputFocused: Bool

    public init(viewModel: @autoclosure @escaping () -> AIAvatarViewModel = AIAvatarViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    public var body: some View {
        VStack(spacing: 0) {
            header

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            ChatBubble(message: message)
                                .id(message.id)
                        }
                        if viewModel.isThinking {
                            TypingIndicator()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                }
                .onChange(of: viewModel.messages) { _, messages in
                    guard let last = messages.last else { return }
                    withAnimation {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }

            inputBar
        }
        .background(Color(.systemGroupedBackground))
    }

    private var header: some View {
        HStack(spacing: 12) {
            AvatarIcon(size: 44)
            VStack(alignment: .leading, spacing: 2) {
                Text("AI Avatar")
                    .font(.headline)
                Text("Ask me about artificial intelligence")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(.bar)
    }

    private var inputBar: some View {
        HStack(spacing: 8) {
            TextField("Ask a question about AI…", text: $viewModel.draft, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .focused($isInputFocused)
                .lineLimit(1...4)
                .onSubmit { viewModel.send() }

            Button {
                viewModel.send()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 28))
            }
            .disabled(viewModel.draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        .background(.bar)
    }
}

private struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if message.sender == .avatar {
                AvatarIcon(size: 28)
            } else {
                Spacer(minLength: 40)
            }

            Text(message.text)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(bubbleColor)
                .foregroundStyle(message.sender == .user ? Color.white : Color.primary)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            if message.sender == .avatar {
                Spacer(minLength: 40)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.sender == .user ? .trailing : .leading)
    }

    private var bubbleColor: Color {
        message.sender == .user ? Color.accentColor : Color(.secondarySystemBackground)
    }
}

private struct TypingIndicator: View {
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            AvatarIcon(size: 28)
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { _ in
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            Spacer(minLength: 40)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct AvatarIcon: View {
    let size: CGFloat

    var body: some View {
        Image(systemName: "brain.head.profile")
            .resizable()
            .scaledToFit()
            .padding(size * 0.2)
            .frame(width: size, height: size)
            .foregroundStyle(.white)
            .background(
                LinearGradient(
                    colors: [Color.accentColor, Color.accentColor.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(Circle())
    }
}

#Preview {
    AIAvatarView()
}
