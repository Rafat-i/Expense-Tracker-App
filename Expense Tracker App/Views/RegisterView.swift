//
//  RegisterView.swift
//  Expense Tracker App
//
//  Created by Rafat on 2025-10-31.
//

import SwiftUI

struct RegisterView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var errorMessage: String?
    
    @StateObject private var auth = AuthService.shared
    
    var body: some View {
        Form {
            Section("Create Account") {
                TextField("Enter Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                
                SecureField("Password (Min 6 characters)", text: $password)
                
                TextField("Username", text: $username)
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
            
            Button("Sign Up") {
                
                // Validations
                guard Validators.isValidEmail(email) else {
                    self.errorMessage = "Invalid Email"
                    return
                }
                
                guard Validators.isValidPassword(password) else {
                    self.errorMessage = "Invalid Password"
                    return
                }
                
                guard !username.trimmingCharacters(in: .whitespaces).isEmpty else {
                    self.errorMessage = "Username is required"
                    return
                }
                
                // Auth sign up
                auth.signUp(email: email, password: password, username: username) { result in
                    switch result {
                    case .success:
                        self.errorMessage = nil
                    case .failure(let failure):
                        self.errorMessage = failure.localizedDescription
                    }
                }
            }
            .disabled(email.isEmpty || password.isEmpty || username.isEmpty)
        }
    }
}

#Preview {
    RegisterView()
}
