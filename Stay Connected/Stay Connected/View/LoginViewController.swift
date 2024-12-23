import UIKit
import Combine

class LoginViewController: UIViewController {

    private let viewModel = LoginViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let titleLabel = UILabel()
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordLabel = UILabel()
    private let forgotPasswordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let newToStayConnectedLabel = UILabel()
    private let signUpLabel = UILabel()
    private let loginButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginScreen()
        bindViewModel()
    }

    private func setupLoginScreen() {
        view.backgroundColor = .white

        // Configure Title Label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Log in"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        view.addSubview(titleLabel)

        // Configure Email Label
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = "Email"
        emailLabel.textColor = .gray
        emailLabel.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(emailLabel)

        // Configure Email TextField
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "Username"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.textContentType = .username
        emailTextField.autocapitalizationType = .none
        emailTextField.addTarget(self, action: #selector(emailChanged(_:)), for: .editingChanged)
        view.addSubview(emailTextField)

        // Configure Password Label
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.text = "Password"
        passwordLabel.textColor = .gray
        passwordLabel.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(passwordLabel)

        // Configure Forgot Password Label
        forgotPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordLabel.text = "Forgot Password?"
        forgotPasswordLabel.textColor = .black
        forgotPasswordLabel.font = UIFont.systemFont(ofSize: 14)
        forgotPasswordLabel.isUserInteractionEnabled = true
        forgotPasswordLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped)))
        view.addSubview(forgotPasswordLabel)

        // Configure Password TextField
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .password
        passwordTextField.addTarget(self, action: #selector(passwordChanged(_:)), for: .editingChanged)
        view.addSubview(passwordTextField)

        // Configure "New to StayConnected?" Label
        newToStayConnectedLabel.translatesAutoresizingMaskIntoConstraints = false
        newToStayConnectedLabel.text = "New To StayConnected?"
        newToStayConnectedLabel.textColor = .gray
        newToStayConnectedLabel.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(newToStayConnectedLabel)

        // Configure Sign Up Label
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.text = "Sign Up"
        signUpLabel.textColor = .black
        signUpLabel.font = UIFont.boldSystemFont(ofSize: 14)
        signUpLabel.isUserInteractionEnabled = true
        signUpLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpTapped)))
        view.addSubview(signUpLabel)

        // Configure Login Button
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = UIColor(red: 0.31, green: 0.33, blue: 0.64, alpha: 1.0)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginButton.layer.cornerRadius = 12
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        view.addSubview(loginButton)

        // Layout Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 106),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 33),

            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 33),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -33),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),

            forgotPasswordLabel.centerYAnchor.constraint(equalTo: passwordLabel.centerYAnchor),
            forgotPasswordLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),

            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            newToStayConnectedLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            newToStayConnectedLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),

            signUpLabel.centerYAnchor.constraint(equalTo: newToStayConnectedLabel.centerYAnchor),
            signUpLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),

            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            loginButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 59)
        ])
    }

    private func bindViewModel() {
        // Bind isLoginEnabled to loginButton
        viewModel.$isLoginEnabled
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)

        // Bind errorMessage to alert display
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                self?.showAlert(title: "Error", message: message)
            }
            .store(in: &cancellables)
    }

    @objc private func emailChanged(_ textField: UITextField) {
        viewModel.email = textField.text ?? ""
    }

    @objc private func passwordChanged(_ textField: UITextField) {
        viewModel.password = textField.text ?? ""
    }

    @objc private func loginTapped() {
        viewModel.login { [weak self] success in
            if success {
                let mainTabBarController = MainTabBarController() // Adjust as per your project
                self?.navigationController?.pushViewController(mainTabBarController, animated: true)
            } else {
                self?.showAlert(title: "Login Failed", message: self?.viewModel.errorMessage ?? "Unknown error")
            }
        }
    }

    @objc private func forgotPasswordTapped() {
        print("Forgot Password tapped")
        // Implement forgot password logic
    }

    @objc private func signUpTapped() {
        let signUpViewController = SignUpViewController()
        navigationController?.pushViewController(signUpViewController, animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
