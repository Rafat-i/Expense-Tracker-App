//
//  ProfileView.swift
//  Expense Tracker App
//
//  Created by Rafat on 2025-11-16.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var auth = AuthService.shared
    @State private var newUsername = ""
    @State private var errorText: String?
    @State private var successMessage: String?

    var body: some View {
        Form {
            Section("Profile") {
                Text("Email: \(auth.currentUser?.email ?? "-")")
                Text("Username: \(auth.currentUser?.username ?? "-")")
            }

            Section("Update Username") {
                TextField("New Username", text: $newUsername)

                Button("Save") {
                    let trimmed = newUsername.trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty else {
                        errorText = "Username cannot be empty"
                        successMessage = nil
                        return
                    }

                    auth.updateUsername(username: trimmed) { result in
                        switch result {
                        case .success:
                            newUsername = ""
                            errorText = nil
                            successMessage = "Username updated successfully!"
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                successMessage = nil
                            }
                        case .failure(let err):
                            errorText = err.localizedDescription
                            successMessage = nil
                        }
                    }
                }
            }

            if let errorText {
                Text(errorText)
                    .foregroundColor(.red)
            }
            
            if let successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
            }

            Button(role: .destructive) {
                let result = auth.signOut()
                if case .failure(let err) = result {
                    errorText = err.localizedDescription
                } else {
                    errorText = nil
                    successMessage = nil
                }
            } label: {
                Text("Log Out")
            }
        }
        .onAppear {
            auth.fetchCurrentUser { _ in }
        }
    }
}

#Preview {
    ProfileView()
}


