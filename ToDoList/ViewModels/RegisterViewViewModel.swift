//
//  RegisterViewViewModel.swift
//  ToDoList
//
//  Created by Hamada Salhab on 03.02.2024.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

enum ValidationResult {
    case Valid
    case PasswordTooShort
    case InvalidEmail
    case EmptyName
    case EmptyEmail
    case EmptyPassword
}

class RegisterViewViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var loading = false

    init () {}
    
    func register() {
        self.loading = true
        
        let validationResult = validate()
        
        if validationResult != .Valid {
            switch validationResult {
            case.EmptyName:
                self.errorMessage = "Please fill in your full name"
            case.EmptyEmail:
                self.errorMessage = "Please fill in your email"
            case.EmptyPassword:
                self.errorMessage = "Please fill in your password"
            case.InvalidEmail:
                self.errorMessage = "Please provide a valid email"
            case.PasswordTooShort:
                self.errorMessage = "Your password should be at least 6 characters long"
            default:
                self.errorMessage = ""
            }
            
            self.loading = false
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                print("Error: \(error)")
                self?.loading = false
                return
            }
            
            guard let userID = result?.user.uid else {
                return
            }
            self?.insertUserRecord(id: userID)
            self?.loading = false
        }
    }
    
    private func insertUserRecord(id: String) {
        let newUser = User(
            id: id,
            email: email,
            joined: Date().timeIntervalSince1970,  
            fullName: fullName
        )
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    private func validate () -> ValidationResult {
        guard !fullName.trimmingCharacters(in: .whitespaces).isEmpty else {
            return .EmptyName
        }
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            return .EmptyEmail
        }
        guard !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            return .EmptyPassword
        }
        
        guard email.contains("@") && email.contains(".") else {
            return .InvalidEmail
        }
        
        guard password.count >= 6 else {
            return .PasswordTooShort
        }
        
        return .Valid
    }
}
