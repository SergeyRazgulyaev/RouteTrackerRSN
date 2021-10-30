//
//  RestorePasswordScreenView.swift
//  RouteTrackerRSN
//
//  Created by Sergey Razgulyaev on 11.04.2021.
//

import UIKit

class RestorePasswordScreenView: UIView, UIComponentsMakeable {
    // MARK: - UI components
    private(set) lazy var scrollView: UIScrollView = {
        makeScrollView()
    }()
    
    private(set) lazy var logoRestorePasswordScreenImageView: UIImageView = {
        makeImageView(image: UIImage(systemName: "questionmark.circle")!,
                            tintColor: .rsnPurpleColor)
    }()
    
    private(set) lazy var logoRestorePasswordScreenLabel: UILabel = {
        makeLabel(text: "Restore password",
                  textColor: .rsnPurpleColor,
                  font: .boldSystemFont(ofSize: 30.0))
    }()
    
    private(set) lazy var enterLoginToRecoverPasswordLabel: UILabel = {
        makeLabel(text: "Enter login to restore password",
                  textColor: .white,
                  font: .boldSystemFont(ofSize: 20.0))
    }()
    
    private(set) lazy var userLoginTextField: UITextField = {
        makeTextField(placeholder: "User login",
                      font: .systemFont(ofSize: 17),
                      borderStyle: .roundedRect)
    }()
    
    private(set) lazy var restorePasswordButton: UIButton = {
        makeButton(title: "Restore password",
                   font: .boldSystemFont(ofSize: 17),
                   backgroundColor: .rsnLightGreenColor,
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
        addSubview(scrollView)
        scrollView.addSubview(logoRestorePasswordScreenImageView)
        scrollView.addSubview(logoRestorePasswordScreenLabel)
        scrollView.addSubview(enterLoginToRecoverPasswordLabel)
        scrollView.addSubview(userLoginTextField)
        scrollView.addSubview(restorePasswordButton)
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
            
            logoRestorePasswordScreenImageView.topAnchor.constraint(
                equalTo: scrollView.topAnchor,
                constant: 50.0),
            logoRestorePasswordScreenImageView.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            logoRestorePasswordScreenImageView.heightAnchor.constraint(
                equalToConstant: 150.0),
            logoRestorePasswordScreenImageView.widthAnchor.constraint(
                equalToConstant: 150.0),
            
            logoRestorePasswordScreenLabel.topAnchor.constraint(
                equalTo: logoRestorePasswordScreenImageView.bottomAnchor,
                constant: 10.0),
            logoRestorePasswordScreenLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            
            enterLoginToRecoverPasswordLabel.topAnchor.constraint(
                equalTo: logoRestorePasswordScreenLabel.bottomAnchor,
                constant: 20.0),
            enterLoginToRecoverPasswordLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            
            userLoginTextField.topAnchor.constraint(
                equalTo: enterLoginToRecoverPasswordLabel.bottomAnchor,
                constant: 10.0),
            userLoginTextField.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            userLoginTextField.heightAnchor.constraint(
                equalToConstant: 25.0),
            userLoginTextField.widthAnchor.constraint(
                equalToConstant: 270.0),
            
            restorePasswordButton.topAnchor.constraint(
                equalTo: userLoginTextField.bottomAnchor,
                constant: 20.0),
            restorePasswordButton.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            restorePasswordButton.heightAnchor.constraint(
                equalToConstant: 30.0),
            restorePasswordButton.widthAnchor.constraint(
                equalToConstant: 180.0),
            
            returnButton.topAnchor.constraint(
                equalTo: restorePasswordButton.bottomAnchor,
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
