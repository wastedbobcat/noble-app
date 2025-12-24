import SwiftUI

struct CardStackView: View {
    let users: [User]
    @Binding var currentIndex: Int
    let onSwipe: (SwipeDirection, User) -> Void
    
    var body: some View {
        ZStack {
            ForEach(Array(users.enumerated().reversed()), id: \.element.id) { index, user in
                if index >= currentIndex && index < currentIndex + 3 {
                    SwipeCardView(
                        user: user,
                        isTopCard: index == currentIndex,
                        onSwipe: { direction in
                            onSwipe(direction, user)
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                currentIndex += 1
                            }
                        }
                    )
                    .scaleEffect(scale(for: index))
                    .offset(y: offset(for: index))
                    .zIndex(Double(users.count - index))
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func scale(for index: Int) -> CGFloat {
        let position = index - currentIndex
        return 1.0 - CGFloat(position) * 0.05
    }
    
    private func offset(for index: Int) -> CGFloat {
        let position = index - currentIndex
        return CGFloat(position) * -10
    }
}

struct SwipeCardView: View {
    let user: User
    let isTopCard: Bool
    let onSwipe: (SwipeDirection) -> Void
    
    @State private var offset = CGSize.zero
    @State private var rotation: Double = 0
    @State private var currentPhotoIndex = 0
    
    private let swipeThreshold: CGFloat = 100
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Photo
                PhotoCarouselView(
                    photos: user.photos,
                    currentIndex: $currentPhotoIndex
                )
                
                // Gradient overlay
                LinearGradient(
                    colors: [.clear, .clear, .black.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // User info
                CardInfoView(user: user)
                
                // Swipe indicators
                SwipeIndicatorOverlay(offset: offset, threshold: swipeThreshold)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
            .offset(x: offset.width, y: offset.height)
            .rotationEffect(.degrees(rotation))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        guard isTopCard else { return }
                        offset = gesture.translation
                        rotation = Double(gesture.translation.width / 20)
                    }
                    .onEnded { gesture in
                        guard isTopCard else { return }
                        handleSwipeEnd(translation: gesture.translation)
                    }
            )
        }
        .aspectRatio(0.7, contentMode: .fit)
    }
    
    private func handleSwipeEnd(translation: CGSize) {
        let width = translation.width
        let height = translation.height
        
        if width > swipeThreshold {
            swipeAway(direction: .right)
        } else if width < -swipeThreshold {
            swipeAway(direction: .left)
        } else if height < -swipeThreshold {
            swipeAway(direction: .up)
        } else {
            resetPosition()
        }
    }
    
    private func swipeAway(direction: SwipeDirection) {
        withAnimation(.easeOut(duration: 0.3)) {
            switch direction {
            case .right:
                offset.width = 500
                rotation = 15
            case .left:
                offset.width = -500
                rotation = -15
            case .up:
                offset.height = -800
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onSwipe(direction)
        }
    }
    
    private func resetPosition() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            offset = .zero
            rotation = 0
        }
    }
}

struct PhotoCarouselView: View {
    let photos: [String]
    @Binding var currentIndex: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Current photo
                AsyncImage(url: URL(string: photos[currentIndex])) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(.gray.opacity(0.3))
                            .overlay {
                                ProgressView()
                            }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Rectangle()
                            .fill(.gray.opacity(0.3))
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                
                // Photo indicators
                VStack {
                    HStack(spacing: 4) {
                        ForEach(0..<photos.count, id: \.self) { index in
                            Capsule()
                                .fill(index == currentIndex ? .white : .white.opacity(0.5))
                                .frame(height: 3)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    
                    Spacer()
                }
                
                // Tap areas for navigation
                HStack(spacing: 0) {
                    // Left tap area
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if currentIndex > 0 {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    currentIndex -= 1
                                }
                            }
                        }
                    
                    // Right tap area
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if currentIndex < photos.count - 1 {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    currentIndex += 1
                                }
                            }
                        }
                }
            }
        }
    }
}

struct CardInfoView: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .bottom) {
                Text(user.name)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                Text(user.displayAge)
                    .font(.title)
                    .foregroundStyle(.white.opacity(0.9))
                
                if user.isVerified {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(.blue)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "info.circle")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            
            if let location = user.location {
                HStack {
                    Image(systemName: "location.fill")
                        .font(.caption)
                    Text(location.displayLocation)
                        .font(.subheadline)
                }
                .foregroundStyle(.white.opacity(0.8))
            }
            
            Text(user.bio)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .lineLimit(2)
            
            // Interests
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(user.interests, id: \.self) { interest in
                        Text(interest)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.white.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
            }
            .foregroundStyle(.white)
        }
        .padding(20)
    }
}

struct SwipeIndicatorOverlay: View {
    let offset: CGSize
    let threshold: CGFloat
    
    var body: some View {
        ZStack {
            // Like indicator (right)
            HStack {
                Spacer()
                Text("LIKE")
                    .font(.title.bold())
                    .foregroundStyle(.green)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.green, lineWidth: 4)
                    )
                    .rotationEffect(.degrees(-15))
                    .opacity(likeOpacity)
                Spacer()
                Spacer()
            }
            
            // Nope indicator (left)
            HStack {
                Spacer()
                Spacer()
                Text("NOPE")
                    .font(.title.bold())
                    .foregroundStyle(.red)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.red, lineWidth: 4)
                    )
                    .rotationEffect(.degrees(15))
                    .opacity(nopeOpacity)
                Spacer()
            }
            
            // Super Like indicator (up)
            VStack {
                Spacer()
                Text("SUPER LIKE")
                    .font(.title.bold())
                    .foregroundStyle(.blue)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.blue, lineWidth: 4)
                    )
                    .opacity(superLikeOpacity)
                Spacer()
                Spacer()
            }
        }
        .padding(40)
    }
    
    private var likeOpacity: Double {
        Double(max(0, min(offset.width / threshold, 1)))
    }
    
    private var nopeOpacity: Double {
        Double(max(0, min(-offset.width / threshold, 1)))
    }
    
    private var superLikeOpacity: Double {
        Double(max(0, min(-offset.height / threshold, 1)))
    }
}

#Preview {
    CardStackView(
        users: User.mockUsers,
        currentIndex: .constant(0),
        onSwipe: { _, _ in }
    )
    .padding()
}
