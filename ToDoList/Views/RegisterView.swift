//
//  RegisterView.swift
//  ToDoList
//
//  Created by Hamada Salhab on 03.02.2024.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    
    var body: some View {
        VStack {
            HeaderView(title: "Register",
                       subtitle: "Start organizing todos",
                       rotationAngle: -15,
                       backgroundColor: Color.orange)
            
            // Register Form
            if viewModel.loading == true {
                Spacer()
                Form {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color.red)
                    }
                    
                    TextField("Full Name", text: $viewModel.fullName)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                    
                    TLButton(title: "Create Account", backgroundColor: .blue) {
                        viewModel.register()
                    }
                    
                    .padding(.vertical)
                }
                .offset(y: -50)
            } else {
                ProgressView()
//                    .controlSize(.large)
                    .scaleEffect(3)
                    .tint(.orange)
                    .padding()
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
