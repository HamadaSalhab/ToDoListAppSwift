//
//  ProfileView.swift
//  ToDoList
//
//  Created by Hamada Salhab on 03.02.2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.fetchedUser {
                    VStack {
                        Button {
                            viewModel.showImagePicker = true
                        } label: {
                            if let url = viewModel.user.profilePicURL, viewModel.profilePicture.pngData() == nil {
                                AsyncImage(
                                    url: URL(string: url),
                                    content: { image in
                                        image
                                            .resizable()
                                            .cornerRadius(50)
                                            .frame(width: 100, height: 100)
                                            .background(Color.black.opacity(0.2))
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(Circle())
                                            .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color(.label)))
                                            .shadow(color: Color(.label), radius: 1)
                                        
                                    },
                                    placeholder: {
                                        ProgressView()
                                            .frame(width: 70, height: 70)
                                    }
                                )
                            }
                            else if viewModel.profilePicture.pngData() == nil {
                                Image(systemName: "person.circle")
                                    .font(.system(size: 120))
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                            } else {
                                Image(uiImage: viewModel.profilePicture)
                                    .resizable()
                                    .cornerRadius(50)
                                    .frame(width: 120, height: 120)
                                    .background(Color.black.opacity(0.2))
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                            }
                        }
                        .disabled(!viewModel.editing)
                        .padding()
                        .sheet(isPresented: $viewModel.showImagePicker) {
                            ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.profilePicture)
                        }
                        
                        VStack(spacing: 20) {
                            if viewModel.editing {
                                CustomTextField(title: "FULL NAME", text: $viewModel.tempFullName)
                                CustomNonEditableTextField(title: "EMAIL", text: viewModel.user.email)
                                CustomTextField(title: "PHONE NUMBER", text: $viewModel.tempPhoneNumber)
                                CustomTextField(title: "ADDRESS", text: $viewModel.tempAddress)
                                CustomTextField(title: "COUNTRY", text: $viewModel.tempCountry)
                            } else {
                                CustomNonEditableTextField(title: "FULL NAME", text: viewModel.user.fullName)
                                CustomNonEditableTextField(title: "EMAIL", text: viewModel.user.email)
                                CustomNonEditableTextField(title: "PHONE NUMBER", text: viewModel.user.phoneNumber ?? "")
                                CustomNonEditableTextField(title: "ADDRESS", text: viewModel.user.address ?? "")
                                CustomNonEditableTextField(title: "COUNTRY", text: viewModel.user.country ?? "")
                            }
                        }
                        .padding()
                        Spacer()
                        Button {
                            viewModel.logOut()
                        } label: {
                            Text("Log Out")
                                .bold()
                                .font(.system(size: 20))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .foregroundColor(.white)
                                .frame(width: 120, height: 40)
                                .background(.red)
                                .cornerRadius(12)
                        }
                    }
                } else {
                    Spacer()
                    ProgressView()
                        .tint(.blue)
                        .scaleEffect(3)
                        .padding()
                }
                Spacer()
            }
            .navigationTitle("Profile")
            .navigationBarItems(
                leading: viewModel.editing ? AnyView(cancelButton) : AnyView(EmptyView()),
                trailing: viewModel.fetchedUser ? (viewModel.editing ? AnyView(saveButton) : AnyView(editButton)) : AnyView(EmptyView())
            )
        }
        .onAppear{
            viewModel.fetchUser()
        }
    }
    
    @ViewBuilder
    var cancelButton: some View {
        Button("Cancel") {
            viewModel.editing = false
        }
    }
    
    @ViewBuilder
    var saveButton: some View {
        Button("Save", action: {
            Task {
                await viewModel.persistChanges()
            }
            viewModel.editing = false
        })
    }
    
    @ViewBuilder
    var editButton: some View {
        Button("Edit") {
            viewModel.editing = true
        }
    }
    
}


struct CustomTextField: View {
    let title: String
    var text: Binding<String>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            TextField("", text: text)
            LinearGradient(colors: [.white, Color(.sRGB, white: 0.85, opacity: 1)], startPoint: .bottom, endPoint: .top)
                   .frame(height: 3)
                   .opacity(0.8)
        }
        .padding(.horizontal)
        .frame(height: 44)
        
    }
}

struct CustomNonEditableTextField: View {
    let title: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            TextField("", text: .constant(text))
                    .disabled(true)
            LinearGradient(colors: [.white, Color(.sRGB, white: 0.85, opacity: 1)], startPoint: .bottom, endPoint: .top)
                   .frame(height: 3)
                   .opacity(0.8)
        }
        .padding(.horizontal)
        .frame(height: 44)
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(
            viewModel: .init(user: .init(id: "sdlfkms", email: "doejohn@gmail.com", joined: 0, fullName: "John Doe"))
        )
    }
}
