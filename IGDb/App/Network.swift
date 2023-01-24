//
//  Network.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 15.01.2023.
//

import Foundation
import Alamofire

final class Network {
    static let BASE_URL = "https://rawg.io/api/games"
    static let API_URL = "https://api.rawg.io/api/games"
    // en yüksek oy https://rawg.io/api/games/lists/main?discover=true&ordering=-rating&page_size=40&page=1&key=4bc23515e37d4cefab1e78c8d44a753a
    // all https://rawg.io/api/games/lists/main?discover=true&page_size=40&page=1&key=4bc23515e37d4cefab1e78c8d44a753a
    // en yeni https://rawg.io/api/games/lists/main?discover=true&ordering=-updated&page_size=40&page=1&key=4bc23515e37d4cefab1e78c8d44a753a
    static func getHighRatedGames(completion: @escaping ([APIModel]?, Error?) -> Void) {
        let urlString = BASE_URL + "/lists/main?discover=true&ordering=-rating&page_size=40&page=1&key=4bc23515e37d4cefab1e78c8d44a753a"
        // /lists/main?discover=true&ordering=-relevance&page_size=40&page=1
        ///lists/main?discover=true&ordering=-rating&page_size=40&page=1
        handleResponse(urlString: urlString, responseType: ModelResponse.self) { responseModel, error in
            completion(responseModel?.results, error)
        }
    }
    
    static func getAllGames(completion: @escaping ([APIModel]?, Error?) -> Void) {
        let urlString = BASE_URL + "/lists/main?discover=true&page_size=40&page=1&key=4bc23515e37d4cefab1e78c8d44a753a"
        handleResponse(urlString: urlString, responseType: ModelResponse.self) { responseModel, error in
            completion(responseModel?.results, error)
        }
    }
    
    static func getNewReleasedGames(completion: @escaping ([APIModel]?, Error?) -> Void) {
        let urlString = BASE_URL + "/lists/main?discover=true&ordering=-updated&page_size=40&page=1&key=4bc23515e37d4cefab1e78c8d44a753a"
        handleResponse(urlString: urlString, responseType: ModelResponse.self) { responseModel, error in
            completion(responseModel?.results, error)
        }
    }
    
    static func searchGames(gameName:String, completion: @escaping ([APIModel]?, Error?) -> Void) {
        let encodedString = gameName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "*"
        let urlString = API_URL + "?search_precise=true&search=" + encodedString + "&key=4bc23515e37d4cefab1e78c8d44a753a"
        handleResponse(urlString: urlString, responseType: ModelResponse.self) { responseModel, error in
            completion(responseModel?.results, error)
        }
        print(encodedString)
    }
    
    
    static func getGameDetail(gameId: Int, completion: @escaping (DetailModel?, Error?) -> Void) {
        let urlString = API_URL + "/" + String(gameId) + "?key=4bc23515e37d4cefab1e78c8d44a753a"
        handleResponse(urlString: urlString, responseType: DetailModel.self, completion: completion)
    }
    
    static private func handleResponse<T: Decodable>(urlString: String, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) {
        AF.request(urlString).response { response in
            guard let data = response.value else {
                DispatchQueue.main.async {
                    completion(nil, response.error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(T.self, from: data!)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            // TODO: add alert
            catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
}
