//
//  LoginViewController.swift
//  F2SAuthicate
//
//  Created by abdulaziz on 18/12/2025.
//


import UIKit
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import AuthenticationServices
import CryptoKit

final class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!

    @IBOutlet weak var remeberButt: UIButton!
    @IBOutlet weak var loginOt: UIButton!
    @IBOutlet private weak var donorButton: UIButton!
    @IBOutlet private weak var collectorButton: UIButton!
    @IBOutlet private weak var collectorView: UIView!
    @IBOutlet private weak var donororView: UIView!
    
    var remeember = true
    fileprivate var currentNonce: String?
    private var activityIndicator = UIActivityIndicatorView(style: .large)

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        passwordTextField.isSecureTextEntry = true
        loginOt.layer.cornerRadius = 10
        selectUserType(.donor)
    }

    
    @IBAction private func donorTapped(_ sender: UIButton) {
        selectUserType(.donor)
    }

    @IBAction private func collectorTapped(_ sender: UIButton) {
        selectUserType(.collector)
    }

    private func selectUserType(_ type: UserType) {

        donororView.isHidden = (type != .donor)
        collectorView.isHidden = (type != .collector)

    }

    @IBAction func rememberClicked(_ sender: UIButton) {
        remeember.toggle()
        updateRememberStatus(remeember)
    }
    
    @IBAction func googleLoginTapped(_ sender: UIButton) {
        googleLogin()
    }


    private func updateRememberStatus(_ remember: Bool) {
        let imageName = remember ? "checkmark.square.fill" : "square"
        let image = UIImage(systemName: imageName)

        remeberButt.setImage(image, for: .normal)
    }

    @IBAction func SignUp(_ sender: Any) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultController = storyboard.instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController

        resultController?.modalPresentationStyle = .fullScreen
        self.present(resultController ?? ViewController() , animated: true, completion: nil)
        
    }
    
    // MARK: - Login
    @IBAction private func loginTapped(_ sender: UIButton) {
        loginUser()
    }

    
    @IBAction func appleLoginTapped(_ sender: UIButton) {
        startAppleLogin()
    }

    private func loginUser() {

        guard
            let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else {
            showAlert("Please enter email and password.")
            return
        }

        activityIndicator.startAnimating()   // START LOADING

        FirebaseAuthHelper.shared.login(
            email: email,
            password: password
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                self.activityIndicator.stopAnimating()   // STOP LOADING

                switch result {
                case .success(let (user, userType)):

                    print("=== LOGIN SUCCESS ===")
                    print("UID:", user.uid)
                    print("Email:", user.email ?? "No Email")
                    print("User Type:", userType)
                    print("=====================")

                    let userName = email.components(separatedBy: "@").first ?? "User"

                    if userType == "admin" {
                        self.navigateToAdminScreen()
                    } else {
                        self.showAlert("Welcome \(userName)", title: "Login Success")
                    }

                case .failure(let error):
                    print("LOGIN FAILED:", error.localizedDescription)
                    self.showAlert(error.localizedDescription, title: "Login Failed")
                }
            }
        }
    }



    // MARK: - Navigation
    private func navigateToHome() {
        // Replace with your real home screen
        print("Navigate to home")
    }

    // MARK: - Helpers
    private func showAlert(_ message: String,title: String? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension LoginViewController {

    private func googleLogin() {

        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first?.rootViewController }).first else { return }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { [weak self] signInResult, error in

            if let error = error {
                self?.showAlert(error.localizedDescription, title: "Google Login Failed")
                return
            }

            guard let result = signInResult else { return }

            // Extract Google tokens
            let idToken = result.user.idToken?.tokenString            // Optional
            let accessToken = result.user.accessToken.tokenString     // Non-optional (String)

            guard let idToken = idToken else {
                self?.showAlert("Unable to fetch Google ID Token", title: "Google Auth Error")
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: accessToken        // already non-optional
            )

            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    self?.showAlert(error.localizedDescription, title: "Firebase Auth Failed")
                    return
                }

                guard let firebaseUser = authResult?.user else { return }

                FirebaseAuthHelper.shared.saveGoogleUserToFirestore(user: firebaseUser) { success in
                    self?.showAlert("Welcome \(firebaseUser.email ?? "")", title: "Login Success")
                }
            }
        }
    }
    
    private func startAppleLogin() {
        let nonce = randomNonceString()
        currentNonce = nonce

        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]
        request.nonce = sha256(nonce)

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }



    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remaining = length

        while remaining > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let error = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if error != errSecSuccess { fatalError("Unable to generate nonce. \(error)") }
                return random
            }

            randoms.forEach { random in
                if remaining == 0 { return }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remaining -= 1
                }
            }
        }
        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }


}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let nonce = currentNonce,
            let tokenData = appleIDCredential.identityToken,
            let idTokenString = String(data: tokenData, encoding: .utf8)
        else {
            showAlert("Apple Sign-in Failed", title: "Error")
            return
        }

        // Firebase Apple credential (LATEST API)
        let credential = OAuthProvider.appleCredential(
            withIDToken: idTokenString,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName
        )

        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            if let error = error {
                self?.showAlert(error.localizedDescription, title: "Firebase Auth Failed")
                return
            }

            guard let firebaseUser = authResult?.user else { return }

            FirebaseAuthHelper.shared.saveGoogleUserToFirestore(user: firebaseUser) { success in
                self?.showAlert("Welcome \(firebaseUser.email ?? "")", title: "Apple Login Success")
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        showAlert(error.localizedDescription, title: "Apple Login Failed")
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    
    private func navigateToAdminScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultController = storyboard.instantiateViewController(withIdentifier: "AdminPanelViewController") as? AdminPanelViewController

        resultController?.modalPresentationStyle = .fullScreen
        self.present(resultController ?? ViewController() , animated: true, completion: nil)
    }

    
}

