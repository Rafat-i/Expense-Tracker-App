//
//  Validators.swift
//  Expense Tracker App
//
//  Created by Rafat on 2025-10-31.
//

import Foundation
// enum
enum Validators {
    static func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^\S+@\S+\.\S+$"# //  Ex - something@domain.com
        return email.range(of: pattern, options: .regularExpression) != nil
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        password.count >= 6
    }
}



// struct SimpleError
// SimpleError

struct SimpleError: Error {
    
    
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    var localizedDescription: String { message }
}
