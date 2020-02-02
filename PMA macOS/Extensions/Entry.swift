//
//  Entry.swift
//  PMA macOS
//
//  Created by Tomás Feitoza Martins  on 31/01/20.
//  Copyright © 2020 Tomas Martins. All rights reserved.
//

import Foundation

// MARK: - Registro
public class Entry: Codable {
    let trueDate: String?
    let inicio, createdAt: String?
    let atividadeID, id: Int?
    let data: String?
    let apontamentoDiarioID: Int?
    let updatedAt: String?
    let projetoID: Int?
    let minutoInicio, minutoFim: String?
    let fim: String?
    let statusDia: String?
    let descricao: String?
    let aprovacao: Int?
    let statusID: Int?
    let horaIntervalo: Int?
    let horaInicio, categoriaID: Int?
    let minutoIntervalo: Int?
    let horaFim, descricaoReprovacao: Int?
    let usuarioID, esforco: Int?

    enum CodingKeys: String, CodingKey {
        case trueDate = "true_date"
        case inicio
        case createdAt = "created_at"
        case atividadeID = "atividade_id"
        case id, data
        case apontamentoDiarioID = "apontamento_diario_id"
        case updatedAt = "updated_at"
        case projetoID = "projeto_id"
        case minutoInicio = "minuto_inicio"
        case minutoFim = "minuto_fim"
        case fim
        case statusDia = "status_dia"
        case descricao, aprovacao
        case statusID = "status_id"
        case horaIntervalo = "hora_intervalo"
        case horaInicio = "hora_inicio"
        case categoriaID = "categoria_id"
        case minutoIntervalo = "minuto_intervalo"
        case horaFim = "hora_fim"
        case descricaoReprovacao = "descricao_reprovacao"
        case usuarioID = "usuario_id"
        case esforco
    }
    
    required public init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.trueDate = try container.decodeIfPresent(String.self, forKey: .trueDate)
        self.inicio = try container.decodeIfPresent(String.self, forKey: .inicio)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.atividadeID = try container.decodeIfPresent(Int.self, forKey: .atividadeID)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.data = try container.decodeIfPresent(String.self, forKey: .data)
        self.apontamentoDiarioID = try container.decodeIfPresent(Int.self, forKey: .apontamentoDiarioID)
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        self.projetoID = try container.decodeIfPresent(Int.self, forKey: .projetoID)
        self.minutoInicio = try container.decodeIfPresent(String.self, forKey: .minutoInicio)
        self.minutoFim = try container.decodeIfPresent(String.self, forKey: .minutoFim)
        self.fim = try container.decodeIfPresent(String.self, forKey: .fim)
        self.statusDia = try container.decodeIfPresent(String.self, forKey: .statusDia)
        self.descricao = try container.decodeIfPresent(String.self, forKey: .descricao)
        self.aprovacao = try container.decodeIfPresent(Int.self, forKey: .aprovacao)
        self.statusID = try container.decodeIfPresent(Int.self, forKey: .statusID)
        self.horaIntervalo = try container.decodeIfPresent(Int.self, forKey: .horaIntervalo)
        self.horaInicio = try container.decodeIfPresent(Int.self, forKey: .horaInicio)
        self.categoriaID = try container.decodeIfPresent(Int.self, forKey: .categoriaID)
        self.minutoIntervalo = try container.decodeIfPresent(Int.self, forKey: .minutoIntervalo)
        self.horaFim = try container.decodeIfPresent(Int.self, forKey: .horaFim)
        self.descricaoReprovacao = try container.decodeIfPresent(Int.self, forKey: .descricaoReprovacao)
        self.usuarioID = try container.decodeIfPresent(Int.self, forKey: .usuarioID)
        self.esforco = try container.decodeIfPresent(Int.self, forKey: .esforco)
    }
}
