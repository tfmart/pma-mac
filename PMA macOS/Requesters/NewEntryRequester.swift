//
//  NewEntryRequester.swift
//  PMA macOS
//
//  Created by Tomas Martins on 30/01/20.
//  Copyright © 2020 Tomas Martins. All rights reserved.
//

import Foundation

class NewEntryRequester {
    var startDate: String
    var endDate: String
    var projectId: Int
    var activityId: Int
    var description: String
    
    init(start: String, end: String, projectID: Int, activityID: Int, description: String) {
        self.startDate = start
        self.endDate = end
        self.projectId = projectID
        self.activityId = activityID
        self.description = description
    }
    
    func start() {
        let url = URL(string: "https://pma.dextra.com.br/registros.json?inicio=\(startDate)&fim=\(endDate)&projeto_id=\(projectId)&atividade_id=\(activityId)&descricao=\(description)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            dump(data)
        }

        task.resume()
    }
}
