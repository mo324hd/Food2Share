//
//  ViewController.swift
//  MainPage
//
//  Created by Ahmed Qamber on 02/01/2026.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    private let emergencyButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Emergency donation"
        config.baseBackgroundColor = UIColor(Color.brandAccent)
        config.baseForegroundColor = .white
        config.cornerStyle = .large
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let recurringButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Recurring donation"
        config.baseBackgroundColor = UIColor(red: 0.45, green: 0.20, blue: 0.87, alpha: 1.0)
        config.baseForegroundColor = .white
        config.cornerStyle = .large
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var stack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [emergencyButton, recurringButton])
        s.axis = .vertical
        s.alignment = .fill
        s.distribution = .fillEqually
        s.spacing = 16
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Donations"
        view.backgroundColor = .systemBackground

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            emergencyButton.heightAnchor.constraint(equalToConstant: 52),
            recurringButton.heightAnchor.constraint(equalToConstant: 52)
        ])

        emergencyButton.addTarget(self, action: #selector(openEmergencyDonation), for: .touchUpInside)
        recurringButton.addTarget(self, action: #selector(openRecurringDonation), for: .touchUpInside)
    }

    @objc private func openEmergencyDonation() {
        // Present EmergencyDonationView (SwiftUI) inside a UIHostingController
        let emergencyView = EmergencyDonationView()
        let hosting = UIHostingController(rootView: emergencyView)
        hosting.title = "Emergency"
        navigate(to: hosting)
    }

    @objc private func openRecurringDonation() {
        // Use existing SchedulesHomeView (SwiftUI)
        let schedulesView = SchedulesHomeView()
        let hosting = UIHostingController(rootView: schedulesView)
        hosting.title = "Schedules"
        navigate(to: hosting)
    }

    private func navigate(to viewController: UIViewController) {
        if let nav = navigationController {
            nav.pushViewController(viewController, animated: true)
        } else {
            // If we're not embedded in a navigation controller, present one
            let nav = UINavigationController(rootViewController: viewController)
            nav.modalPresentationStyle = .formSheet
            present(nav, animated: true)
        }
    }
}

