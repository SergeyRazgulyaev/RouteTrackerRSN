//
//  LogInScreenViewController.swift
//  RouteTrackerRSN
//
//  Created by Sergey Razgulyaev on 09.04.2021.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class LogInScreenViewController: UIViewController, Alertable {
    // MARK: - UI components
    private lazy var logInScreenView: LogInScreenView = {
        return LogInScreenView()
    }()
    
    //MARK: - Properties for Interaction with Database
    private var userNotificationToken: NotificationToken?
    private let realmManager: RealmManager
    private var userLogin: String?
    
    private var filteredUserFromRealm: Results<User>? {
        guard !(logInScreenView.userLoginTextField.text?.isTrimmedEmpty ?? true) else {
            return realmManager.getObjects()
        }
        return realmManager.getObjects().filter("login == [cd] %@", logInScreenView.userLoginTextField.text ?? "")
    }
    
    // MARK: - Init
    init(realmManager: RealmManager) {
        self.realmManager = realmManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUIComponents()
        createNotification()
        configureLogInBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearLogInScreenTextFields()
        keyboardAddObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardRemoveObserver()
    }
    
    override func loadView() {
        view = logInScreenView
    }
    
    //MARK: - Configuration Methods
    func configureViewController() {
        view.backgroundColor = .rsnLightBlueColor
    }
    
    func configureUIComponents() {
        configureLogInButton()
        configureSignUpButton()
        configureRestorePasswordButton()
    }
    
    func configureLogInButton() {
        logInScreenView.logInButton.addTarget(self, action: #selector(tapLogInButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapLogInButton(_ sender: Any?) {
        logIn()
    }
    
    func configureSignUpButton() {
        logInScreenView.signUpButton.addTarget(self, action: #selector(tapSignUpButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapSignUpButton(_ sender: Any?) {
        let signUpScreenViewController = SignUpScreenViewController(realmManager: realmManager)
        signUpScreenViewController.modalPresentationStyle = .fullScreen
        self.present(signUpScreenViewController, animated: true, completion: nil)
    }
    
    func configureRestorePasswordButton() {
        logInScreenView.restorePasswordButton.addTarget(self, action: #selector(tapRestorePasswordButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapRestorePasswordButton(_ sender: Any?) {
        let restorePasswordScreenViewController = RestorePasswordScreenViewController(realmManager: realmManager)
        restorePasswordScreenViewController.modalPresentationStyle = .fullScreen
        self.present(restorePasswordScreenViewController, animated: true, completion: nil)
    }
    
    func configureLogInBindings() {
        let bindObserver = Observable
            .combineLatest(logInScreenView.userLoginTextField.rx.text, logInScreenView.passwordTextField.rx.text)
            .map { login, password in
                return !(self.logInScreenView.userLoginTextField.text?.isTrimmedEmpty ?? true) && !(self.logInScreenView.passwordTextField.text?.isTrimmedEmpty ?? true)
            }
            .bind { [weak self] inputFilled in
                self?.logInScreenView.logInButton.isEnabled = inputFilled
            }
    }
    
    //MARK: - Methods
    func clearLogInScreenTextFields() {
        logInScreenView.userLoginTextField.text = ""
        logInScreenView.passwordTextField.text = ""
    }
    
    func logIn() {
        if logInScreenView.userLoginTextField.text == filteredUserFromRealm?.first?.login && logInScreenView.passwordTextField.text == filteredUserFromRealm?.first?.password {
            userLogin = filteredUserFromRealm?.first?.login ?? ""
            let tabBarController = TabBarController(realmManager: realmManager, userLogin: userLogin ?? "")
            tabBarController.modalPresentationStyle = .fullScreen
            self.present(tabBarController, animated: true, completion: nil)
        } else {
            self.showAttantionAlert(
                viewController: self,
                message: "Login or password is not correct")
        }
    }
}

//MARK: - Interaction with Realm Database
extension LogInScreenViewController {
    private func createNotification() {
        userNotificationToken = filteredUserFromRealm?.observe { [weak self] change in
            switch change {
            case let .initial(routePaths):
                print("Initialized \(routePaths.count)")
                
            case let .update(routePaths, deletions: deletions, insertions: insertions, modifications: modifications):
                print("""
                        New count: \(routePaths.count)
                        Deletions: \(deletions)
                        Insertions: \(insertions)
                        Modifications: \(modifications)
                        """)
                
            case let .error(error):
                guard let self = self else { return }
                self.showAttantionAlert(viewController: self, message: error.localizedDescription)
            }
        }
    }
}

//MARK: - Keyboard configuration
extension LogInScreenViewController {
    func keyboardAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        logInScreenView.scrollView.addGestureRecognizer(tapGesture)
    }
    
    func keyboardRemoveObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        logInScreenView.scrollView.contentInset = contentInsets
        logInScreenView.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        logInScreenView.scrollView.contentInset = UIEdgeInsets.zero
        logInScreenView.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc func hideKeyboard() {
        logInScreenView.scrollView.endEditing(true)
    }
}
