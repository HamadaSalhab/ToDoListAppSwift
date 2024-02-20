//
//  ProfileViewViewModel.swift
//  ToDoList
//
//  Created by Hamada Salhab on 03.02.2024.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import FirebaseStorage

class ProfileViewViewModel: ObservableObject {
    @Published var user: User
    @Published var fetchedUser = false
    @Published var tempFullName = ""
    @Published var tempPhoneNumber = ""
    @Published var tempAddress = ""
    @Published var tempCountry = ""
    @Published var editing = false
    @Published var showImagePicker = false
    @Published var profilePicture = UIImage()
    
    init() {
        user = User(id: "",  email: "", joined: 0, fullName: "")
    }
    
    init(user: User) {
        self.user = user
    }
    
    func fetchUser(){
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).getDocument { [weak self] snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    return
                }
            
            DispatchQueue.main.async {
                self?.user = User(
                    id: data["id"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0,
                    fullName: data["fullName"] as? String ?? "",
                    phoneNumber: data["phoneNumber"] as? String ?? "",
                    address: data["address"] as? String ?? "",
                    country: data["country"] as? String ?? "",
                    profilePicURL: data["profilePicURL"] as? String ?? ""
                )
                self?.initTempFields()
                self?.fetchedUser = true
            }
        }
    }
    
    private func initTempFields() {
        self.tempFullName = self.user.fullName
        self.tempPhoneNumber = self.user.phoneNumber ?? ""
        self.tempAddress = self.user.address ?? ""
        self.tempCountry = self.user.country ?? ""
    }
    
    func persistChanges() async {
        self.user.fullName = self.tempFullName
        self.user.phoneNumber = self.tempPhoneNumber
        self.user.address = self.tempAddress
        self.user.country = self.tempCountry
        do {
            try await self.user.profilePicURL = saveProfilePicToFirebaseStorage(userID: self.user.id)
        } catch ProfileError.InvalidImageData {
            print("Error while converting image data to jpg")
        }
        catch {
            print("An unkown error occured while saving profile picture to firebase storage")
        }
        
        do {
            try await Firestore.firestore()
                .collection("users")
                .document(self.user.id)
                .setData(
                    [
                        "fullName": self.user.fullName,
                        "phoneNumber": self.user.phoneNumber ?? "",
                        "address": self.user.address ?? "",
                        "country": self.user.country ?? "",
                        "profilePicURL": self.user.profilePicURL ?? ""
                    ],
                    merge: true
                )
        } catch {
            print("An error occured: \(error)")
        }
        
    }
    
    private func saveProfilePicToFirebaseStorage (userID: String) async throws -> String {
        let imagePath = "profile-pictures/\(userID).jpeg"
        var profilePicURL = ""
        let ref = Storage.storage().reference(withPath: imagePath)
        guard let imageData = profilePicture.jpegData(compressionQuality: 0.5) else {
            print("Error while getting png data from image")
            throw ProfileError.InvalidImageData
        }
        
//        ref.putData(imageData, metadata: nil) { metadata, error in
//            
//            if let error = error {
//                print("Error while putting data in the reference. Error message: \(error)")
//                return
//            }
//            ref.downloadURL { url, error in
//                if let error = error {
//                    print("Error while downloading image url. Error Message: \(error)")
//                    return
//                }
//                profilePicURL = url?.absoluteString ?? ""
//                print("prfilePicUrl while saving: \(profilePicURL)")
//            }
//        }
        let metadata = try await ref.putDataAsync(imageData)
        return try await ref.downloadURL().absoluteString
        
//        print("Returned link: \(profilePicURL)")
//        return profilePicURL
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    

}

enum ProfileError: Error {
    case InvalidImageData
}
