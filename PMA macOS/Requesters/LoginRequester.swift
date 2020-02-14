//
//  LoginRequester.swift
//  PMA macOS
//
//  Created by Tomas Martins on 30/01/20.
//  Copyright © 2020 Tomas Martins. All rights reserved.
//

import Foundation

class LoginRequester {
    
    var username: String?
    var password: String?
    public typealias Completion = ((String?, PMAError?) -> Void)
    var completion: Completion
    
    init(username: String, password: String, completion: @escaping Completion) {
        self.username = username
        self.password = password
        self.completion = completion
    }
    
    func start() {
        guard let username = self.username?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let password = self.password?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let url = URL(string: "https://pma.dextra.com.br/login.json?login=\(username)&senha=\(password  )")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                self.completion(nil, .noData)
                return
            }
            guard let responseString = String(data: data, encoding: String.Encoding.utf8) else {
                self.completion(nil, .decodeError)
                return
            }
            switch responseString {
            case "Usuario e/ou senha inválidos":
                self.completion(nil, .invalidCredentials)
            case "Login e senha são obrigatorios", "Login deve estar no formato \'nome.sobrenome\'":
                self.completion(nil, .missingLoginField)
            default:
                self.completion(responseString, nil)
            }
        }

        task.resume()
    }
}
