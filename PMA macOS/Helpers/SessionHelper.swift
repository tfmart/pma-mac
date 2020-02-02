//
//  SessionHelper.swift
//  PMA macOS
//
//  Created by Tomas Martins on 01/02/20.
//  Copyright © 2020 Tomas Martins. All rights reserved.
//

import Cocoa

class SessionHelper {
    var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    private var password: String = UserDefaults.standard.string(forKey: "password") ?? ""
    var usernameTextField: NSTextField!
    var passwordTextField: NSSecureTextField!
    var textfieldsStackView: NSStackView!
    var loginAlert: NSAlert!
    
    static public let shared = SessionHelper()
    private init() {
    }
    
    private func setupTextFields() {
        usernameTextField = NSTextField(frame: NSRect(x: 0, y: 28, width: 200, height: 24))
        usernameTextField.placeholderString = "Usuário"
        usernameTextField.nextKeyView = passwordTextField
        passwordTextField = NSSecureTextField(frame: NSRect(x: 0, y: 2, width: 200, height: 24))
        passwordTextField.placeholderString = "Senha"
    }
    
    private func setupStackView() {
        setupTextFields()
        textfieldsStackView = NSStackView(frame: NSRect(x: 0, y: 0, width: 200, height: 58))
        textfieldsStackView.addSubview(passwordTextField)
        textfieldsStackView.addSubview(usernameTextField)
    }
    
    var hasSession: Bool {
        return UserDefaults.standard.bool(forKey: "hasSession")
    }
    
    private func setupLoginAlert(message: String? = nil) {
        loginAlert = NSAlert()
        loginAlert.messageText = "PMA"
        loginAlert.informativeText = message ?? "Inicie a sua sessão"
        loginAlert.alertStyle = .warning
        loginAlert.addButton(withTitle: "Login")
        loginAlert.addButton(withTitle: "Cancelar")
        setupStackView()
        loginAlert.accessoryView = textfieldsStackView
    }
    
    func newSession(username: String, password: String, success: @escaping () -> ()) {
        self.username = username
        self.password =  password
        performLogin(success: success)
    }
    
    func performLogin(success: @escaping () -> ()) {
        let requester = LoginRequester(username: self.username, password: self.password) { (message, error) in
            if let error  = error {
                DispatchQueue.main.async {
                    self.errorAlert(with: error, success: success)
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
    
    private func errorAlert(with error: PMAError?, success: @escaping () -> ()) {
        let errorAlert = NSAlert()
        errorAlert.messageText = "Falha ao logar"
        errorAlert.informativeText = error?.rawValue ?? "Verifique se você digitou o seu usuário ou senha corretamente"
        errorAlert.addButton(withTitle: "Login")
        errorAlert.addButton(withTitle: "Cancelar")
        errorAlert.accessoryView = textfieldsStackView
        let reponse = errorAlert.runModal()
        if reponse == .alertFirstButtonReturn {
            self.username = usernameTextField.stringValue
            self.password = passwordTextField.stringValue
            performLogin(success: success)
        }
    }
    
    func displayLogin(message: String? = nil, success: @escaping () -> ()) {
        setupLoginAlert()
        let response = loginAlert.runModal()
        if response == .alertFirstButtonReturn {
            SessionHelper.shared.newSession(username: SessionHelper.shared.usernameTextField.stringValue,
                                             password: SessionHelper.shared.passwordTextField.stringValue,
                                             success: success)
        }
    }
}
