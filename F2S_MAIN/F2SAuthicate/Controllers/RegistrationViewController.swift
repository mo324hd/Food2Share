//
//  RegistrationViewController.swift
//  F2SAuthicate
//
//  Created by abdulaziz on 18/12/2025.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore

final class RegistrationViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var fullNameTextField: UITextField!
    @IBOutlet private weak var mobileTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var locationTextField: UITextField!

    @IBOutlet private weak var donorButton: UIButton!
    @IBOutlet private weak var collectorButton: UIButton!
    @IBOutlet private weak var collectorLabel: UILabel!
    @IBOutlet private weak var donororLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Properties
    private var selectedUserType: UserType = .donor

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    // MARK: - UI Setup
    private func configureUI() {
        passwordTextField.isSecureTextEntry = true
        selectUserType(.donor)
        registerButton.layer.cornerRadius = 10
    }

    // MARK: - User Type Selection
    @IBAction private func donorTapped(_ sender: UIButton) {
        selectUserType(.donor)
    }

    @IBAction private func collectorTapped(_ sender: UIButton) {
        selectUserType(.collector)
    }

    private func selectUserType(_ type: UserType) {
        selectedUserType = type

        donorButton.isSelected = (type == .donor)
        collectorButton.isSelected = (type == .collector)

        donororLabel.alpha = type == .donor ? 1.0 : 0.0
        collectorLabel.alpha = type == .collector ? 1.0 : 0.0
  
    }

    @IBAction func LoginTapped(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
    
    // MARK: - Register
    @IBAction private func registerTapped(_ sender: UIButton) {
        registerUser()
    }

    private func registerUser() {

        guard
            let fullName = fullNameTextField.text?.trimmingCharacters(in: .whitespaces), !fullName.isEmpty,
            let phone = mobileTextField.text?.trimmingCharacters(in: .whitespaces), !phone.isEmpty,
            let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty,
            let password = passwordTextField.text, password.count >= 6,
            let location = locationTextField.text?.trimmingCharacters(in: .whitespaces), !location.isEmpty
        else {
            showAlert("Please fill all fields correctly.")
            return
        }

        FirebaseAuthHelper.shared.signUp(
            fullName: fullName,
            phone: phone,
            email: email,
            password: password,
            location: location,
            userType: selectedUserType
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case .success:
                    self.showAlert(
                        "Registration successful.\nYour account is pending verification."
                    ) {
                        self.dismiss(animated: true)
                    }

                case .failure(let error):
                    self.showAlert(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Helpers
    private func showAlert(_ message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: "Message",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
