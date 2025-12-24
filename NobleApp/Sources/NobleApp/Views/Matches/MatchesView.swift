import SwiftUI

struct MatchesView: View {
    @State private var conversations = Conversation.mockConversations
    @State private var searchText = ""
    
    var filteredConversations: [Conversation] {
        if searchText.isEmpty {
            return conversations
        }
        return conversations.filter { conversation in
            conversation.otherUser?.name.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // New Matches horizontal scroll
                    NewMatchesSection()
                    
                    Divider()
                        .padding(.vertical)
                    
                    // Messages list
                    MessagesSection(conversations: filteredConversations)
                }
            }
            .navigationTitle("Messages")
            .searchable(text: $searchText, prompt: "Search matches")
        }
    }
}

struct NewMatchesSection: View {
    let matches = User.mockUsers
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("New Matches")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(matches) { user in
                        NavigationLink(destination: ChatView(user: user)) {
                            NewMatchBubble(user: user)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}

struct NewMatchBubble: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 8) {
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
            .frame(width: 70, height: 70)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.pink, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            
            Text(user.name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .lineLimit(1)
        }
        .frame(width: 80)
    }
}

struct MessagesSection: View {
    let conversations: [Conversation]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Messages")
                .font(.headline)
                .padding(.horizontal)
                .padding(.bottom, 12)
            
            if conversations.isEmpty {
                EmptyMessagesView()
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(conversations) { conversation in
                        if let otherUser = conversation.otherUser {
                            NavigationLink(destination: ChatView(user: otherUser)) {
                                ConversationRow(conversation: conversation)
                            }
                            .buttonStyle(.plain)
                            
                            Divider()
                                .padding(.leading, 84)
                        }
                    }
                }
            }
        }
    }
}

struct ConversationRow: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            AsyncImage(url: URL(string: conversation.otherUser?.primaryPhoto ?? "")) { phase in
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
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(conversation.otherUser?.name ?? "Unknown")
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    if let lastMessage = conversation.lastMessage {
                        Text(timeAgo(from: lastMessage.createdAt))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                HStack {
                    if let lastMessage = conversation.lastMessage {
                        Text(lastMessage.content)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    if conversation.unreadCount > 0 {
                        Text("\(conversation.unreadCount)")
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.pink)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
    
    private func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct EmptyMessagesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 50))
                .foregroundStyle(.secondary)
            
            Text("No messages yet")
                .font(.headline)
            
            Text("Match with someone and start a conversation!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}

#Preview {
    MatchesView()
}
