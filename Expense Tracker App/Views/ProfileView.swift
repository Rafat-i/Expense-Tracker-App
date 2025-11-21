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
                        return
                    }

                    auth.updateUsername(username: trimmed) { result in
                        switch result {
                        case .success:
                            newUsername = ""
                            errorText = nil
                        case .failure(let err):
                            errorText = err.localizedDescription
                        }
                    }
                }
            }

            if let errorText {
                Text(errorText)
                    .foregroundColor(.red)
            }

            Button(role: .destructive) {
                let result = auth.signOut()
                if case .failure(let err) = result {
                    errorText = err.localizedDescription
                } else {
                    errorText = nil
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


