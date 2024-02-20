//
//  ToDoListViewViewModel.swift
//  ToDoList
//
//  Created by Hamada Salhab on 03.02.2024.
//

import FirebaseFirestore
import Foundation

class ToDoListViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    
    private let userID: String
    
    init(userID: String) {
        self.userID = userID
    }
    
    func delete(itemID: String) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userID)
            .collection("todos")
            .document(itemID)
            .delete()
    }
}
