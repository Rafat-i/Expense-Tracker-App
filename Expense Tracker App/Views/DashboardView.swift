//
//  DashboardView.swift
//  Expense Tracker App
//
//  Created by Rafat on 2025-10-31.
//

import SwiftUI

struct DashboardView: View {
    
    @StateObject private var auth = AuthService.shared
    @StateObject private var transactionService = TransactionService.shared
    
    @State private var isLoaded = false
    @State private var errorMessage: String?
    
    var totalIncome: Double {
        var total = 0.0
        for transaction in transactionService.transactions {
            if transaction.type == "INCOME" {
                total += transaction.amount
            }
        }
        return total
    }

    var totalExpense: Double {
        var total = 0.0
        for transaction in transactionService.transactions {
            if transaction.type == "EXPENSE" {
                total += transaction.amount
            }
        }
        return total
    }
    
    var balance: Double {
        totalIncome - totalExpense
    }
    
    var body: some View {
        NavigationView {
            Group {
                if !isLoaded {
                    ProgressView()
                        .onAppear {
                            loadData()
                        }
                } else {
                    VStack(spacing: 20) {
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Welcome,")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                Text(auth.currentUser?.username ?? "User")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .fontDesign(.rounded)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .foregroundStyle(.blue.gradient)
                                .shadow(radius: 3)
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)
                        
                        VStack(spacing: 15) {
                            Text("Total Balance")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Text("$\(balance, specifier: "%.2f")")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(balance >= 0 ? .green : .red)
                            
                            HStack(spacing: 40) {
                                VStack {
                                    Text("Income")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("$\(totalIncome, specifier: "%.2f")")
                                        .font(.headline)
                                        .foregroundColor(.green)
                                }
                                
                                VStack {
                                    Text("Expenses")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("$\(totalExpense, specifier: "%.2f")")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        VStack(spacing: 15) {
                            NavigationLink(destination: AddTransactionView()) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Transaction")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            
                            NavigationLink(destination: TransactionListView()) {
                                HStack {
                                    Image(systemName: "list.bullet")
                                    Text("View Transactions")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            
                            NavigationLink(destination: SummaryView()) {
                                HStack {
                                    Image(systemName: "chart.bar.fill")
                                    Text("View Summary")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        Button(role: .destructive, action: {
                            let result = auth.signOut()
                            if case .failure(let err) = result {
                                errorMessage = err.localizedDescription
                            }
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Logout")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func loadData() {
        transactionService.fetchTransactions { result in
            switch result {
            case .success:
                isLoaded = true
                errorMessage = nil
            case .failure(let error):
                isLoaded = true
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    DashboardView()
}

