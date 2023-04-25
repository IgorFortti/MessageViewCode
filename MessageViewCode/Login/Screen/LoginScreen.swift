//
//  LoginScreen.swift
//  AppViewCodeCurso
//
//  Created by Igor Fortti on 02/03/23.
//

import UIKit

protocol LoginScreenProtocol: AnyObject {
    func registerButtonTapped()
    func loginButtonTapped()
}

class LoginScreen: UIView {
    
    weak private var delegate: LoginScreenProtocol?
    
    lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal)
        return imageView
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.clipsToBounds = true
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.placeholder = "Digite seu e-mail"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = false
        textField.text = "igor@igor.com"
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.clipsToBounds = true
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.placeholder = "Digite sua senha"
        textField.keyboardType = .default
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.text = "123456"
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 53/255, green: 178/255, blue: 151/255, alpha: 1.0)
        button.setTitle("Entrar", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Não tem uma conta? Cadastre-se", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 50/255, green: 120/255, blue: 110/255, alpha: 1.0)
        validateTextFields()
        addViews()
        setupLoginLabelConstraint()
        setupLogoImageViewConstraint()
        setupEmailTextFieldConstraint()
        setupPasswordTextFieldConstraint()
        setupLoginButtonConstraint()
        setupRegisterButtonConstraint()
    }
    
    @objc func loginButtonTapped() {
        delegate?.loginButtonTapped()
    }
    
    @objc func registerButtonTapped() {
        delegate?.registerButtonTapped()
    }
    
    public func delegate(delegate: LoginScreenProtocol?) {
        self.delegate = delegate
    }
    
    public func textFieldDelegate(delegate: UITextFieldDelegate) {
        emailTextField.delegate = delegate
        passwordTextField.delegate = delegate
    }
    
    public func validateTextFields() {
        let email = getEmail()
        let password = getPassword()
        if !email.isEmpty && !password.isEmpty {
            enableButton(true)
        } else {
            enableButton(false)
        }
    }
    
    public func getEmail() -> String {
        let email = emailTextField.text ?? ""
        return email
    }
    
    public func getPassword() -> String {
        let password = passwordTextField.text ?? ""
        return password
    }
    
    private func enableButton(_ enable: Bool) {
        if enable == true {
            loginButton.isEnabled = true
            loginButton.setTitleColor(.white, for: .normal)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor(red: 53/255, green: 178/255, blue: 151/255, alpha: 0.4)
            loginButton.setTitleColor(.white.withAlphaComponent(0.4), for: .normal)
        }
    }
    
    private func addViews() {
        addSubview(loginLabel)
        addSubview(logoImageView)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(registerButton)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLoginLabelConstraint() {
        loginLabel.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalTo(snp.centerX)
        }
    }
    
    private func setupLogoImageViewConstraint() {
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(loginLabel.snp.bottom).offset(20)
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
    }
    
    private func setupEmailTextFieldConstraint() {
        emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom).offset(40)
            make.leading.equalTo(snp.leading).offset(20)
            make.trailing.equalTo(snp.trailing).inset(20)
            make.height.equalTo(40)
        }
    }
    
    private func setupPasswordTextFieldConstraint() {
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.leading.equalTo(emailTextField.snp.leading)
            make.trailing.equalTo(emailTextField.snp.trailing)
            make.height.equalTo(emailTextField.snp.height)
        }
    }
    
    private func setupLoginButtonConstraint() {
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.leading.equalTo(emailTextField.snp.leading)
            make.trailing.equalTo(emailTextField.snp.trailing)
            make.height.equalTo(emailTextField.snp.height)
        }
    }
    
    private func setupRegisterButtonConstraint() {
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(5)
            make.leading.equalTo(emailTextField.snp.leading)
            make.trailing.equalTo(emailTextField.snp.trailing)
            make.height.equalTo(emailTextField.snp.height)
        }
    }
}
