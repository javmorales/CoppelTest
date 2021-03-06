//
//  LoginTextFieldView.swift
//  CoppelTest
//
//  Created by Javier Morales on 26/10/21.
//

import UIKit

protocol LoginViewProtocol {
    func loginComplete(result: LoginStatus)
    func promptAlert(title: String?, message: String?)
    func updateLoadingStatus(status: LoadingStatus)
}

class LoginTextFieldView: UIView {
    
    @UsesAutoLayout
    var loginStack = UIStackView()
    
    @UsesAutoLayout
    var textfieldsStack = UIStackView()
    
    @UsesAutoLayout
    var loginBtn = UIButton()
    
    @UsesAutoLayout
    var emailTextfield = UITextField()
    
    @UsesAutoLayout
    var pwdTextfield = UITextField()
    
    @UsesAutoLayout
    var labelError =  UILabel()
    
    var viewModel = LoginViewModel()
    
    var delegate: LoginViewProtocol?
    
    enum TextFieldType {
        case email
        case password
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
        viewModel.delegate = self

        viewModel.loadingStatus.bind { [weak self] (loadingStatus) in
            switch loadingStatus {
            case .complete:
                self?.loginBtn.isEnabled = true
                self?.loginBtn.setTitle("Login", for: .normal)
            case .loading:
                self?.loginBtn.isEnabled = false
                self?.loginBtn.setTitle("Logining", for: .normal)
            }
        }
        
    }
    
    func setupViews() {
        // loginStack: vertical stackView including textfieldsStack + login button
        loginStack.axis = .vertical
        loginStack.distribution = .fillProportionally
        loginStack.spacing = 25
        addSubview(loginStack)
        NSLayoutConstraint.activate([
            loginStack.topAnchor.constraint(equalTo: self.topAnchor),
            loginStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            loginStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            loginStack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        // textfieldsStack:stackView including 2 textfields
        textfieldsStack.axis = .vertical
        textfieldsStack.distribution = .fillEqually
        textfieldsStack.spacing = 15
        loginStack.addArrangedSubview(textfieldsStack)
        NSLayoutConstraint.activate([
            textfieldsStack.heightAnchor.constraint(equalToConstant: 90),
            textfieldsStack.leadingAnchor.constraint(equalTo: loginStack.leadingAnchor),
            textfieldsStack.trailingAnchor.constraint(equalTo: loginStack.trailingAnchor)
        ])

        setupTextFields(textfieldType: .email, textfield: emailTextfield)
        setupTextFields(textfieldType: .password, textfield: pwdTextfield)
        
        textfieldsStack.addArrangedSubview(emailTextfield)
        textfieldsStack.addArrangedSubview(pwdTextfield)
        
        // Button
        loginBtn.setTitle("Login", for: UIControl.State.normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.addTarget(self, action: #selector(loginButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        loginStack.addArrangedSubview(loginBtn)
        NSLayoutConstraint.activate([
            loginBtn.heightAnchor.constraint(equalToConstant: 45),
            loginBtn.leadingAnchor.constraint(equalTo: loginStack.leadingAnchor),
            loginBtn.trailingAnchor.constraint(equalTo: loginStack.trailingAnchor)
        ])
        loginBtn.backgroundColor = UIColor.systemGreen
        
        
        
        
    }
    
    private func setupTextFields(textfieldType: TextFieldType, textfield: UITextField) {
        
        textfield.delegate = self
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.clearButtonMode = .always
        textfield.addBottomBorder()
        
        switch textfieldType {
        case .email:
            textfield.keyboardType = .emailAddress
            textfield.returnKeyType = .next
            textfield.attributedPlaceholder = NSAttributedString(string: "mobile number / email address", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            textfield.accessibilityIdentifier = "loginEmailTextfield"
        case .password:
            textfield.isSecureTextEntry = true
            textfield.returnKeyType = .go
            textfield.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            textfield.accessibilityIdentifier = "loginPasswordTextfield"
        }
    }
    

    @objc private func loginButtonPressed(_ sender: UIButton) {
        
        self.endEditing(false)
        viewModel.loginRequest(email: emailTextfield.text, password: pwdTextfield.text)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginTextFieldView: LoginViewModelProtocol {
    func updateLoadingStatus(status: LoadingStatus) {
        delegate?.updateLoadingStatus(status: status)
    }
    func loginComplete(result: LoginStatus) {
        delegate?.loginComplete(result: result)
    }
    func promptAlert(title: String?, message: String?) {
        delegate?.promptAlert(title: title, message: message)
    }
}

extension LoginTextFieldView: UITextFieldDelegate {
    @objc func textFieldContentDidChange() {
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextfield {
            pwdTextfield.becomeFirstResponder()
        } else if textField == pwdTextfield {
            viewModel.loginRequest(email: emailTextfield.text, password: pwdTextfield.text)
            textField.resignFirstResponder()
        } else {
           // should never happen as only 2 textfields
        }

       
        return false
    }
    
}
