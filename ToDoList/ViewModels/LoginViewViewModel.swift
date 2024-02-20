//
//  LoginViewViewModel.swift
//  ToDoList
//
//  Created by Hamada Salhab on 03.02.2024.
//

import FirebaseAuth
import Foundation

class LoginViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var loading = false
    
    init() {}
    
    func login() {
        guard validate() else {
            return
        }
        print("login started")
        self.loading = true
        Auth.auth().signIn(withEmail: email, password: password){ [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                self?.loading = false
                print("Error: \(error)")
                return
            }
//            guard let strongSelf = self else { return }
            self?.loading = false
        }
    }
    
    private func validate() -> Bool {
        errorMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            errorMessage = "Please fill in all fields."
            return false
        }
        
        guard email.contains("@") && email.contains(".") else{
            errorMessage = "Please enter a valid email."
            return false
        }
        
        return true
    }
}
