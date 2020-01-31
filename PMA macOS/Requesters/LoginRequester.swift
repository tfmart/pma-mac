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
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    func start() {
        guard let username = self.username, let password = self.password else { return }
        let url = URL(string: "https://pma.dextra.com.br/login.json?login=\(username)&senha=\(password)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            let responseString = String(data: data, encoding: String.Encoding.utf8)
            dump(responseString)
        }

        task.resume()
    }
}
