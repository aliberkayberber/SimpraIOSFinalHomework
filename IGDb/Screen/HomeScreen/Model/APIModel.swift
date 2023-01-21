//
//  APIModel.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 15.01.2023.
//

import Foundation

struct APIModel: Decodable {
    let id: Int?
    let tba: Bool?
    let name: String?
    let released: String?
    let metacritic: Int?
    let rating: EsrbRating?
    let parentPlatforms: [ParentPlatform]?
    let genres: [Genre]?
    let imageWide: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case tba
        case name
        case released
        case metacritic
        case genres
        case rating = "esrb_rating"
        case parentPlatforms = "parent_platforms"
        case imageWide = "background_image"
    }
}
