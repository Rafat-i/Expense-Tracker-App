//
//  AuthGate.swift
//  Expense Tracker App
//
//  Created by Rafat on 2025-10-31.
//

import SwiftUI

struct AuthGate: View {
    
    @State private var showLogin = true
    
    var body: some View {
        VStack {
            Picker("", selection: $showLogin) {
                Text("Login").tag(true)
                Text("Sign Up").tag(false)
            }
            .pickerStyle(.segmented)
            .padding()
            
            if showLogin {
                LoginView()
            } else {
                RegisterView()
            }
        }
    }
}

#Preview {
    AuthGate()
}
