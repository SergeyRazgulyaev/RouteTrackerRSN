//
//  RestorePasswordScreenViewController.swift
//  RouteTrackerRSN
//
//  Created by Sergey Razgulyaev on 11.04.2021.
//

import UIKit
import RealmSwift

class RestorePasswordScreenViewController: UIViewController, Alertable {
    // MARK: - UI components
    private lazy var restorePasswordScreenView: RestorePasswordScreenView = {
        return RestorePasswordScreenView()
    }()
    
    //MARK: - Properties for Interaction with Database
    private var filteredUserNotificationToken: NotificationToken?
    private let realmManager: RealmManager
    
    private var filteredUserFromRealm: Results<User>? {
        guard !(restorePasswordScreenView.userLoginTextField.text?.isTrimmedEmpty ?? true) else {
            return realmManager.getObjects()
        }
        return realmManager.getObjects().filter("login == [cd] %@", restorePasswordScreenView.userLoginTextField.text ?? "")
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardAddObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardRemoveObserver()
    }
    
    override func loadView() {
        view = restorePasswordScreenView
    }
    
    //MARK: - Configuration Methods
    func configureViewController() {
        view.backgroundColor = .rsnLightBlueColor
    }
    
    func configureUIComponents() {
        configureRestorePasswordButton()
        configureReturnButton()
    }
    
    func configureRestorePasswordButton() {
        restorePasswordScreenView.restorePasswordButton.addTarget(self, action: #selector(tapRestorePasswordButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapRestorePasswordButton(_ sender: Any?) {
        if isFilledTextFields() {
            restorePassword()
        } else {
            self.showAttantionAlert(
                viewController: self,
                message: "You need to fill in user login field for restore password")
        }
    }
    
    func isFilledTextFields() -> Bool {
        if !(restorePasswordScreenView.userLoginTextField.text?.isTrimmedEmpty ?? true) {
            return true
        } else {
            return false
        }
    }
    
    func configureReturnButton() {
        restorePasswordScreenView.returnButton.addTarget(self, action: #selector(tapReturnButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapReturnButton(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Interaction with Realm Database
extension RestorePasswordScreenViewController {
    func createNotification() {
        filteredUserNotificationToken = filteredUserFromRealm?.observe { [weak self] change in
            switch change {
            case let .initial(user):
                print("Initialized \(user.count)")
                
            case let .update(user, deletions: deletions, insertions: insertions, modifications: modifications):
                print("""
                        New count: \(user.count)
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
    
    func restorePassword() {
        let userWhoRestoresHisPassword = User()
        userWhoRestoresHisPassword.login = restorePasswordScreenView.userLoginTextField.text ?? "badUserWhoRestoresHisPasswordLogin"
        if filteredUserFromRealm?.first?.login == userWhoRestoresHisPassword.login {
            self.showAttantionAlert(
                viewController: self,
                message: "Password recovery instructions are aimed at your email")
        } else {
            self.showAttantionAlert(
                viewController: self,
                message: "User with such login is not signed up")
        }
    }
}

//MARK: - Keyboard configuration
extension RestorePasswordScreenViewController {
    func keyboardAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        restorePasswordScreenView.scrollView.addGestureRecognizer(tapGesture)
    }
    
    func keyboardRemoveObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        restorePasswordScreenView.scrollView.contentInset = contentInsets
        restorePasswordScreenView.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        restorePasswordScreenView.scrollView.contentInset = UIEdgeInsets.zero
        restorePasswordScreenView.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc func hideKeyboard() {
        restorePasswordScreenView.scrollView.endEditing(true)
    }
}
