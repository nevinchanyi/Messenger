//
//  DatabaseManager.swift
//  Messenger
//
//  Created by constantine kos on 09.12.2020.
//

import Foundation
import FirebaseDatabase


final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
}

//MARK: Account Management
extension DatabaseManager {
    
    // validate user with email
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "_")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
        }
        completion(true)
    }
    
    // inserts new user to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
}


struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "_")
        return safeEmail
    }
    //let profilePictureURL: String
}