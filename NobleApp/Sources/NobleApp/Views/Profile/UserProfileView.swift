import SwiftUI

struct UserProfileView: View {
    let user: User
    @State private var currentPhotoIndex = 0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Photos carousel
                TabView(selection: $currentPhotoIndex) {
                    ForEach(Array(user.photos.enumerated()), id: \.offset) { index, photoUrl in
                        AsyncImage(url: URL(string: photoUrl)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            default:
                                Rectangle()
                                    .fill(.gray.opacity(0.3))
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 450)
                
                VStack(alignment: .leading, spacing: 20) {
                    // Name and basic info
                    HStack(alignment: .bottom) {
                        Text(user.name)
                            .font(.largeTitle.bold())
                        
                        Text("\(user.age)")
                            .font(.title)
                            .foregroundStyle(.secondary)
                        
                        if user.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.blue)
                                .font(.title2)
                        }
                    }
                    
                    // Location
                    if let location = user.location {
                        HStack {
                            Image(systemName: "location.fill")
                            Text(location.displayLocation)
                        }
                        .foregroundStyle(.secondary)
                    }
                    
                    // Bio
                    Text(user.bio)
                        .font(.body)
                    
                    Divider()
                    
                    // Interests
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Interests")
                            .font(.headline)
                        
                        FlowLayout(spacing: 8) {
                            ForEach(user.interests, id: \.self) { interest in
                                InterestTag(interest: interest)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Prompts
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(user.prompts) { prompt in
                            PromptCard(prompt: prompt)
                        }
                    }
                }
                .padding(20)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(action: {}) {
                        Label("Report", systemImage: "exclamationmark.triangle")
                    }
                    Button(action: {}) {
                        Label("Block", systemImage: "hand.raised")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}

struct InterestTag: View {
    let interest: String
    
    var body: some View {
        Text(interest)
            .font(.subheadline)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.pink.opacity(0.1))
            .foregroundStyle(.pink)
            .clipShape(Capsule())
    }
}

struct PromptCard: View {
    let prompt: Prompt
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(prompt.question)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(prompt.answer)
                .font(.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// Simple flow layout for interests
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)
        
        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + frame.origin.x, y: bounds.minY + frame.origin.y),
                proposal: ProposedViewSize(frame.size)
            )
        }
    }
    
    private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, frames: [CGRect]) {
        let maxWidth = proposal.width ?? .infinity
        var frames: [CGRect] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentX + size.width > maxWidth {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            
            frames.append(CGRect(origin: CGPoint(x: currentX, y: currentY), size: size))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
        }
        
        return (CGSize(width: maxWidth, height: currentY + lineHeight), frames)
    }
}

#Preview {
    NavigationStack {
        UserProfileView(user: User.mockUsers[0])
    }
}
