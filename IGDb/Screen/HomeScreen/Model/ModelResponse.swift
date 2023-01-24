//
//  ModelResponse.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 15.01.2023.
//

import Foundation

struct ModelResponse: Decodable {
    let results: [APIModel]
}
