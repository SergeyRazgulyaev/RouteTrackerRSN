//
//  SignUpScreenView.swift
//  RouteTrackerRSN
//
//  Created by Sergey Razgulyaev on 09.04.2021.
//

import UIKit

class SignUpScreenView: UIView, UIComponentsMakeable {
    // MARK: - UI components
    private(set) lazy var scrollView: UIScrollView = {
        makeScrollView()
    }()
    
    private(set) lazy var logoSignUpScreenImageView: UIImageView = {
        makeImageView(image: UIImage(systemName: "figure.wave")!,
                            tintColor: .rsnPurpleColor)
    }()
    
    private(set) lazy var logoSignUpScreenLabel: UILabel = {
        makeLabel(text: "Let's sign up",
                       textColor: .rsnPurpleColor,
                       font: .boldSystemFont(ofSize: 30.0))
    }()
    
    private(set) lazy var enterDataForSignUpLabel: UILabel = {
        makeLabel(text: "Enter data for sign up:",
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
    
    private(set) lazy var signUpButton: UIButton = {
        makeButton(title: "Sign up",
                        font: .boldSystemFont(ofSize: 17),
                        backgroundColor: .rsnPinkColor,
                        cornerRadius: 8.0)
    }()
    
    private(set) lazy var returnButton: UIButton = {
        makeButton(title: "Return",
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
        scrollView.addSubview(logoSignUpScreenImageView)
        scrollView.addSubview(logoSignUpScreenLabel)
        scrollView.addSubview(enterDataForSignUpLabel)
        scrollView.addSubview(userLoginTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(signUpButton)
        scrollView.addSubview(returnButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(
                equalTo: safeAreaLayoutGuide.rightAnchor),
            
            logoSignUpScreenImageView.topAnchor.constraint(
                equalTo: scrollView.topAnchor,
                constant: 50.0),
            logoSignUpScreenImageView.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            logoSignUpScreenImageView.heightAnchor.constraint(
                equalToConstant: 150.0),
            logoSignUpScreenImageView.widthAnchor.constraint(
                equalToConstant: 100.0),
            
            logoSignUpScreenLabel.topAnchor.constraint(
                equalTo: logoSignUpScreenImageView.bottomAnchor,
                constant: 10.0),
            logoSignUpScreenLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            
            enterDataForSignUpLabel.topAnchor.constraint(
                equalTo: logoSignUpScreenLabel.bottomAnchor,
                constant: 20.0),
            enterDataForSignUpLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            
            userLoginTextField.topAnchor.constraint(
                equalTo: enterDataForSignUpLabel.bottomAnchor,
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
            
            signUpButton.topAnchor.constraint(
                equalTo: passwordTextField.bottomAnchor,
                constant: 20.0),
            signUpButton.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            signUpButton.heightAnchor.constraint(
                equalToConstant: 30.0),
            signUpButton.widthAnchor.constraint(
                equalToConstant: 100.0),
            
            returnButton.topAnchor.constraint(
                equalTo: signUpButton.bottomAnchor,
                constant: 20.0),
            returnButton.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            returnButton.heightAnchor.constraint(
                equalToConstant: 30.0),
            returnButton.widthAnchor.constraint(
                equalToConstant: 100.0)
        ])
    }
}
