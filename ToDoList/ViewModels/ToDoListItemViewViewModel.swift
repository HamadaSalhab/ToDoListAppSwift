//
//  ToDoListItemViewViewModel.swift
//  ToDoList
//
//  Created by Hamada Salhab on 03.02.2024.
//


import FirebaseAuth
import FirebaseFirestore
import Foundation

class ToDoListItemViewViewModel: ObservableObject {
    init() {}
    
    func toggleIsDone(item: ToDoListItem) {
        var itemCopy = item
        itemCopy.setDone(!itemCopy.isDone)
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(userID)
            .collection("todos")
            .document(item.id)
            .setData(itemCopy.asDictionary())
    }
}
