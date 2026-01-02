import UIKit

private func roundedFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
    let base = UIFont.systemFont(ofSize: size, weight: weight)
    if let descriptor = base.fontDescriptor.withDesign(.rounded) {
        return UIFont(descriptor: descriptor, size: size)
    }
    return base
}

// MARK: - Emergency Donation Screen (UIKit)
final class EmergencyDonationViewController: UIViewController {
    // Colors from screenshot approximation
    private let topPurple = UIColor(red: 0.63, green: 0.52, blue: 0.98, alpha: 1.0) // light purple
    private let bottomPurple = UIColor(red: 0.74, green: 0.57, blue: 0.99, alpha: 1.0) // slightly deeper
    private let accentPurple = UIColor(red: 0.45, green: 0.20, blue: 0.87, alpha: 1.0) // primary action
    private let textPrimary = UIColor.black
    private let textSecondary = UIColor.darkGray

    // UI Elements
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let headerView = UIView()
    private let headerTitle = UILabel()

    private let supporterCard = UIView()
    private let supporterIcon = UIImageView()
    private let supporterName = UILabel()
    private let supporterEmail = UILabel()
    private let supporterChevron = UIImageView()

    private let donationAmountTitle = UILabel()
    private let amountContainer = UIView()
    private let amountField = UITextField()
    private let currencyBadge = UILabel()

    private let dateTitle = UILabel()
    private let dateButton = UIButton(type: .system)
    private let hiddenDatePicker = UIDatePicker()

    private let paymentTitle = UILabel()
    private let paymentStack = UIStackView()
    private let creditButton = UIButton(type: .system)
    private let paypalButton = UIButton(type: .system)

    private let donateButton = UIButton(type: .system)

