//
//  LoginView.swift
//  Expense Tracker App
//
//  Created by Rafat on 2025-10-31.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    
    @StateObject private var auth = AuthService.shared
    
    var body: some View {
        Form {
            Section("Login") {
                TextField("Enter Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                
                SecureField("Password (Min 6 characters)", text: $password)
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
            
            Button("Login") {
                
                // Validations
                guard Validators.isValidEmail(email) else {
                    self.errorMessage = "Invalid Email"
                    return
                }
                
                guard Validators.isValidPassword(password) else {
                    self.errorMessage = "Invalid Password"
                    return
                }
                
                // Auth login
                auth.login(email: email, password: password) { result in
                    switch result {
                    case .success:
                        errorMessage = nil
                    case .failure(let err):
                        errorMessage = err.localizedDescription
                    }
                }
            }
            .disabled(email.isEmpty || password.isEmpty)
        }
    }
}

#Preview {
    LoginView()
}
