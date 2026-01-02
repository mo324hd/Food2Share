import UIKit
#if canImport(SwiftUI)
import SwiftUI
#endif

final class HomeViewController: UIViewController {
    private let accentColor = UIColor(red: 0.45, green: 0.20, blue: 0.87, alpha: 1.0)

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let headerView: UIView = {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.layer.masksToBounds = true
        return header
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "Logo"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let headerGradientLayer = CAGradientLayer()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Main Page"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emergencyDonationButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = accentColor
        config.baseForegroundColor = .white
        config.cornerStyle = .fixed
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Emergency Donation", for: .normal)
        button.addTarget(self, action: #selector(emergencyDonationTapped), for: .touchUpInside)
        return button
    }()

    private lazy var recurringDonationButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = accentColor
        config.baseForegroundColor = .white
        config.cornerStyle = .fixed
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Recurring Donation", for: .normal)
        button.addTarget(self, action: #selector(recurringDonationTapped), for: .touchUpInside)
        return button
    }()

    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupScrollView()
        setupHeaderView()
        setupButtonsStack()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Keep nav bar hidden on the main page for themed appearance
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupHeaderView() {
        contentView.addSubview(headerView)
        headerView.layer.addSublayer(headerGradientLayer)
        headerView.addSubview(titleLabel)
        headerView.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 76),

            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12),

            logoImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            logoImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 44),
            logoImageView.heightAnchor.constraint(equalToConstant: 44)
        ])
        titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: logoImageView.leadingAnchor, constant: -12).isActive = true

        headerGradientLayer.colors = [
            UIColor(red: 0.45, green: 0.20, blue: 0.87, alpha: 1.0).cgColor,
            UIColor(red: 0.45, green: 0.20, blue: 0.87, alpha: 0.9).cgColor
        ]
        headerGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        headerGradientLayer.endPoint = CGPoint(x: 1, y: 1)

        // Rounded curved bottom-right corner mask
        let path = UIBezierPath()
        let cornerRadius: CGFloat = 40
        let bounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: 76)
        path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX - cornerRadius, y: bounds.minY))
        path.addQuadCurve(to: CGPoint(x: bounds.maxX, y: bounds.minY + cornerRadius),
                          controlPoint: CGPoint(x: bounds.maxX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        path.close()

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        headerView.layer.mask = maskLayer
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerGradientLayer.frame = headerView.bounds

        let cornerRadius: CGFloat = 40
        let bounds = headerView.bounds
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX - cornerRadius, y: bounds.minY))
        path.addQuadCurve(to: CGPoint(x: bounds.maxX, y: bounds.minY + cornerRadius),
                          controlPoint: CGPoint(x: bounds.maxX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        path.close()

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        headerView.layer.mask = maskLayer
    }

    private func setupButtonsStack() {
        contentView.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(emergencyDonationButton)
        buttonsStackView.addArrangedSubview(recurringDonationButton)

        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            buttonsStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])

        emergencyDonationButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        recurringDonationButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    @objc private func emergencyDonationTapped() {
        let emergencyVC = EmergencyDonationViewController()
        // Show nav bar for pushed screens if it was hidden on the root
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController(emergencyVC, animated: true)
    }

    @objc private func recurringDonationTapped() {
        #if canImport(SwiftUI)
        let store = SchedulesStore.shared
        let schedulesHomeView = SchedulesHomeView().environmentObject(store)
        let hostingController = UIHostingController(rootView: schedulesHomeView)
        // Show nav bar so back button appears in SwiftUI view
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController(hostingController, animated: true)
        #endif
    }
}

