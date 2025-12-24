import SwiftUI
import PhotosUI

struct EditProfileView: View {
    let user: User
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var bio: String = ""
    @State private var selectedInterests: Set<String> = []
    @State private var prompts: [Prompt] = []
    @State private var showPhotoPicker = false
    
    private let allInterests = [
        "Travel", "Photography", "Yoga", "Coffee", "Reading", 
        "Cooking", "Hiking", "Wine", "Dancing", "Fitness",
        "Music", "Art", "Movies", "Gaming", "Sports",
        "Fashion", "Foodie", "Nature", "Pets", "Writing"
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Photos section
                    PhotosGridSection(photos: user.photos)
                    
                    // Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name")
                            .font(.headline)
                        TextField("Your name", text: $name)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.horizontal)
                    
                    // Bio
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About Me")
                            .font(.headline)
                        TextEditor(text: $bio)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.horizontal)
                    
                    // Interests
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Interests")
                                .font(.headline)
                            Spacer()
                            Text("\(selectedInterests.count)/5")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        FlowLayout(spacing: 8) {
                            ForEach(allInterests, id: \.self) { interest in
                                InterestSelectableTag(
                                    interest: interest,
                                    isSelected: selectedInterests.contains(interest),
                                    onTap: {
                                        if selectedInterests.contains(interest) {
                                            selectedInterests.remove(interest)
                                        } else if selectedInterests.count < 5 {
                                            selectedInterests.insert(interest)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Prompts
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Prompts")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(prompts.indices, id: \.self) { index in
                            EditablePromptCard(prompt: $prompts[index])
                        }
                        
                        if prompts.count < 3 {
                            Button(action: addPrompt) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Prompt")
                                }
                                .foregroundStyle(.pink)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.pink.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                name = user.name
                bio = user.bio
                selectedInterests = Set(user.interests)
                prompts = user.prompts
            }
        }
    }
    
    private func addPrompt() {
        prompts.append(Prompt(id: UUID().uuidString, question: "Select a prompt", answer: ""))
    }
    
    private func saveProfile() {
        // TODO: Save to backend
        dismiss()
    }
}

struct PhotosGridSection: View {
    let photos: [String]
    
    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Photos")
                .font(.headline)
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(0..<6, id: \.self) { index in
                    if index < photos.count {
                        AsyncImage(url: URL(string: photos[index])) { phase in
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
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(alignment: .topTrailing) {
                            if index == 0 {
                                Text("Main")
                                    .font(.caption2.bold())
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.pink)
                                    .clipShape(Capsule())
                                    .padding(8)
                            }
                        }
                    } else {
                        AddPhotoPlaceholder()
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct AddPhotoPlaceholder: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemGray6))
            .frame(height: 150)
            .overlay {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundStyle(.secondary)
            }
    }
}

struct InterestSelectableTag: View {
    let interest: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(interest)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.pink : Color(.systemGray6))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}

struct EditablePromptCard: View {
    @Binding var prompt: Prompt
    
    private let promptQuestions = [
        "A life goal of mine",
        "I'm looking for",
        "My simple pleasures",
        "Dating me is like",
        "The key to my heart is",
        "Together we could",
        "I geek out on",
        "My love language is"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Menu {
                ForEach(promptQuestions, id: \.self) { question in
                    Button(question) {
                        prompt.question = question
                    }
                }
            } label: {
                HStack {
                    Text(prompt.question)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            TextField("Your answer...", text: Binding(
                get: { prompt.answer },
                set: { prompt.answer = $0 }
            ), axis: .vertical)
                .lineLimit(2...4)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}

#Preview {
    EditProfileView(user: User.mockUsers[0])
}
