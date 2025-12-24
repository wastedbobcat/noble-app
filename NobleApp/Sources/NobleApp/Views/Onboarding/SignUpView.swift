import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var step = 0
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    @State private var name = ""
    @State private var birthday = Date()
    @State private var selectedGender: Gender?
    @State private var lookingFor: Set<Gender> = []
    
    var body: some View {
        NavigationStack {
            VStack {
                // Progress bar
                ProgressView(value: Double(step + 1), total: 5)
                    .tint(.pink)
                    .padding(.horizontal)
                
                // Content
                TabView(selection: $step) {
                    PhoneNumberStep(phoneNumber: $phoneNumber, onContinue: { step = 1 })
                        .tag(0)
                    
                    VerificationStep(code: $verificationCode, phoneNumber: phoneNumber, onContinue: { step = 2 })
                        .tag(1)
                    
                    NameStep(name: $name, onContinue: { step = 3 })
                        .tag(2)
                    
                    BirthdayStep(birthday: $birthday, onContinue: { step = 4 })
                        .tag(3)
                    
                    GenderStep(
                        selectedGender: $selectedGender,
                        lookingFor: $lookingFor,
                        onContinue: completeSignUp
                    )
                    .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: step)
            }
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if step > 0 {
                        Button(action: { step -= 1 }) {
                            Image(systemName: "chevron.left")
                        }
                    } else {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    private func completeSignUp() {
        authViewModel.isAuthenticated = true
        dismiss()
    }
}

struct PhoneNumberStep: View {
    @Binding var phoneNumber: String
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 12) {
                Text("What's your phone number?")
                    .font(.title2.bold())
                
                Text("We'll send you a verification code")
                    .foregroundStyle(.secondary)
            }
            
            TextField("Phone number", text: $phoneNumber)
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 32)
            
            Spacer()
            
            Button(action: onContinue) {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(phoneNumber.count >= 10 ? .pink : .gray)
                    .clipShape(Capsule())
            }
            .disabled(phoneNumber.count < 10)
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
    }
}

struct VerificationStep: View {
    @Binding var code: String
    let phoneNumber: String
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 12) {
                Text("Enter verification code")
                    .font(.title2.bold())
                
                Text("Sent to \(phoneNumber)")
                    .foregroundStyle(.secondary)
            }
            
            TextField("000000", text: $code)
                .keyboardType(.numberPad)
                .font(.system(size: 32, weight: .bold, design: .monospaced))
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 32)
            
            Button("Resend code") {
                // Resend
            }
            .foregroundStyle(.pink)
            
            Spacer()
            
            Button(action: onContinue) {
                Text("Verify")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(code.count == 6 ? .pink : .gray)
                    .clipShape(Capsule())
            }
            .disabled(code.count != 6)
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
    }
}

struct NameStep: View {
    @Binding var name: String
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 12) {
                Text("What's your first name?")
                    .font(.title2.bold())
                
                Text("This is how you'll appear on Noble")
                    .foregroundStyle(.secondary)
            }
            
            TextField("First name", text: $name)
                .textContentType(.givenName)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 32)
            
            Spacer()
            
            Button(action: onContinue) {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(name.count >= 2 ? .pink : .gray)
                    .clipShape(Capsule())
            }
            .disabled(name.count < 2)
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
    }
}

struct BirthdayStep: View {
    @Binding var birthday: Date
    let onContinue: () -> Void
    
    private var isOldEnough: Bool {
        let age = Calendar.current.dateComponents([.year], from: birthday, to: Date()).year ?? 0
        return age >= 18
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 12) {
                Text("When's your birthday?")
                    .font(.title2.bold())
                
                Text("You must be at least 18 to use Noble")
                    .foregroundStyle(.secondary)
            }
            
            DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
            
            Spacer()
            
            Button(action: onContinue) {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(isOldEnough ? .pink : .gray)
                    .clipShape(Capsule())
            }
            .disabled(!isOldEnough)
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
    }
}

struct GenderStep: View {
    @Binding var selectedGender: Gender?
    @Binding var lookingFor: Set<Gender>
    let onContinue: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Your gender
                VStack(alignment: .leading, spacing: 16) {
                    Text("I am a...")
                        .font(.title2.bold())
                    
                    ForEach(Gender.allCases, id: \.self) { gender in
                        GenderOption(
                            gender: gender,
                            isSelected: selectedGender == gender,
                            onTap: { selectedGender = gender }
                        )
                    }
                }
                
                // Looking for
                VStack(alignment: .leading, spacing: 16) {
                    Text("I'm interested in...")
                        .font(.title2.bold())
                    
                    ForEach(Gender.allCases, id: \.self) { gender in
                        GenderOption(
                            gender: gender,
                            isSelected: lookingFor.contains(gender),
                            onTap: {
                                if lookingFor.contains(gender) {
                                    lookingFor.remove(gender)
                                } else {
                                    lookingFor.insert(gender)
                                }
                            }
                        )
                    }
                }
                
                Button(action: onContinue) {
                    Text("Get Started")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(canContinue ? .pink : .gray)
                        .clipShape(Capsule())
                }
                .disabled(!canContinue)
            }
            .padding(32)
        }
    }
    
    private var canContinue: Bool {
        selectedGender != nil && !lookingFor.isEmpty
    }
}

struct GenderOption: View {
    let gender: Gender
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(gender.rawValue)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.pink)
                }
            }
            .padding()
            .background(isSelected ? Color.pink.opacity(0.1) : Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .pink : .clear, lineWidth: 2)
            )
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
}
