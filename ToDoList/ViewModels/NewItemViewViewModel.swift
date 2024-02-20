//
//  NewItemViewViewModel.swift
//  ToDoList
//
//  Created by Hamada Salhab on 03.02.2024.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class NewItemViewViewModel: ObservableObject {
    @Published var title = ""
    @Published var dueDate = Date()
    @Published var showAlert = false
    
    init() {}
    
    func save () {
        guard canSave else {
            return
        }
        
        // Get current user id
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        
        
        // Create model
        let newID = UUID().uuidString
        let newToDoListItem = ToDoListItem(
            id: newID,
            title: title,
            dueDate: dueDate.timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isDone: false)
        
        // Save model
        let db = Firestore.firestore()
        db.collection("users")
            .document(userID)
            .collection("todos")
            .document(newID)
            .setData(newToDoListItem.asDictionary())
        
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else{
            return false
        }
        
        guard dueDate >= Date().addingTimeInterval(-(60 * 60 * 24)) else {
            return false
        }
        return true
    }
}
