import SwiftUI

struct MatchAnimationView: View {
    let currentUser: User
    let matchedUser: User
    let onSendMessage: () -> Void
    let onKeepSwiping: () -> Void
    
    @State private var showContent = false
    @State private var showPhotos = false
    @State private var showButtons = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [.pink, .purple, .pink.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Title
                VStack(spacing: 8) {
                    Text("IT'S A")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text("MATCH!")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                }
                .foregroundStyle(.white)
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.5)
                
                Text("You and \(matchedUser.name) liked each other!")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
                    .opacity(showContent ? 1 : 0)
                
                // Photos
                HStack(spacing: -30) {
                    // Current user
                    MatchPhoto(photoUrl: currentUser.primaryPhoto ?? "")
                        .offset(x: showPhotos ? 0 : -100)
                        .rotationEffect(.degrees(showPhotos ? -10 : 0))
                    
                    // Matched user
                    MatchPhoto(photoUrl: matchedUser.primaryPhoto ?? "")
                        .offset(x: showPhotos ? 0 : 100)
                        .rotationEffect(.degrees(showPhotos ? 10 : 0))
                }
                .opacity(showPhotos ? 1 : 0)
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 16) {
                    Button(action: onSendMessage) {
                        Text("Send a Message")
                            .fontWeight(.bold)
                            .foregroundStyle(.pink)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.white)
                            .clipShape(Capsule())
                    }
                    
                    Button(action: onKeepSwiping) {
                        Text("Keep Swiping")
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
                .opacity(showButtons ? 1 : 0)
                .offset(y: showButtons ? 0 : 50)
            }
            
            // Confetti (simplified)
            if showContent {
                ConfettiView()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                showContent = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3)) {
                showPhotos = true
            }
            withAnimation(.easeOut.delay(0.6)) {
                showButtons = true
            }
        }
    }
}

struct MatchPhoto: View {
    let photoUrl: String
    
    var body: some View {
        AsyncImage(url: URL(string: photoUrl)) { phase in
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
        .frame(width: 130, height: 130)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(.white, lineWidth: 4)
        )
        .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
    }
}

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
        }
        .onAppear {
            createParticles()
            animateParticles()
        }
    }
    
    private func createParticles() {
        let colors: [Color] = [.pink, .purple, .yellow, .orange, .white, .blue]
        
        for _ in 0..<50 {
            let particle = ConfettiParticle(
                id: UUID(),
                color: colors.randomElement()!,
                size: CGFloat.random(in: 5...12),
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: -20
                ),
                velocity: CGPoint(
                    x: CGFloat.random(in: -2...2),
                    y: CGFloat.random(in: 3...8)
                ),
                opacity: 1
            )
            particles.append(particle)
        }
    }
    
    private func animateParticles() {
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            for i in 0..<particles.count {
                particles[i].position.x += particles[i].velocity.x
                particles[i].position.y += particles[i].velocity.y
                particles[i].velocity.y += 0.1 // gravity
                
                if particles[i].position.y > UIScreen.main.bounds.height {
                    particles[i].opacity = 0
                }
            }
            
            if particles.allSatisfy({ $0.opacity == 0 }) {
                timer.invalidate()
            }
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id: UUID
    let color: Color
    let size: CGFloat
    var position: CGPoint
    var velocity: CGPoint
    var opacity: Double
}

#Preview {
    MatchAnimationView(
        currentUser: User.mockUsers[0],
        matchedUser: User.mockUsers[1],
        onSendMessage: {},
        onKeepSwiping: {}
    )
}
