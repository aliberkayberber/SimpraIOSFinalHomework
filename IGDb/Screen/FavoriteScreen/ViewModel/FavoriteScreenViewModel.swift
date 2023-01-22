//
//  FavoriteScreenViewModel.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 21.01.2023.
//

import Foundation

protocol FavoriteScreenViewModelProtocol {
    var delegate: FavoriteScreenViewModelDelegate? { get set}
    func getFavoriteGame()
    func getGameName(at index: Int) -> DetailModel?
    func getGameCount() -> Int
    func getGameId(at index: Int) -> Int?
    func getGameImageId(at index : Int) -> String?
    func removeGame(at index: Int)
}

protocol FavoriteScreenViewModelDelegate: AnyObject {
    func gettedFavorite()
}

final class FavoriteScreenViewModel: FavoriteScreenViewModelProtocol {
    var delegate: FavoriteScreenViewModelDelegate?
    private var favorite = [Favorite]()
    private var game: [DetailModel]?
    
    
    // core data code will here
    func getFavoriteGame() {
        Settings.sharedInstance.isFavoriteChanged = false
        game = [DetailModel]()
        favorite = FavoriteCoreData.shared.getFavorite()
        favorite = favorite.reversed()
        var queue = favorite.count
        if favorite.count <= 0 {
            delegate?.gettedFavorite()
            return
        }
        for n in favorite.enumerated() {
            game?.append(DetailModel(id: Int(n.element.gameID)))
            Network.getGameDetail(gameId: Int(n.element.gameID)) { [weak self]game, error in
                guard let self = self else {return}
                if let game {
                    if game.id == nil {
                        self.favorite.removeAll()
                        // MARK: error massage
                    }
                    self.game?[n.offset] = game
                    queue -= 1
                    if(queue <= 0) {
                        self.delegate?.gettedFavorite()
                    }
                }
            }
        }
    }
    
    
    func getGameName(at index: Int) -> DetailModel? {
        game?[index]
    }
    
    func getGameCount() -> Int {
        game?.count ?? 0
    }
    
    func getGameId(at index: Int) -> Int? {
        game?[index].id
    }
    
    func getGameImageId(at index : Int) -> String? {
        URL(string: game?[index].imageWide ?? "")?.lastPathComponent
    }
    
    // will be core data remove
    func removeGame(at index: Int) {
        
    }
}


