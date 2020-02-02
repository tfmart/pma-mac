//
//  PMAError.swift
//  PMA macOS
//
//  Created by Tomás Feitoza Martins  on 31/01/20.
//  Copyright © 2020 Tomas Martins. All rights reserved.
//

import Foundation

enum PMAError: String, Error {
    //MARK: - Login errors
    case invalidCredentials = "Usuario e/ou senha inválidos"
    case missingLoginField = "Login e senha são obrigatorios"
    //MARK: - New Entry erros
    case invalidStartDate = "Início não pode ser maior ou igual ao fim."
    case entryAlreadyExists = "Já existe um registro cadastrado para esse dia no intervalo informado. Favor verifique e tente novamente."
    case invalidProjectOrActivity = "Erro ao salvar apontamento: Esse projeto ou atividade não existe"
    case nonRegisteredActivity = "Você não está alocado nesta atividade. Procure seu gerente, ou responsável."
    case missingDescription = "Descricao é de preenchimento obrigatório."
    case differentDays = "Início e fim devem ser no mesmo dia."
    case expiredSession = "Sua sessão expirou. Efetue o login novamente."
    case invalidEndTime = "Fim  precisa pertencer a intervalos de 5 minutos."
    case noTimeDifference = " Esforço deve ser maior que 0."
    case invalidActivity = "O apontamento não corresponde a nenhuma etapa cadastrada no projeto. Procure seu gerente, ou responsável."
    case invalidPeriod = "Apontamentos fora do periodo válido só poderão ser criados, alterados ou removidos com desbloqueio. Para efetuar o desbloqueio procure o seu GP. Em caso de dúvidas procure o RH."
    case futureDate = "Não é possível fazer apontamentos futuros."
    //MARK: - General
    case noData = "Verifique a sua conexão com a internet"
    case decodeError
    case unknown = "Ocorreu um erro desconhecido"
}
