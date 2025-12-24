import SwiftUI

struct ChatView: View {
    let user: User
    @State private var messageText = ""
    @State private var messages: [Message] = []
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        // Match header
                        MatchedHeader(user: user)
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                        
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal)
                }
                .onChange(of: messages.count) {
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input bar
            MessageInputBar(
                text: $messageText,
                isFocused: _isInputFocused,
                onSend: sendMessage
            )
        }
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: UserProfileView(user: user)) {
                    AsyncImage(url: URL(string: user.primaryPhoto ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        default:
                            Circle()
                                .fill(.gray.opacity(0.3))
                        }
                    }
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                }
            }
        }
        .onAppear {
            loadMessages()
        }
    }
    
    private func loadMessages() {
        // Simulate existing messages
        messages = [
            Message(
                id: "1",
                conversationId: "c1",
                senderId: user.id,
                content: "Hey! I noticed we both love hiking 🥾",
                type: .text,
                createdAt: Date().addingTimeInterval(-3600),
                isRead: true
            ),
            Message(
                id: "2",
                conversationId: "c1",
                senderId: "currentUser",
                content: "Yes! I try to go every weekend. What's your favorite trail?",
                type: .text,
                createdAt: Date().addingTimeInterval(-3000),
                isRead: true
            ),
            Message(
                id: "3",
                conversationId: "c1",
                senderId: user.id,
                content: "There's this amazing one near the coast with ocean views. We should go together sometime! 😊",
                type: .text,
                createdAt: Date().addingTimeInterval(-2400),
                isRead: true
            )
        ]
    }
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newMessage = Message(
            id: UUID().uuidString,
            conversationId: "c1",
            senderId: "currentUser",
            content: messageText,
            type: .text,
            createdAt: Date(),
            isRead: false
        )
        
        messages.append(newMessage)
        messageText = ""
    }
}

struct MatchedHeader: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 12) {
            AsyncImage(url: URL(string: user.primaryPhoto ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                default:
                    Circle()
                        .fill(.gray.opacity(0.3))
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            
            Text("You matched with \(user.name)!")
                .font(.headline)
            
            Text("Say something interesting to start the conversation")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

struct MessageBubble: View {
    let message: Message
    
    private var isFromCurrentUser: Bool {
        message.senderId == "currentUser"
    }
    
    var body: some View {
        HStack {
            if isFromCurrentUser { Spacer() }
            
            Text(message.content)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isFromCurrentUser ? Color.pink : Color(.systemGray5))
                .foregroundStyle(isFromCurrentUser ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            if !isFromCurrentUser { Spacer() }
        }
    }
}

struct MessageInputBar: View {
    @Binding var text: String
    @FocusState var isFocused: Bool
    let onSend: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                // Attachments
                Button(action: {}) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.gray)
                }
                
                // Text field
                TextField("Type a message...", text: $text, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .focused($isFocused)
                    .lineLimit(1...5)
                
                // Send button
                Button(action: onSend) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title)
                        .foregroundStyle(text.isEmpty ? .gray : .pink)
                }
                .disabled(text.isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .background(.ultraThinMaterial)
    }
}

#Preview {
    NavigationStack {
        ChatView(user: User.mockUsers[0])
    }
}
