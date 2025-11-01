//
//  UserModel.swift
//  Expense Tracker App
//
//  Created by Rafat on 2025-10-31.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let email: String
    var username: String
}
