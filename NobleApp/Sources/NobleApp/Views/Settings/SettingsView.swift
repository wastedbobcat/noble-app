import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("maxDistance") private var maxDistance: Double = 25
    @AppStorage("ageRangeMin") private var ageRangeMin: Double = 18
    @AppStorage("ageRangeMax") private var ageRangeMax: Double = 50
    @AppStorage("showMe") private var showMe = true
    @AppStorage("globalMode") private var globalMode = false
    
    var body: some View {
        NavigationStack {
            List {
                // Discovery Settings
                Section("Discovery") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Maximum Distance")
                            Spacer()
                            Text("\(Int(maxDistance)) mi")
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $maxDistance, in: 1...100, step: 1)
                            .tint(.pink)
                    }
                    .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Age Range")
                            Spacer()
                            Text("\(Int(ageRangeMin)) - \(Int(ageRangeMax))")
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("\(Int(ageRangeMin))")
                                .font(.caption)
                            Slider(value: $ageRangeMin, in: 18...ageRangeMax - 1, step: 1)
                                .tint(.pink)
                            Text("\(Int(ageRangeMax))")
                                .font(.caption)
                        }
                        
                        Slider(value: $ageRangeMax, in: ageRangeMin + 1...100, step: 1)
                            .tint(.pink)
                    }
                    .padding(.vertical, 4)
                    
                    Toggle("Global Mode", isOn: $globalMode)
                        .tint(.pink)
                    
                    Toggle("Show me on Noble", isOn: $showMe)
                        .tint(.pink)
                }
                
                // Account
                Section("Account") {
                    NavigationLink("Phone Number") {
                        Text("Phone settings")
                    }
                    NavigationLink("Email") {
                        Text("Email settings")
                    }
                    NavigationLink("Connected Accounts") {
                        Text("Connected accounts")
                    }
                }
                
                // Notifications
                Section("Notifications") {
                    NavigationLink("Push Notifications") {
                        NotificationSettingsView()
                    }
                    NavigationLink("Email Notifications") {
                        Text("Email notification settings")
                    }
                }
                
                // Privacy
                Section("Privacy") {
                    NavigationLink("Block List") {
                        Text("Blocked users")
                    }
                    NavigationLink("Hide My Profile") {
                        Text("Privacy settings")
                    }
                    NavigationLink("Data & Privacy") {
                        Text("Data settings")
                    }
                }
                
                // Legal
                Section("Legal") {
                    NavigationLink("Privacy Policy") {
                        Text("Privacy Policy")
                    }
                    NavigationLink("Terms of Service") {
                        Text("Terms of Service")
                    }
                    NavigationLink("Licenses") {
                        Text("Open source licenses")
                    }
                }
                
                // Danger Zone
                Section {
                    Button("Delete Account", role: .destructive) {
                        // Show confirmation
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct NotificationSettingsView: View {
    @AppStorage("notifyNewMatches") private var notifyNewMatches = true
    @AppStorage("notifyMessages") private var notifyMessages = true
    @AppStorage("notifyLikes") private var notifyLikes = true
    @AppStorage("notifySuperLikes") private var notifySuperLikes = true
    
    var body: some View {
        List {
            Section {
                Toggle("New Matches", isOn: $notifyNewMatches)
                Toggle("Messages", isOn: $notifyMessages)
                Toggle("Likes", isOn: $notifyLikes)
                Toggle("Super Likes", isOn: $notifySuperLikes)
            }
        }
        .navigationTitle("Push Notifications")
        .tint(.pink)
    }
}

#Preview {
    SettingsView()
}
