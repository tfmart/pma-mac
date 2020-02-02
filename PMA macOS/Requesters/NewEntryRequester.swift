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
    public typealias Completion = ((Entry?, PMAError?) -> Void)
    var completion: Completion
    
    init(start: String, end: String, projectID: Int, activityID: Int, description: String, completion: @escaping Completion) {
        self.startDate = start
        self.endDate = end
        self.projectId = projectID
        self.activityId = activityID
        self.description = description
        self.completion = completion
    }
    
    func start() {
        let url = URL(string: "https://pma.dextra.com.br/registros.json?inicio=\(startDate)&fim=\(endDate)&projeto_id=\(projectId)&atividade_id=\(activityId)&descricao=\(description)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                self.completion(nil, .noData)
                return
            }
            self.parseJson(data: data)
        }

        task.resume()
    }
    
    private func parseJson(data: Data) {
        do {
            let entry = try self.parseData(data: data)
            completion(entry, nil)
        }
        catch (let error) {
            completion(nil, error as? PMAError)
        }
    }
    
    private func parseData(data: Data) throws -> Entry{
        do {
            let decoder = JSONDecoder()
            let decodedWebsites = try decoder.decode(Entry.self, from: data)
            return decodedWebsites
        } catch {
            let errorDecoder = JSONDecoder()
            let errors = try? errorDecoder.decode([String].self, from: data)
            guard let requestError = errors?[0] else {
                guard let requestError = String(data: data, encoding: String.Encoding.utf8) else {
                    throw PMAError.decodeError
                }
                throw getError(for: requestError)
            }
            throw getError(for: requestError)
        }
    }
    
    private func getError(for response: String) -> PMAError{
        switch response {
        case "Erro ao salvar apontamento: Esse projeto ou atividade não existe":
            return PMAError.invalidProjectOrActivity
        case "Você não está alocado nesta atividade. Procure seu gerente, ou responsável.":
            return PMAError.nonRegisteredActivity
        case "Descricao é de preenchimento obrigatório.":
            return PMAError.missingDescription
        case "Início e fim devem ser no mesmo dia.":
            return PMAError.differentDays
        case "Sua sessão expirou. Efetue o login novamente.":
            return PMAError.expiredSession
        case "Fim  precisa pertencer a intervalos de 5 minutos.":
            return PMAError.invalidEndTime
        case " Já existe um registro cadastrado para esse dia no intervalo informado. Favor verifique e tente novamente.":
            return PMAError.entryAlreadyExists
        default:
            dump(response)
            return PMAError.unknown
        }
    }
}
