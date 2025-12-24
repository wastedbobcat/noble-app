import SwiftUI

struct SwipeView: View {
    @StateObject private var viewModel = SwipeViewModel()
    @State private var currentIndex = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [.pink.opacity(0.1), .purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    if viewModel.users.isEmpty {
                        EmptyStateView()
                    } else {
                        CardStackView(
                            users: viewModel.users,
                            currentIndex: $currentIndex,
                            onSwipe: { direction, user in
                                viewModel.handleSwipe(direction: direction, user: user)
                            }
                        )
                        
                        ActionButtonsView(
                            onRewind: { viewModel.rewind() },
                            onPass: { swipeCard(direction: .left) },
                            onSuperLike: { swipeCard(direction: .up) },
                            onLike: { swipeCard(direction: .right) },
                            onBoost: { viewModel.boost() }
                        )
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundStyle(.primary)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "bell.badge")
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadUsers()
        }
    }
    
    private func swipeCard(direction: SwipeDirection) {
        guard currentIndex < viewModel.users.count else { return }
        let user = viewModel.users[currentIndex]
        viewModel.handleSwipe(direction: direction, user: user)
        withAnimation(.spring()) {
            currentIndex += 1
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 80))
                .foregroundStyle(.secondary)
            
            Text("No more profiles")
                .font(.title2.bold())
            
            Text("Check back later for new people nearby")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: {}) {
                Text("Expand Preferences")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(.pink)
                    .clipShape(Capsule())
            }
            .padding(.top)
        }
        .padding()
    }
}

#Preview {
    SwipeView()
        .environmentObject(AppState())
}
