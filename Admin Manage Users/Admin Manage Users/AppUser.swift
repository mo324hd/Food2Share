//
//  AppUser.swift
//  Admin Manage Users
//
//  Created by BP-36-201-10 on 07/12/2025.
//

import Foundation

struct User {
    let id: Int
    var name: String
    var email: String
    var age: Int
    var isActive: Bool
    var role: String   // "donor", "collector", "admin"
}



let users: [User] = [
    User(id: 1, name: "Ahmed Ali", email: "ahmed1@email.com", age: 22, isActive: true, role: "donor"),
    User(id: 2, name: "Sara Hassan", email: "sara2@email.com", age: 21, isActive: true, role: "collector"),
    User(id: 3, name: "Omar Khalid", email: "omar3@email.com", age: 25, isActive: false, role: "donor"),
    User(id: 4, name: "Fatima Noor", email: "fatima4@email.com", age: 23, isActive: true, role: "collector"),
    User(id: 5, name: "Yusuf Adel", email: "yusuf5@email.com", age: 27, isActive: false, role: "admin"),
    User(id: 6, name: "Aisha Karim", email: "aisha6@email.com", age: 20, isActive: true, role: "donor"),
    User(id: 7, name: "Hassan Saleh", email: "hassan7@email.com", age: 24, isActive: true, role: "collector"),
    User(id: 8, name: "Mariam Zaid", email: "mariam8@email.com", age: 22, isActive: false, role: "donor"),
    User(id: 9, name: "Khalid Rahman", email: "khalid9@email.com", age: 29, isActive: true, role: "admin"),
    User(id: 10, name: "Noor Ahmed", email: "noor10@email.com", age: 19, isActive: true, role: "donor"),

    User(id: 11, name: "Tariq Mansoor", email: "tariq11@email.com", age: 26, isActive: false, role: "collector"),
    User(id: 12, name: "Laila Yusuf", email: "laila12@email.com", age: 23, isActive: true, role: "donor"),
    User(id: 13, name: "Salman Rafi", email: "salman13@email.com", age: 28, isActive: true, role: "admin"),
    User(id: 14, name: "Rania Adel", email: "rania14@email.com", age: 21, isActive: false, role: "collector"),
    User(id: 15, name: "Bilal Hamza", email: "bilal15@email.com", age: 24, isActive: true, role: "donor"),
    User(id: 16, name: "Huda Nasser", email: "huda16@email.com", age: 22, isActive: true, role: "collector"),
    User(id: 17, name: "Zain Farooq", email: "zain17@email.com", age: 27, isActive: false, role: "donor"),
    User(id: 18, name: "Reem Saeed", email: "reem18@email.com", age: 20, isActive: true, role: "collector"),
    User(id: 19, name: "Adnan Qasim", email: "adnan19@email.com", age: 30, isActive: false, role: "admin"),
    User(id: 20, name: "Sana Fawaz", email: "sana20@email.com", age: 24, isActive: true, role: "donor")
]


