//
//  ContentView.swift
//  Expense Tracker App
//
//  Created by Rafat on 2025-10-31.
//

import SwiftUI

struct ContentView: View {
    
    enum Tab {
        case dashboard, summary, profile
    }
    
    @StateObject private var auth = AuthService.shared
    @State private var isLoaded = false
    @State private var tab: Tab = .dashboard
    
    var body: some View {
        
        Group {
            if !isLoaded {
                ProgressView()
                    .onAppear {
                        auth.fetchCurrentUser { _ in
                            isLoaded = true
                        }
                    }
            }
            else if auth.currentUser == nil {
                AuthGate()
            }
            else {
                
                ZStack(alignment: .bottom) {
                    
                    VStack {
                        Group {
                            switch tab {
                            case .dashboard:
                                NavigationView {
                                    DashboardView()
                                }
                            case .summary:
                                NavigationView {
                                    SummaryView()
                                }
                            case .profile:
                                NavigationView {
                                    ProfileView()
                                }
                            }
                        }
                        
                        HStack {
                            TabButton(title: "Dashboard", image: "house.fill", isSelected: tab == .dashboard) {
                                tab = .dashboard
                            }
                            
                            Spacer()
                            
                            TabButton(title: "Summary", image: "chart.bar.fill", isSelected: tab == .summary) {
                                tab = .summary
                            }
                            
                            Spacer()
                            
                            TabButton(title: "Profile", image: "person.fill", isSelected: tab == .profile) {
                                tab = .profile
                            }
                        }
                        .padding(.vertical, 14)
                        .padding(.horizontal, 30)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 0)
                        )
                        .ignoresSafeArea(.keyboard)
                        .ignoresSafeArea(edges: .bottom)
                    }
                }
            }
        }
    }
}

struct TabButton: View {
    let title: String
    let image: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: image)
                    .font(.system(size: 20))
                Text(title)
                    .font(.system(size: 13))
            }
            .foregroundColor(isSelected ? .blue : .black)
        }
    }
}

#Preview {
    ContentView()
}
