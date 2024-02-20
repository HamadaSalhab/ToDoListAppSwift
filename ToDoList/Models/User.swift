//
//  User.swift
//  ToDoList
//
//  Created by Hamada Salhab on 03.02.2024.
//

import Foundation

struct User: Codable {
    let id: String
    let email: String
    let joined: TimeInterval
    var fullName: String
    var phoneNumber: String?
    var address: String?
    var country: String?
    var profilePicURL: String?
    
    init(
        id: String,
        email: String,
        joined: TimeInterval,
        fullName: String,
        phoneNumber: String? = nil,
        address: String? = nil,
        country: String? = nil,
        profilePicURL: String? = nil) 
    {
        self.id = id
        self.email = email
        self.joined = joined
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.address = address
        self.country = country
        self.profilePicURL = profilePicURL
    }
    
}
