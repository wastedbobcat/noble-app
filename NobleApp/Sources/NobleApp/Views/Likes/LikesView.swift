import SwiftUI

struct LikesView: View {
    @State private var likes: [Like] = []
    @State private var showBlurredLikes = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Premium upsell card
                    if showBlurredLikes {
                        PremiumUpsellCard()
                    }
                    
                    // Likes grid
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ], spacing: 12) {
                        ForEach(User.mockUsers) { user in
                            LikeCard(user: user, isBlurred: showBlurredLikes)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Likes You")
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct PremiumUpsellCard: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundStyle(.yellow)
                Text("See who likes you")
                    .fontWeight(.semibold)
            }
            .font(.title3)
            
            Text("Upgrade to Noble Gold to see everyone who liked you and match instantly")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: {}) {
                Text("Get Noble Gold")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
            }
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
        .padding(.horizontal)
    }
}

struct LikeCard: View {
    let user: User
    let isBlurred: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Photo
            AsyncImage(url: URL(string: user.primaryPhoto ?? "")) { phase in
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
            .frame(height: 200)
            .clipped()
            .blur(radius: isBlurred ? 20 : 0)
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(user.name)
                        .fontWeight(.semibold)
                    Text("\(user.age)")
                        .foregroundStyle(.secondary)
                }
                .blur(radius: isBlurred ? 8 : 0)
                
                if let location = user.location {
                    Text(location.displayLocation)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .blur(radius: isBlurred ? 8 : 0)
                }
            }
            .padding(12)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}

#Preview {
    LikesView()
}
