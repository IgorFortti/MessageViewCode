//
//  RegisterScreen.swift
//  AppViewCodeCurso
//
//  Created by Igor Fortti on 02/03/23.
//

import UIKit

protocol RegisterScreenProtocol: AnyObject {
    func backButtonTapped()
    func registerButtonTapped()
}

class RegisterScreen: UIView {
    
    weak private var delegate: RegisterScreenProtocol?
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "usuario")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .green
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.clipsToBounds = true
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.placeholder = "Digite seu nome"
        textField.keyboardType = .default
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = false
        return textField
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
        return textField
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 53/255, green: 178/255, blue: 151/255, alpha: 1.0)
        button.setTitle("Registrar", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func registerButtonTapped() {
        delegate?.registerButtonTapped()
    }
    
    @objc func backButtonTapped() {
        delegate?.backButtonTapped()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 50/255, green: 120/255, blue: 110/255, alpha: 1.0)
        validateTextFields()
        addViews()
        setupLogoImageViewConstraint()
        setupBackButtonConstraint()
        setupNameTextFieldConstraint()
        setupEmailTextFieldConstraint()
        setupPasswordTextFieldConstraint()
        setupRegisterButtonConstraint()
    }
    
    public func delegate(delegate: RegisterScreenProtocol?) {
        self.delegate = delegate
    }
    
    public func textFieldDelegate(delegate: UITextFieldDelegate) {
        nameTextField.delegate = delegate
        emailTextField.delegate = delegate
        passwordTextField.delegate = delegate
    }
    
    public func validateTextFields() {
        let name = getName()
        let email = getEmail()
        let password = getPassword()
        if !name.isEmpty && !email.isEmpty && !password.isEmpty {
            enableButton(true)
        } else {
            enableButton(false)
        }
    }
    
    public func getName() -> String {
        return nameTextField.text ?? ""
    }
    
    public func getEmail() -> String {
        return emailTextField.text ?? ""
    }
    
    public func getPassword() -> String {
        return passwordTextField.text ?? ""
    }
    
    private func enableButton(_ enable: Bool) {
        if enable == true {
            registerButton.isEnabled = true
            registerButton.setTitleColor(.white, for: .normal)
        } else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = UIColor(red: 53/255, green: 178/255, blue: 151/255, alpha: 0.4)
            registerButton.setTitleColor(.white.withAlphaComponent(0.4), for: .normal)
        }
    }
    
    private func addViews() {
        addSubview(logoImageView)
        addSubview(nameTextField)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(registerButton)
        addSubview(backButton)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLogoImageViewConstraint() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
    }
    
    private func setupBackButtonConstraint() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.top)
            make.leading.equalTo(snp.leading)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
    }
    
    private func setupNameTextFieldConstraint() {
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
            make.leading.equalTo(snp.leading).offset(20)
            make.trailing.equalTo(snp.trailing).inset(20)
            make.height.equalTo(40)
        }
    }
    
    private func setupEmailTextFieldConstraint() {
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.leading.equalTo(snp.leading).offset(20)
            make.trailing.equalTo(snp.trailing).inset(20)
            make.height.equalTo(40)
        }
    }
    
    private func setupPasswordTextFieldConstraint() {
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.leading.equalTo(emailTextField.snp.leading)
            make.trailing.equalTo(emailTextField.snp.trailing)
            make.height.equalTo(emailTextField.snp.height)
        }
    }
    
    private func setupRegisterButtonConstraint() {
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.leading.equalTo(emailTextField.snp.leading)
            make.trailing.equalTo(emailTextField.snp.trailing)
            make.height.equalTo(emailTextField.snp.height)
        }
    }
}
