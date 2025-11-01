//
//  ContentView.swift
//  Expense Tracker App
//
//  Created by Rafat on 2025-10-31.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var auth = AuthService.shared
    @State private var isLoaded = false
    
    var body: some View {
        Group {
            if !isLoaded {
                ProgressView()
                    .onAppear {
                        auth.fetchCurrentUser { _ in
                            isLoaded = true
                        }
                    }
            } else if auth.currentUser == nil {
                AuthGate()
            } else {
                DashboardView()
            }
        }
    }
}

#Preview {
    ContentView()
}
