//
//  GameDetailScreenViewModel.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 21.01.2023.
//

import Foundation

protocol GameDetailScreenViewModelProtocol {
    var delegate: GameDetailScreenViewModelDelegate? {get set}
    func fetchGame(_ id:Int)
    func getGameImageUrl(_ size: Int) -> URL?
    func getGameDeveloper() -> String?
    func getGameTitle() -> String?
    func getGameRate() -> Int?
    func handleFavorite() -> Bool?
    func isFavoriteGame(_ id: Int) -> Bool?
    func getGameDate() ->String? 
    
}

protocol GameDetailScreenViewModelDelegate: AnyObject {
    func gameLoaded()
}

final class GameDetailScrenViewModel: GameDetailScreenViewModelProtocol {
    weak var delegate: GameDetailScreenViewModelDelegate?
    private var game: DetailModel?
    
    func fetchGame(_ id:Int) {
        Network.getGameDetail(gameId: id) { [weak self] game, error in
            guard let self = self else {return}
            if game?.id == nil {
                // massage
            }
            self.game = game
            self.delegate?.gameLoaded()
        }
    }
    
    func getGameImageUrl(_ size: Int) -> URL? {
        return URL(string: Settings.sharedInstance.resizeImageRemote(imgUrl: game?.imageWide, size: size) ?? "")
    }
    
    func getGameDeveloper() -> String? {
        
        var developer = ""
        developer = game?.developers?[0].name ?? ""
        return developer
    }
    
    func getGameTitle() -> String? {
        return game?.name ?? ""
    }
    
    func getGameRate() -> Int? {
        
        return game?.metacritic
    }
    func getGameDate() ->String? {
        return game?.released
    }
    
    func handleFavorite() -> Bool? {
        if let gameID = game?.id {
            if let isFavorite = isFavoriteGame(gameID) {
                if isFavorite {
                    return unlikeGame()
                }
                return likeGame()
            }
            return nil
        }
        return nil
    }
    
    func isFavoriteGame(_ id: Int) -> Bool? {
        FavoriteCoreData.shared.isFavorite(id)
    }
    
    private func likeGame() -> Bool {
        if let gameID = game?.id, let imageID = URL(string: game?.imageWide ?? "")?.lastPathComponent {
            guard FavoriteCoreData.shared.setFavorite(gameId: gameID, imageId: imageID) != nil else {return !true}
            Settings.sharedInstance.isFavoriteChanged = true
            return true
        }
        return !true
    }
    private func unlikeGame() -> Bool {
        if let gameID = game?.id {
            guard FavoriteCoreData.shared.deleteFavoriteAndId(id: gameID) != nil else {return !false}
            Settings.sharedInstance.isFavoriteChanged = true
            return false
        }
        return !false
    }
}
