//
//  SessionHelper.swift
//  PMA macOS
//
//  Created by Tomas Martins on 01/02/20.
//  Copyright © 2020 Tomas Martins. All rights reserved.
//

import Cocoa

class SessionHelper {
    //MARK: - Properties
    var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    private var password: String = UserDefaults.standard.string(forKey: "password") ?? ""
    var usernameTextField: NSTextField!
    var passwordTextField: NSSecureTextField!
    var textfieldsStackView: NSStackView!
    var loginAlert: NSAlert!
    
    /// A Boolean value indicating whether the user is currently logged in or not
    var hasSession: Bool {
        return UserDefaults.standard.bool(forKey: "hasSession")
    }
    
    /// A Boolean value indicating wheter the user is logging in for the first time or not, for onboarding purposes
    var isPreviousUser: Bool {
        return UserDefaults.standard.bool(forKey: "isPreviousUser")
    }
    
    static public let shared = SessionHelper()
    private init() {}
    
    //MARK: - Session methods
    
    /// Store user credentials to be used in the current session
    /// - Parameters:
    ///   - username: The user's username
    ///   - password: The user's password
    ///   - success: Block that executes if login is successful
    func newSession(username: String, password: String, success: @escaping () -> ()) {
        self.username = username
        self.password =  password
        performLogin(success: success)
    }
    
    /// Attemps to log in the user through the Login API
    /// - Parameter success: Block that executes if login is successful
    func performLogin(success: @escaping () -> ()) {
        let requester = LoginRequester(username: self.username, password: self.password) { (message, error) in
            if let error  = error {
                DispatchQueue.main.async {
                    self.displayLogin(title: "Falha ao logar", message: error.rawValue, success: success)
                }
            } else {
                UserDefaults.standard.set(true, forKey: "hasSession")
                UserDefaults.standard.set(self.username, forKey: "username")
                UserDefaults.standard.set(self.password, forKey: "password")
                success()
            }
        }
        requester.start()
    }
    
    /// Removes all locally stored data about the user's session
    @objc func endSession() {
        UserDefaults.standard.set(false, forKey: "hasSession")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
    }
    
    //MARK: - Display Alert Methods
    /// Displays a login alert
    /// - Parameters:
    ///   - title: Optional title to be displayed in the alert
    ///   - message: Optional message to be displayed in the alert
    ///   - success: Block that executes if login is succesful
    func displayLogin(title: String? = nil, message: String? = nil, success: @escaping () -> ()) {
        setupLoginAlert(title: title, message: message)
        let response = loginAlert.runModal()
        if response == .alertFirstButtonReturn {
            SessionHelper.shared.newSession(username: SessionHelper.shared.usernameTextField.stringValue,
                                             password: SessionHelper.shared.passwordTextField.stringValue,
                                             success: success)
        }
    }
    
    //MARK: - View setup
    /// Setup both username and password textfields to be used inside the login alert
    private func setupTextFields() {
        usernameTextField = NSTextField(frame: NSRect(x: 0, y: 28, width: 200, height: 24))
        usernameTextField.placeholderString = "Usuário"
        passwordTextField = NSSecureTextField(frame: NSRect(x: 0, y: 2, width: 200, height: 24))
        passwordTextField.placeholderString = "Senha"
        usernameTextField.nextKeyView = passwordTextField
    }
    
    /// Setups stack view which holds the textfields inside the login
    private func setupStackView() {
        setupTextFields()
        textfieldsStackView = NSStackView(frame: NSRect(x: 0, y: 0, width: 200, height: 58))
        textfieldsStackView.addSubview(passwordTextField)
        textfieldsStackView.addSubview(usernameTextField)
    }
    
    /// Setups the login alert to be displayed
    /// - Parameters:
    ///   - title: The optional title to be displayed in the alert
    ///   - message: The optional message to be displayed in the alert
    private func setupLoginAlert(title: String? = nil, message: String? = nil) {
        loginAlert = NSAlert()
        loginAlert.messageText = title ?? "PMA"
        loginAlert.informativeText = message ?? "Inicie a sua sessão"
        loginAlert.alertStyle = .warning
        loginAlert.addButton(withTitle: "Login")
        loginAlert.addButton(withTitle: "Cancelar")
        setupStackView()
        loginAlert.accessoryView = textfieldsStackView
    }
}
