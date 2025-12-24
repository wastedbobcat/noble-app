import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    @State private var showVerification = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                // Logo
                Image(systemName: "flame.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.pink)
                
                Text("Welcome back!")
                    .font(.title.bold())
                
                if !showVerification {
                    // Phone number input
                    VStack(spacing: 16) {
                        Text("Enter your phone number to sign in")
                            .foregroundStyle(.secondary)
                        
                        TextField("Phone number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .textContentType(.telephoneNumber)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 32)
                        
                        Button(action: sendCode) {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Continue")
                            }
                        }
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(phoneNumber.count >= 10 ? .pink : .gray)
                        .clipShape(Capsule())
                        .disabled(phoneNumber.count < 10 || isLoading)
                        .padding(.horizontal, 32)
                    }
                } else {
                    // Verification code input
                    VStack(spacing: 16) {
                        Text("Enter the code sent to \(phoneNumber)")
                            .foregroundStyle(.secondary)
                        
                        TextField("000000", text: $verificationCode)
                            .keyboardType(.numberPad)
                            .font(.system(size: 32, weight: .bold, design: .monospaced))
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 32)
                        
                        Button("Resend code") {
                            sendCode()
                        }
                        .foregroundStyle(.pink)
                        
                        Button(action: verifyCode) {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Sign In")
                            }
                        }
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(verificationCode.count == 6 ? .pink : .gray)
                        .clipShape(Capsule())
                        .disabled(verificationCode.count != 6 || isLoading)
                        .padding(.horizontal, 32)
                    }
                }
                
                Spacer()
                
                // Alternative login methods
                VStack(spacing: 16) {
                    Text("Or continue with")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 20) {
                        SocialLoginButton(icon: "apple.logo", label: "Apple") {
                            // Apple Sign In
                        }
                        
                        SocialLoginButton(icon: "g.circle.fill", label: "Google") {
                            // Google Sign In
                        }
                    }
                }
                .padding(.bottom, 32)
            }
            .navigationTitle("Sign In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func sendCode() {
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            showVerification = true
        }
    }
    
    private func verifyCode() {
        isLoading = true
        
        // Simulate verification
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            authViewModel.isAuthenticated = true
            dismiss()
        }
    }
}

struct SocialLoginButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(label)
            }
            .fontWeight(.medium)
            .foregroundStyle(.primary)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .clipShape(Capsule())
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
