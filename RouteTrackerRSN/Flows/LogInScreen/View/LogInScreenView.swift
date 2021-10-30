//
//  LogInScreenView.swift
//  RouteTrackerRSN
//
//  Created by Sergey Razgulyaev on 09.04.2021.
//

import UIKit

class LogInScreenView: UIView, UIComponentsMakeable {
    // MARK: - UI components
    private(set) lazy var scrollView: UIScrollView = {
        makeScrollView()
    }()
    
    private(set) lazy var logoLogInScreenImageView: UIImageView = {
        makeImageView(image: UIImage(systemName: "network")!,
                            tintColor: .rsnPurpleColor)
    }()
    
    private(set) lazy var logoLogInScreenLabel: UILabel = {
        makeLabel(text: "Let's log in",
                       textColor: .rsnPurpleColor,
                       font: .boldSystemFont(ofSize: 30.0))
    }()
    
    private(set) lazy var enterDataForLogInLabel: UILabel = {
        makeLabel(text: "Enter data for log in:",
                       textColor: .white,
                       font: .boldSystemFont(ofSize: 20.0))
    }()
    
    private(set) lazy var userLoginTextField: UITextField = {
        makeTextField(placeholder: "User login",
                           font: .systemFont(ofSize: 17),
                           borderStyle: .roundedRect)
    }()
    
    private(set) lazy var passwordTextField: UITextField = {
        makeTextField(placeholder: "Password",
                           font: .systemFont(ofSize: 17),
                           borderStyle: .roundedRect)
    }()
    
    private(set) lazy var logInButton: UIButton = {
        makeButton(title: "Log in",
                        font: .boldSystemFont(ofSize: 17),
                        backgroundColor: .rsnLightGreenColor,
                        cornerRadius: 8.0)
    }()
    
    private(set) lazy var signUpButton: UIButton = {
        makeButton(title: "Sign up",
                        font: .boldSystemFont(ofSize: 17),
                        backgroundColor: .rsnPinkColor,
                        cornerRadius: 8.0)
    }()
    
    private(set) lazy var restorePasswordButton: UIButton = {
        makeButton(title: "Restore password",
                   font: .boldSystemFont(ofSize: 17),
                   backgroundColor: .lightGray,
                   cornerRadius: 8.0)
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration Methods
    func configureUI() {
        passwordTextField.isSecureTextEntry = true
        addSubview(scrollView)
        scrollView.addSubview(logoLogInScreenImageView)
        scrollView.addSubview(logoLogInScreenLabel)
        scrollView.addSubview(enterDataForLogInLabel)
        scrollView.addSubview(userLoginTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(logInButton)
        scrollView.addSubview(signUpButton)
        scrollView.addSubview(restorePasswordButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(
                equalTo: safeAreaLayoutGuide.rightAnchor),
            
            logoLogInScreenImageView.topAnchor.constraint(
                equalTo: scrollView.topAnchor,
                constant: 50.0),
            logoLogInScreenImageView.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            logoLogInScreenImageView.heightAnchor.constraint(
                equalToConstant: 150.0),
            logoLogInScreenImageView.widthAnchor.constraint(
                equalToConstant: 160.0),
            
            logoLogInScreenLabel.topAnchor.constraint(
                equalTo: logoLogInScreenImageView.bottomAnchor,
                constant: 10.0),
            logoLogInScreenLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            
            enterDataForLogInLabel.topAnchor.constraint(
                equalTo: logoLogInScreenLabel.bottomAnchor,
                constant: 20.0),
            enterDataForLogInLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            
            userLoginTextField.topAnchor.constraint(
                equalTo: enterDataForLogInLabel.bottomAnchor,
                constant: 10.0),
            userLoginTextField.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            userLoginTextField.heightAnchor.constraint(
                equalToConstant: 25.0),
            userLoginTextField.widthAnchor.constraint(
                equalToConstant: 270.0),
            
            passwordTextField.topAnchor.constraint(
                equalTo: userLoginTextField.bottomAnchor,
                constant: 10.0),
            passwordTextField.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            passwordTextField.heightAnchor.constraint(
                equalToConstant: 25.0),
            passwordTextField.widthAnchor.constraint(
                equalToConstant: 270.0),
            
            logInButton.topAnchor.constraint(
                equalTo: passwordTextField.bottomAnchor,
                constant: 20.0),
            logInButton.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            logInButton.heightAnchor.constraint(
                equalToConstant: 30.0),
            logInButton.widthAnchor.constraint(
                equalToConstant: 100.0),
            
            signUpButton.topAnchor.constraint(
                equalTo: logInButton.bottomAnchor,
                constant: 20.0),
            signUpButton.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            signUpButton.heightAnchor.constraint(
                equalToConstant: 30.0),
            signUpButton.widthAnchor.constraint(
                equalToConstant: 100.0),
            
            restorePasswordButton.topAnchor.constraint(
                equalTo: signUpButton.bottomAnchor,
                constant: 20.0),
            restorePasswordButton.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            restorePasswordButton.heightAnchor.constraint(
                equalToConstant: 30.0),
            restorePasswordButton.widthAnchor.constraint(
                equalToConstant: 180.0)
        ])
    }
}
