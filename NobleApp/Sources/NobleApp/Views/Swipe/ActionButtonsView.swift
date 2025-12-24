import SwiftUI

struct ActionButtonsView: View {
    let onRewind: () -> Void
    let onPass: () -> Void
    let onSuperLike: () -> Void
    let onLike: () -> Void
    let onBoost: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Rewind
            ActionButton(
                icon: "arrow.uturn.backward",
                color: .orange,
                size: .small,
                action: onRewind
            )
            
            // Pass
            ActionButton(
                icon: "xmark",
                color: .red,
                size: .large,
                action: onPass
            )
            
            // Super Like
            ActionButton(
                icon: "star.fill",
                color: .blue,
                size: .medium,
                action: onSuperLike
            )
            
            // Like
            ActionButton(
                icon: "heart.fill",
                color: .green,
                size: .large,
                action: onLike
            )
            
            // Boost
            ActionButton(
                icon: "bolt.fill",
                color: .purple,
                size: .small,
                action: onBoost
            )
        }
    }
}

struct ActionButton: View {
    enum Size {
        case small, medium, large
        
        var buttonSize: CGFloat {
            switch self {
            case .small: return 44
            case .medium: return 52
            case .large: return 64
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 18
            case .medium: return 22
            case .large: return 28
            }
        }
    }
    
    let icon: String
    let color: Color
    let size: Size
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                action()
            }
        }) {
            Image(systemName: icon)
                .font(.system(size: size.iconSize, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: size.buttonSize, height: size.buttonSize)
                .background(
                    Circle()
                        .fill(.white)
                        .shadow(color: color.opacity(0.3), radius: 8, y: 4)
                )
                .overlay(
                    Circle()
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        }
        .scaleEffect(isPressed ? 0.85 : 1.0)
        .buttonStyle(.plain)
    }
}

#Preview {
    ActionButtonsView(
        onRewind: {},
        onPass: {},
        onSuperLike: {},
        onLike: {},
        onBoost: {}
    )
    .padding()
    .background(Color.gray.opacity(0.1))
}
