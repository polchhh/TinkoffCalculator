//  Storage.swift
//  TinkoffCalculator
//
//  Created by Полина Голодаевская on 16.07.2024.
//

import Foundation

struct Calculation {
    let expression: [CalculationHistoryItem]
    let result: Double
    let date: Date
}

extension Calculation: Codable {}

extension CalculationHistoryItem: Codable {
    enum CodingKeys: String, CodingKey {
        case number
        case operation
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .number(let value):
            try container.encode(value, forKey: CodingKeys.number)
        case .operation(let value):
            try container.encode(value.rawValue, forKey: CodingKeys.operation)
        }
    }
    
    enum CalculationHistoryError: Error {
        case itemNotFound
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let number = try container.decodeIfPresent(Double.self, forKey: .number) {
            self = .number(number)
            return
        }
        
        if let rawOperation = try container.decodeIfPresent(String.self, forKey: .operation){
            let operation = Operation(rawValue: rawOperation)
            self = .operation(operation!)
            return
        }
        
        throw CalculationHistoryError.itemNotFound
    }
}

class CalculationHistoryStorage {
    static let calculationHistoryKey = "calculationHistoryKey"
    
    func setHistory(calculation: [Calculation]) {
        if let encoded =  try? JSONEncoder().encode(calculation) {
            UserDefaults.standard.set(encoded, forKey: CalculationHistoryStorage.calculationHistoryKey)
        }
    }
    
    func loadHisrory() -> [Calculation] {
        if let data = UserDefaults.standard.data(forKey: CalculationHistoryStorage.calculationHistoryKey){
            return (try? JSONDecoder().decode([Calculation].self, from: data)) ?? []
        }
        return []
    }
}

