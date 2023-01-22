//
//  HomeScreenViewModel.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 15.01.2023.
//

import Foundation

protocol HomeScreenViewModelProtocol {
    var delegate: HomeScreenViewModelDelegate? { get set }
    func fetchHighRatedGames()
    func fetchNewReleasedGames()
    func fetchAllGames()
    func searchGames(_ keyword: String)
    func getGameCount() -> Int
    func getGame(at index: Int) -> APIModel?
    func getGameId(at index: Int) -> Int?
    func getReleased(at index: Int) -> String?
    func getMetacritic(at index: Int) -> Int?
    func filterList(filter:Int) 
}

protocol HomeScreenViewModelDelegate: AnyObject {
    func gamesLoadFinish()
}

final class HomeScreenViewModel: HomeScreenViewModelProtocol {
    
    weak var delegate: HomeScreenViewModelDelegate?
    private var games: [APIModel]?
    private var tempGames: [APIModel]?
    
    func fetchHighRatedGames() {
        Network.getHighRatedGames { [weak self] games, error in
            guard let data = self else {return}
            if let error{
                NotificationCenter.default.post(name: NSNotification.Name("HighRatedGamesErrorMessage"), object: error.localizedDescription)
                data.delegate?.gamesLoadFinish()
                return
            }
            data.games = games
            data.tempGames = games
            data.delegate?.gamesLoadFinish()
        }
        
    }
    
    func fetchAllGames() {
        Network.getAllGames { [weak self] games, error in
            guard let data = self else { return}
            if let error {
                NotificationCenter.default.post(name: NSNotification.Name("AllGamesErrorMessage"), object: error.localizedDescription)
                data.delegate?.gamesLoadFinish()
                return
            }
            data.games = games
            data.tempGames = games
            data.delegate?.gamesLoadFinish()
        }
    }
    
    func fetchNewReleasedGames() {
        Network.getHighRatedGames { [weak self] games, error in
            guard let data = self else {return}
            if let error {
                NotificationCenter.default.post(name: NSNotification.Name("NewReleasedGamesErrorMassage"), object: error.localizedDescription)
                                                data.delegate?.gamesLoadFinish()
                                                return
            }
                                                data.games = games
                                                data.tempGames = games
                                                data.delegate?.gamesLoadFinish()
            
        }
    }
    
    func searchGames(_ keyword: String) {
        Network.searchGames(gameName: keyword) { [weak self] games, error in
            guard let data = self else { return
            }
            if let error{
                NotificationCenter.default.post(name: NSNotification.Name("searchGamesErrorMessage"), object: error.localizedDescription)
                data.delegate?.gamesLoadFinish()
                print("error")
                return
            }
            data.games = games
            data.tempGames = games
            data.delegate?.gamesLoadFinish()
            print(data.games)
        }
    }
    func filterList(filter:Int) {
        switch filter {
        case 0 :
            self.games = self.tempGames
            print("0")
        case 1:
            games = tempGames?.sorted{$0.metacritic ?? 0 > $1.metacritic ?? 0}
            print("1")
        case 2:
            games = tempGames?.sorted{$0.released ?? "9" < $1.released ?? "9"}
            print("2")
        default:
            break
        }
        delegate?.gamesLoadFinish()
    }

    
    func getGameCount() -> Int {
        games?.count ?? 0
    }
    
    func getGame(at index: Int) -> APIModel? {
        games?[index]
    }
    
    func getGameId(at index: Int) -> Int? {
        games?[index].id
    }
    func getReleased(at index: Int) -> String? {
        games?[index].released
    }
    func getMetacritic(at index: Int) -> Int? {
        games?[index].metacritic
    }
}
