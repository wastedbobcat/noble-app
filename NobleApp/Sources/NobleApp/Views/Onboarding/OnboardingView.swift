import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showSignUp = false
    @State private var showLogin = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [.pink, .purple, .pink.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Logo
                VStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.white)
                    
                    Text("Noble")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                // Onboarding pages
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        title: "Find Your Match",
                        subtitle: "Swipe right to like, left to pass. It's that simple.",
                        icon: "heart.fill"
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        title: "Start Conversations",
                        subtitle: "When you both like each other, it's a match! Start chatting instantly.",
                        icon: "bubble.left.and.bubble.right.fill"
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        title: "Meet in Person",
                        subtitle: "Take your connection offline and meet amazing people near you.",
                        icon: "person.2.fill"
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 200)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 16) {
                    Button(action: { showSignUp = true }) {
                        Text("Create Account")
                            .fontWeight(.bold)
                            .foregroundStyle(.pink)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.white)
                            .clipShape(Capsule())
                    }
                    
                    Button(action: { showLogin = true }) {
                        Text("Sign In")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.white.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
        .sheet(isPresented: $showLogin) {
            LoginView()
        }
    }
}

struct OnboardingPage: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundStyle(.white)
            
            Text(title)
                .font(.title2.bold())
                .foregroundStyle(.white)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
}

#Preview {
    OnboardingView()
}
