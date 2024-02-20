//
//  LoginView.swift
//  ToDoList
//
//  Created by Hamada Salhab on 03.02.2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HeaderView(title: "To Do List", subtitle: "Get things done!", rotationAngle: 15, backgroundColor: Color.pink)
                
                // Login Form
                if viewModel.loading == false {
                    Form {
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundColor(Color.red)
                        }
                        
                        TextField("Email Address", text: $viewModel.email)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(DefaultTextFieldStyle())
                        
                        TLButton(title: "Log In", backgroundColor: .blue) {
                            viewModel.login()
                        }
                        .padding(.vertical)
                    }
                    .offset(y: -50)
                } else {
                    ProgressView()
                        .scaleEffect(3)
                        .tint(.pink)
                        .padding()
                    Spacer()
                }
                
                // Create Account
                VStack {
                    Text("New around here?")
                    NavigationLink("Create a new account", destination: RegisterView())
                }
                .padding(.bottom, 50)
                
                
                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
