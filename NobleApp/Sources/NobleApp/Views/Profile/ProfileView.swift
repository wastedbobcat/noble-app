import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSettings = false
    @State private var showEditProfile = false
    
    // Mock current user
    private let currentUser = User.mockUsers[0]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile header
                    ProfileHeader(user: currentUser)
                    
                    // Edit profile button
                    Button(action: { showEditProfile = true }) {
                        Text("Edit Profile")
                            .fontWeight(.semibold)
                            .foregroundStyle(.pink)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(.pink, lineWidth: 2)
                            )
                    }
                    .padding(.horizontal)
                    
                    // Premium upsell
                    PremiumCard()
                    
                    // Profile completeness
                    ProfileCompletenessCard()
                    
                    // Settings section
                    SettingsSection(showSettings: $showSettings)
                    
                    // Logout
                    Button(action: { authViewModel.signOut() }) {
                        Text("Log Out")
                            .foregroundStyle(.red)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showEditProfile) {
                EditProfileView(user: currentUser)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}

struct ProfileHeader: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 16) {
            // Main photo
            AsyncImage(url: URL(string: user.primaryPhoto ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                default:
                    Circle()
                        .fill(.gray.opacity(0.3))
                        .overlay {
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.white)
                        }
                }
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.white, lineWidth: 4)
            )
            .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
            
            // Name and verification
            HStack(spacing: 8) {
                Text("\(user.name), \(user.age)")
                    .font(.title2.bold())
                
                if user.isVerified {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(.blue)
                }
            }
            
            // Location
            if let location = user.location {
                HStack {
                    Image(systemName: "location.fill")
                        .font(.caption)
                    Text(location.displayLocation)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.top, 20)
    }
}

struct PremiumCard: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundStyle(.yellow)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Upgrade to Noble Gold")
                        .font(.headline)
                    Text("See who likes you & more")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [.yellow.opacity(0.1), .orange.opacity(0.1)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

struct ProfileCompletenessCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Profile 75% complete")
                    .font(.headline)
                Spacer()
                Text("🔥")
            }
            
            ProgressView(value: 0.75)
                .tint(.pink)
            
            Text("Add more photos to get 40% more matches")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

struct SettingsSection: View {
    @Binding var showSettings: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            SettingsRow(icon: "gearshape.fill", title: "Settings", color: .gray) {
                showSettings = true
            }
            
            Divider().padding(.leading, 56)
            
            SettingsRow(icon: "shield.fill", title: "Safety Center", color: .blue) {}
            
            Divider().padding(.leading, 56)
            
            SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support", color: .green) {}
            
            Divider().padding(.leading, 56)
            
            SettingsRow(icon: "star.fill", title: "Rate Noble", color: .orange) {}
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .frame(width: 24)
                
                Text(title)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
