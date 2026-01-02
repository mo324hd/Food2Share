//
//  FirebaseAuthHelper.swift
//  F2SAuthicate
//
//  Created by abdulaziz on 18/12/2025.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FirebaseAuthHelper {

    static let shared = FirebaseAuthHelper()

    private let auth = Auth.auth()
    private let db = Firestore.firestore()

    private init() {}

    // MARK: - Sign Up
    func signUp(
        fullName: String,
        phone: String,
        email: String,
        password: String,
        location: String,
        userType: UserType,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self else { return }

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let uid = result?.user.uid else {
                completion(.failure(AuthError.unknown))
                return
            }

            let userData: [String: Any] = [
                "uid": uid,
                "fullName": fullName,
                "phone": phone,
                "email": email,
                "location": location,
                "userType": userType.rawValue,
                "isVerified": false,
                "createdAt": Timestamp()
            ]

            self.db.collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    // MARK: - Login
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<(User, String), Error>) -> Void
    ) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self else { return }

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user else {
                completion(.failure(AuthError.unknown))
                return
            }

            self.checkVerificationStatus(uid: user.uid) { result in
                switch result {
                case .success(let userType):
                    completion(.success((user, userType)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }


    // MARK: - Verification Check
    private func checkVerificationStatus(
        uid: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        db.collection("users").document(uid).getDocument { document, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard
                let data = document?.data(),
                let isVerified = data["isVerified"] as? Bool,
                let userType = data["userType"] as? String
            else {
                completion(.failure(AuthError.invalidUserData))
                return
            }

            Auth.auth().currentUser?.reload { reloadError in
                if reloadError != nil {
                    completion(.failure(reloadError!))
                    return
                }

                let firebaseVerified = Auth.auth().currentUser?.isEmailVerified ?? false

                // Admin does NOT require verification
                if userType == "admin" {
                    completion(.success(userType))
                    return
                }

                if isVerified && firebaseVerified {
                    completion(.success(userType))
                } else {
                    completion(.failure(AuthError.notVerified))
                }
            }
        }
    }


    // MARK: - Logout
    func logout() throws {
        try auth.signOut()
    }
}


enum UserType: String {
    case donor
    case collector
}



enum AuthError: LocalizedError {
    case notVerified
    case invalidUserData
    case unknown

    var errorDescription: String? {
        switch self {
        case .notVerified:
            return "Your account is pending verification."
        case .invalidUserData:
            return "User data is invalid."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}

extension FirebaseAuthHelper {

    func saveGoogleUserToFirestore(user: User, completion: @escaping (Bool) -> Void) {
        let ref = db.collection("users").document(user.uid)

        ref.getDocument { document, error in
            if let document = document, document.exists {
                completion(true)   // user already exists, no need to save again
                return
            }

            let data: [String: Any] = [
                "uid": user.uid,
                "fullName": user.displayName ?? "",
                "email": user.email ?? "",
                "location": "",
                "phone": "",
                "userType": UserType.donor.rawValue,  // default OR detect
                "isVerified": true,
                "createdAt": Timestamp()
            ]

            ref.setData(data) { error in
                completion(error == nil)
            }
        }
    }
}
