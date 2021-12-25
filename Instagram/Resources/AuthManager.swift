//
//  AuthManager.swift
//  Instagram
//
//  Created by aleksandar on 15.12.21..
//

import Foundation
import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    
    //MARK: - Public
    
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        /*
         -Check if username is available
         -Check if email is available
         */
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            if canCreate {
                /*
                 -Create Account
                 -Insert Account in database
                 */
                Auth.auth().createUser(withEmail: email, password: password) { results, error in
                    guard error == nil, results != nil else {
                        //Firebase could not create acc
                        completion(false)
                        return
                    }
                    //Insert into database
                    DatabaseManager.shared.insertNewUser(with: email, username: username) { inserted in
                        if inserted {
                           completion(true)
                            return
                        } else {
                            //failed to insert into database
                            completion(false)
                            return
                        }
                    }
                }
            } else {
                //username or email doesnt exist
                completion(false)
            }
        }
    }
    
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void) {
        if let email = email {
            //email login
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        } else if let username = username {
            //username login
            print(username)
        }
    }
    
    ///Attempt to log out user
    public func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        } catch {
            print(error)
            completion(false)
            return
        }
    }
    
}
