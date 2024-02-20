//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Hamada Salhab on 03.02.2024.
//

import FirebaseFirestoreSwift
import SwiftUI

struct ToDoListView: View {
    @StateObject var viewModel: ToDoListViewViewModel
    @FirestoreQuery var items: [ToDoListItem]
    
//    private let userID: String
    
    init(userID: String) {
//        self.userID = userID
        self._items = FirestoreQuery(
            collectionPath: "/users/\(userID)/todos")
        
        self._viewModel = StateObject(
            wrappedValue: ToDoListViewViewModel(userID: userID))
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(items) { item in
                    ToDoListItemView(item: item)
                        .swipeActions {
                            Button("Delete") {
                                viewModel.delete(itemID: item.id)
                            }
                            .tint(.red)
                        }
                }
            }
            .navigationTitle("To Do List")
            .toolbar {
                Button {
                    // Action
                    viewModel.showingNewItemView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewItemView(newItemPresented: $viewModel.showingNewItemView)
            }
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(userID: "C0TiUYpDVhhCEEj4GwCSSmJaJe22")
    }
}