    private var selectedPayment: String = "Credit Card" { didSet { updatePaymentSelection() } }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let logoImageView = UIImageView(image: UIImage(named: "Logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        logoImageView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoImageView)
        
        setupLayout()
        setupActions()
        updatePaymentSelection()
        updateDateLabel(with: Date())
    }

    // MARK: Layout
    private func setupLayout() {
        // Scroll container
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Content stack
        contentStack.axis = .vertical
        contentStack.spacing = 24
        contentStack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 24, right: 20)
        contentStack.isLayoutMarginsRelativeArrangement = true
        scrollView.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        // Header with purple background and rounded bottom-right corner
        headerView.backgroundColor = .clear
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let headerContainer = UIView()
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.clipsToBounds = true
        headerContainer.layer.cornerRadius = 28
        headerContainer.layer.maskedCorners = [.layerMaxXMaxYCorner]
        headerContainer.backgroundColor = .clear

        // Gradient layer
        let gradient = CAGradientLayer()
        gradient.colors = [topPurple.cgColor, bottomPurple.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        headerContainer.layer.insertSublayer(gradient, at: 0)
        
        // Add subtle drop shadow to header container
        headerContainer.layer.shadowColor = UIColor.black.withAlphaComponent(0.06).cgColor
        headerContainer.layer.shadowOpacity = 1
        headerContainer.layer.shadowRadius = 10
        headerContainer.layer.shadowOffset = CGSize(width: 0, height: 6)
        
        // Add thin white stroke overlay
        let strokeLayer = CAShapeLayer()
        strokeLayer.path = UIBezierPath(roundedRect: headerContainer.bounds, cornerRadius: 28).cgPath
        strokeLayer.fillColor = UIColor.clear.cgColor
        strokeLayer.strokeColor = UIColor.white.withAlphaComponent(0.15).cgColor
        strokeLayer.lineWidth = 1
        headerContainer.layer.addSublayer(strokeLayer)

        let headerStack = UIStackView()
        headerStack.axis = .vertical
        headerStack.alignment = .leading
        headerStack.spacing = 8
        headerStack.isLayoutMarginsRelativeArrangement = true
        headerStack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 24, right: 20)

        headerTitle.text = "Emergency Donation"
        headerTitle.font = roundedFont(ofSize: 24, weight: .semibold)
        headerTitle.textColor = .white
        headerStack.addArrangedSubview(headerTitle)

        headerContainer.addSubview(headerStack)
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerStack.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            headerStack.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            headerStack.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor)
        ])

        headerContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        headerView.addSubview(headerContainer)
        NSLayoutConstraint.activate([
            headerContainer.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headerContainer.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerContainer.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])

        // Add header to content
        contentStack.addArrangedSubview(headerView)
        headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        // Supporter card
        supporterCard.backgroundColor = .white
        supporterCard.layer.cornerRadius = 16
        supporterCard.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        supporterCard.layer.shadowOpacity = 1
        supporterCard.layer.shadowRadius = 8
        supporterCard.layer.shadowOffset = CGSize(width: 0, height: 4)

        let supporterH = UIStackView()
        supporterH.axis = .horizontal
        supporterH.alignment = .center
        supporterH.spacing = 12

        supporterIcon.image = UIImage(systemName: "person.circle.fill")
        supporterIcon.tintColor = accentPurple
        supporterIcon.contentMode = .scaleAspectFit
        supporterIcon.setContentHuggingPriority(.required, for: .horizontal)
        supporterIcon.translatesAutoresizingMaskIntoConstraints = false
        supporterIcon.widthAnchor.constraint(equalToConstant: 44).isActive = true
        supporterIcon.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let supporterTextStack = UIStackView()
        supporterTextStack.axis = .vertical
        supporterTextStack.spacing = 2
        supporterName.text = "Mohamed Ahmed"
        supporterName.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        supporterEmail.text = "mohamedahmed@gmail.com"
        supporterEmail.font = UIFont.systemFont(ofSize: 14)
        supporterEmail.textColor = textSecondary
        supporterTextStack.addArrangedSubview(supporterName)
        supporterTextStack.addArrangedSubview(supporterEmail)

        supporterChevron.image = UIImage(systemName: "chevron.right")
        supporterChevron.tintColor = .systemGray2
        supporterChevron.setContentHuggingPriority(.required, for: .horizontal)

        supporterH.addArrangedSubview(supporterIcon)
        supporterH.addArrangedSubview(supporterTextStack)
        supporterH.addArrangedSubview(supporterChevron)

        let supporterContainer = UIView()
        supporterContainer.addSubview(supporterH)
        supporterH.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            supporterH.leadingAnchor.constraint(equalTo: supporterContainer.leadingAnchor, constant: 16),
            supporterH.trailingAnchor.constraint(equalTo: supporterContainer.trailingAnchor, constant: -16),
            supporterH.topAnchor.constraint(equalTo: supporterContainer.topAnchor, constant: 16),
            supporterH.bottomAnchor.constraint(equalTo: supporterContainer.bottomAnchor, constant: -16)
        ])
        supporterCard.addSubview(supporterContainer)
        supporterContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            supporterContainer.leadingAnchor.constraint(equalTo: supporterCard.leadingAnchor),
            supporterContainer.trailingAnchor.constraint(equalTo: supporterCard.trailingAnchor),
            supporterContainer.topAnchor.constraint(equalTo: supporterCard.topAnchor),
            supporterContainer.bottomAnchor.constraint(equalTo: supporterCard.bottomAnchor)
        ])
        contentStack.addArrangedSubview(supporterCard)

        // Donation Amount
        donationAmountTitle.text = "Donation Amount"
        donationAmountTitle.font = roundedFont(ofSize: 18, weight: .semibold)
        contentStack.addArrangedSubview(donationAmountTitle)

        amountContainer.backgroundColor = UIColor(white: 0.95, alpha: 1)
        amountContainer.layer.cornerRadius = 8
        amountContainer.layer.borderWidth = 1
        amountContainer.layer.borderColor = UIColor(white: 0.85, alpha: 1).cgColor
        let amountH = UIStackView()
        amountH.axis = .horizontal
        amountH.alignment = .center
        amountH.spacing = 8

        amountField.placeholder = "BHD 25"
        amountField.keyboardType = .decimalPad
        amountField.borderStyle = .none
        amountField.backgroundColor = .clear
        amountField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

        currencyBadge.text = "BHD"
        currencyBadge.textAlignment = .center
        currencyBadge.textColor = .black
        currencyBadge.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        currencyBadge.layer.cornerRadius = 8
        currencyBadge.layer.masksToBounds = true
        currencyBadge.widthAnchor.constraint(equalToConstant: 56).isActive = true
        currencyBadge.heightAnchor.constraint(equalToConstant: 36).isActive = true

        amountH.addArrangedSubview(amountField)
        amountH.addArrangedSubview(currencyBadge)

        let amountInset = UIView()
        amountInset.addSubview(amountH)
        amountH.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountH.leadingAnchor.constraint(equalTo: amountInset.leadingAnchor, constant: 12),
            amountH.trailingAnchor.constraint(equalTo: amountInset.trailingAnchor, constant: -12),
            amountH.topAnchor.constraint(equalTo: amountInset.topAnchor, constant: 8),
            amountH.bottomAnchor.constraint(equalTo: amountInset.bottomAnchor, constant: -8)
        ])

        amountContainer.addSubview(amountInset)
        amountInset.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountInset.leadingAnchor.constraint(equalTo: amountContainer.leadingAnchor),
            amountInset.trailingAnchor.constraint(equalTo: amountContainer.trailingAnchor),
            amountInset.topAnchor.constraint(equalTo: amountContainer.topAnchor),
            amountInset.bottomAnchor.constraint(equalTo: amountContainer.bottomAnchor)
        ])
        contentStack.addArrangedSubview(amountContainer)

        // Date of Donation
        dateTitle.text = "Date of Donation"
        dateTitle.font = roundedFont(ofSize: 18, weight: .semibold)
        contentStack.addArrangedSubview(dateTitle)

        var dateConfig = UIButton.Configuration.plain()
        dateConfig.baseForegroundColor = .label
        dateConfig.baseBackgroundColor = UIColor(white: 0.95, alpha: 1)
        dateConfig.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        dateConfig.titleAlignment = .leading
        // Keep rounded look similar to layer.cornerRadius = 8
        dateConfig.cornerStyle = .fixed
        // Apply configuration
        dateButton.configuration = dateConfig
        // Apply border via layer since configuration doesn't provide border directly
        dateButton.layer.cornerRadius = 8
        dateButton.layer.masksToBounds = true
        dateButton.layer.borderWidth = 1
        dateButton.layer.borderColor = UIColor(white: 0.85, alpha: 1).cgColor
        contentStack.addArrangedSubview(dateButton)

        hiddenDatePicker.datePickerMode = .date
        hiddenDatePicker.preferredDatePickerStyle = .wheels
        hiddenDatePicker.minimumDate = Date()
        hiddenDatePicker.isHidden = true
        contentStack.addArrangedSubview(hiddenDatePicker)

        // Payment Method
        paymentTitle.text = "Payment Method"
        paymentTitle.font = roundedFont(ofSize: 18, weight: .semibold)
        contentStack.addArrangedSubview(paymentTitle)

        paymentStack.axis = .horizontal
        paymentStack.spacing = 12
        paymentStack.distribution = .fillEqually

        stylePill(creditButton, title: "Credit Card")
        stylePill(paypalButton, title: "Paypal")

        paymentStack.addArrangedSubview(creditButton)
        paymentStack.addArrangedSubview(paypalButton)
        contentStack.addArrangedSubview(paymentStack)

        // Spacer view to push donate button down
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 12).isActive = true
        contentStack.addArrangedSubview(spacer)

        // Donate Button
        var donateConfig = UIButton.Configuration.filled()
        donateConfig.title = "Donate Now"
        donateConfig.baseForegroundColor = .white
        donateConfig.baseBackgroundColor = accentPurple
        donateConfig.cornerStyle = .fixed
        donateConfig.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        donateButton.configuration = donateConfig
        donateButton.titleLabel?.font = roundedFont(ofSize: 18, weight: .semibold)
        donateButton.layer.cornerRadius = 14
        donateButton.layer.masksToBounds = true
        contentStack.addArrangedSubview(donateButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Ensure any gradient layers fill their containers after Auto Layout
        // Find the header container and resize its first sublayer (the gradient)
        if let headerContainer = headerView.subviews.first,
           let gradient = headerContainer.layer.sublayers?.first as? CAGradientLayer {
            gradient.frame = headerContainer.bounds
        }
        if let headerContainer = headerView.subviews.first,
           let strokeLayer = headerContainer.layer.sublayers?.last as? CAShapeLayer {
            strokeLayer.path = UIBezierPath(roundedRect: headerContainer.bounds, cornerRadius: 28).cgPath
        }
    }

    private func stylePill(_ button: UIButton, title: String) {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.baseForegroundColor = .black
        // Use configuration contentInsets instead of deprecated contentEdgeInsets when using UIButton.Configuration
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)
        button.configuration = config
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        button.backgroundColor = .white
    }

    private func updatePaymentSelection() {
        func apply(_ button: UIButton, selected: Bool) {
            if selected {
                button.backgroundColor = accentPurple.withAlphaComponent(0.12)
                button.layer.borderColor = accentPurple.cgColor
                button.setTitleColor(accentPurple, for: .normal)
            } else {
                button.backgroundColor = .white
                button.layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
                button.setTitleColor(.black, for: .normal)
            }
        }
        apply(creditButton, selected: selectedPayment == "Credit Card")
        apply(paypalButton, selected: selectedPayment == "Paypal")
    }

    private func setupActions() {
        creditButton.addTarget(self, action: #selector(selectCredit), for: .touchUpInside)
        paypalButton.addTarget(self, action: #selector(selectPaypal), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(toggleDatePicker), for: .touchUpInside)
        hiddenDatePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        donateButton.addTarget(self, action: #selector(donateNow), for: .touchUpInside)
    }

    @objc private func selectCredit() { selectedPayment = "Credit Card" }
    @objc private func selectPaypal() { selectedPayment = "Paypal" }

    @objc private func toggleDatePicker() {
        hiddenDatePicker.isHidden.toggle()
    }

    @objc private func dateChanged() {
        updateDateLabel(with: hiddenDatePicker.date)
    }

    private func updateDateLabel(with date: Date) {
        let f = DateFormatter()
        f.dateStyle = .long
        dateButton.setTitle(f.string(from: date), for: .normal)
    }

    @objc private func donateNow() {
        view.endEditing(true)
        let amountText = amountField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let cleaned = amountText.components(separatedBy: CharacterSet(charactersIn: "0123456789.").inverted).joined()
        let amount = Double(cleaned)
        guard let validAmount = amount, validAmount > 0 else {
            showAlert(title: "Invalid Amount", message: "Please enter a valid donation amount.")
            return
        }
        let f = DateFormatter()
        f.dateStyle = .long
        let dateString = dateButton.title(for: .normal) ?? f.string(from: Date())
        _ = "You are donating BHD \(String(format: "%.2f", validAmount)) on \(dateString) via \(selectedPayment)."
        // Route to the appropriate payment page
        if selectedPayment == "Credit Card" {
            let vc = CreditCardPaymentViewController(amount: validAmount, dateString: dateString)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = PayPalPaymentViewController(amount: validAmount, dateString: dateString)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

}

// MARK: - Payment Pages (Placeholders)
final class CreditCardPaymentViewController: UIViewController {
    private let amount: Double
    private let dateString: String

    init(amount: Double, dateString: String) {
        self.amount = amount
        self.dateString = dateString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Credit Card"
        
        let logoImageView = UIImageView(image: UIImage(named: "Logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        logoImageView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoImageView)

        let titleLabel = UILabel()
        titleLabel.text = "Credit Card Payment"
        titleLabel.font = roundedFont(ofSize: 22, weight: .semibold)
        titleLabel.textAlignment = .left

        let summaryHeader = UILabel()
        summaryHeader.text = "Order Summary"
        summaryHeader.font = roundedFont(ofSize: 16, weight: .semibold)

        let details = UILabel()
        details.numberOfLines = 0
        details.textColor = .secondaryLabel
        details.text = "Amount: BHD \(String(format: "%.2f", amount))\nDate: \(dateString)"

        // Summary card container
        let summaryCard = UIView()
        summaryCard.backgroundColor = .white
        summaryCard.layer.cornerRadius = 12
        summaryCard.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        summaryCard.layer.shadowOpacity = 1
        summaryCard.layer.shadowRadius = 6
        summaryCard.layer.shadowOffset = CGSize(width: 0, height: 3)

        let summaryContent = UIStackView(arrangedSubviews: [details])
        summaryContent.axis = .vertical
        summaryContent.spacing = 8
        summaryContent.isLayoutMarginsRelativeArrangement = true
        summaryContent.layoutMargins = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        summaryContent.translatesAutoresizingMaskIntoConstraints = false
        summaryCard.addSubview(summaryContent)
        NSLayoutConstraint.activate([
            summaryContent.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor),
            summaryContent.trailingAnchor.constraint(equalTo: summaryCard.trailingAnchor),
            summaryContent.topAnchor.constraint(equalTo: summaryCard.topAnchor),
            summaryContent.bottomAnchor.constraint(equalTo: summaryCard.bottomAnchor)
        ])

        let actionsHeader = UILabel()
        actionsHeader.text = "Payment Options"
        actionsHeader.font = roundedFont(ofSize: 16, weight: .semibold)

        let payCardButton = UIButton(type: .system)
        var cardConfig = UIButton.Configuration.filled()
        cardConfig.title = "Pay with Card"
        cardConfig.baseBackgroundColor = UIColor(red: 0.45, green: 0.20, blue: 0.87, alpha: 1.0)
        cardConfig.baseForegroundColor = .white
        cardConfig.cornerStyle = .fixed
        cardConfig.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        payCardButton.configuration = cardConfig
        payCardButton.titleLabel?.font = roundedFont(ofSize: 18, weight: .semibold)
        payCardButton.addTarget(self, action: #selector(returnToRoot), for: .touchUpInside)

        let applePayButton = UIButton(type: .system)
        var appleConfig = UIButton.Configuration.gray()
        appleConfig.title = " Pay"
        appleConfig.baseForegroundColor = .label
        appleConfig.cornerStyle = .fixed
        appleConfig.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        applePayButton.configuration = appleConfig
        applePayButton.titleLabel?.font = roundedFont(ofSize: 18, weight: .semibold)
        applePayButton.addTarget(self, action: #selector(returnToRoot), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [titleLabel, summaryHeader, summaryCard, actionsHeader, payCardButton, applePayButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false

        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        scroll.addSubview(stack)

        NSLayoutConstraint.activate([
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -20),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -40)
        ])
    }

    @objc private func returnToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}

final class PayPalPaymentViewController: UIViewController {
    private let amount: Double
    private let dateString: String

    init(amount: Double, dateString: String) {
        self.amount = amount
        self.dateString = dateString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "PayPal"
        
        let logoImageView = UIImageView(image: UIImage(named: "Logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        logoImageView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoImageView)

        let titleLabel = UILabel()
        titleLabel.text = "PayPal Payment"
        titleLabel.font = roundedFont(ofSize: 22, weight: .semibold)
        titleLabel.textAlignment = .left

        let summaryHeader = UILabel()
        summaryHeader.text = "Order Summary"
        summaryHeader.font = roundedFont(ofSize: 16, weight: .semibold)

        let details = UILabel()
        details.numberOfLines = 0
        details.textColor = .secondaryLabel
        details.text = "Amount: BHD \(String(format: "%.2f", amount))\nDate: \(dateString)"

        // Summary card container
        let summaryCard = UIView()
        summaryCard.backgroundColor = .white
        summaryCard.layer.cornerRadius = 12
        summaryCard.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        summaryCard.layer.shadowOpacity = 1
        summaryCard.layer.shadowRadius = 6
        summaryCard.layer.shadowOffset = CGSize(width: 0, height: 3)

        let summaryContent = UIStackView(arrangedSubviews: [details])
        summaryContent.axis = .vertical
        summaryContent.spacing = 8
        summaryContent.isLayoutMarginsRelativeArrangement = true
        summaryContent.layoutMargins = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        summaryContent.translatesAutoresizingMaskIntoConstraints = false
        summaryCard.addSubview(summaryContent)
        NSLayoutConstraint.activate([
            summaryContent.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor),
            summaryContent.trailingAnchor.constraint(equalTo: summaryCard.trailingAnchor),
            summaryContent.topAnchor.constraint(equalTo: summaryCard.topAnchor),
            summaryContent.bottomAnchor.constraint(equalTo: summaryCard.bottomAnchor)
        ])

        let actionsHeader = UILabel()
        actionsHeader.text = "Payment Options"
        actionsHeader.font = roundedFont(ofSize: 16, weight: .semibold)

        let payPalButton = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = "Pay with PayPal"
        config.baseBackgroundColor = UIColor(red: 0.45, green: 0.20, blue: 0.87, alpha: 1.0)
        config.baseForegroundColor = .white
        config.cornerStyle = .fixed
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        payPalButton.configuration = config
        payPalButton.titleLabel?.font = roundedFont(ofSize: 18, weight: .semibold)
        payPalButton.addTarget(self, action: #selector(returnToRoot), for: .touchUpInside)

        let creditCardButton = UIButton(type: .system)
        var ccConfig = UIButton.Configuration.filled()
        ccConfig.title = "Pay with Card"
        ccConfig.baseBackgroundColor = UIColor(red: 0.45, green: 0.20, blue: 0.87, alpha: 1.0)
        ccConfig.baseForegroundColor = .white
        ccConfig.cornerStyle = .fixed
        ccConfig.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        creditCardButton.configuration = ccConfig
        creditCardButton.titleLabel?.font = roundedFont(ofSize: 18, weight: .semibold)
        creditCardButton.addTarget(self, action: #selector(returnToRoot), for: .touchUpInside)

        let applePayButton = UIButton(type: .system)
        var apConfig = UIButton.Configuration.gray()
        apConfig.title = " Pay"
        apConfig.baseForegroundColor = .label
        apConfig.cornerStyle = .fixed
        apConfig.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        applePayButton.configuration = apConfig
        applePayButton.titleLabel?.font = roundedFont(ofSize: 18, weight: .semibold)
        applePayButton.addTarget(self, action: #selector(returnToRoot), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [titleLabel, summaryHeader, summaryCard, actionsHeader, payPalButton, creditCardButton, applePayButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false

        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        scroll.addSubview(stack)

        NSLayoutConstraint.activate([
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -20),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -40)
        ])
    }
    
    @objc private func returnToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}

