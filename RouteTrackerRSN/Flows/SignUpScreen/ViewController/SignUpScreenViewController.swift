//
//  SignUpScreenViewController.swift
//  RouteTrackerRSN
//
//  Created by Sergey Razgulyaev on 09.04.2021.
//

import UIKit
import RealmSwift

class SignUpScreenViewController: UIViewController, Alertable {
    // MARK: - UI components
    private lazy var signUpScreenView: SignUpScreenView = {
        return SignUpScreenView()
    }()
    
    //MARK: - Properties for Interaction with Database
    private var filteredUserNotificationToken: NotificationToken?
    private let realmManager: RealmManager
    
    private var filteredUserFromRealm: Results<User>? {
        guard !(signUpScreenView.userLoginTextField.text?.isTrimmedEmpty ?? true) else {
            return realmManager.getObjects()
        }
        return realmManager.getObjects().filter("login == [cd] %@", signUpScreenView.userLoginTextField.text ?? "")
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
        view = signUpScreenView
    }
    
    //MARK: - Configuration Methods
    func configureViewController() {
        view.backgroundColor = .rsnLightBlueColor
    }
    
    func configureUIComponents() {
        configureSignUpButton()
        configureReturnButton()
    }
    
    func configureSignUpButton() {
        signUpScreenView.signUpButton.addTarget(self, action: #selector(tapSignUpButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapSignUpButton(_ sender: Any?) {
        if isFilledTextFields() {
            signUp()
        } else {
            self.showAttantionAlert(
                viewController: self,
                message: "You need to fill in all the fields for sign up")
        }
    }
    
    func isFilledTextFields() -> Bool {
        if (!(signUpScreenView.userLoginTextField.text?.isTrimmedEmpty ?? true) && !(signUpScreenView.passwordTextField.text?.isTrimmedEmpty ?? true)) {
            return true
        } else {
            return false
        }
    }
    
    func configureReturnButton() {
        signUpScreenView.returnButton.addTarget(self, action: #selector(tapReturnButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapReturnButton(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Methods
    func signUp() {
        showAlertWithWritingToRealm()
    }
}

//MARK: - Interaction with Realm Database
extension SignUpScreenViewController {
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
    
    func writeSignedUpUserToRealm() {
        let signedUpUser = User()
        signedUpUser.login = signUpScreenView.userLoginTextField.text ?? "badSignedUpUserLogin"
        signedUpUser.password = signUpScreenView.passwordTextField.text ?? "badSignedUpUserPassword"
        if filteredUserFromRealm?.first?.login == signedUpUser.login {
            showAlertWithChangingPassword()
        } else {
            try? realmManager.add(object: signedUpUser)
        }
    }
}

//MARK: - Keyboard configuration
extension SignUpScreenViewController {
    func keyboardAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        signUpScreenView.scrollView.addGestureRecognizer(tapGesture)
    }
    
    func keyboardRemoveObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        signUpScreenView.scrollView.contentInset = contentInsets
        signUpScreenView.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        signUpScreenView.scrollView.contentInset = UIEdgeInsets.zero
        signUpScreenView.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc func hideKeyboard() {
        signUpScreenView.scrollView.endEditing(true)
    }
}

//MARK: - Alerts
extension SignUpScreenViewController {
    func showAlertWithWritingToRealm() {
        let alertController = UIAlertController(title: "Attention", message: "Do you want to register a user with the data you entered?", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {_ in
            self.writeSignedUpUserToRealm()
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

        alertController.addAction(yesAction)
        alertController.addAction(noAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithChangingPassword() {
        let alertController = UIAlertController(title: "Attention", message: "This user is already registered, do you want to change the password to the one you entered?", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: {_ in
            let signedUpUserWhoNeedsToChangePassword = User()
            signedUpUserWhoNeedsToChangePassword.login = self.filteredUserFromRealm?.first?.login ?? "badSignedUpUserLogin"
            signedUpUserWhoNeedsToChangePassword.password = self.filteredUserFromRealm?.first?.password ?? "badSignedUpUserPassword"
            try? self.realmManager.deleteUser(user: signedUpUserWhoNeedsToChangePassword)
            self.writeSignedUpUserToRealm()
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

        alertController.addAction(yesAction)
        alertController.addAction(noAction)

        present(alertController, animated: true, completion: nil)
    }

}
