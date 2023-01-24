//
//  Settings.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 15.01.2023.
//

import Foundation

final class Settings {
    static let sharedInstance = Settings()
    private init(){}
    
    //MARK: - Settings
    var isLocalColorCalculationEnabled = true
    
    //MARK: - States
    
    var isFirstLaunch = true
    
    var isFavoriteChanged = false
    
    var isNotesChanged = false
    

    
    func backlinkHelper(id:Int?) -> String{
        if let id{
            return "https://rawg.io/games/4bc23515e37d4cefab1e78c8d44a753a"
        }
        return "https://rawg.io/games/"
    }
    
    func resizeImageRemote(imgUrl:String?, size:Int = 640) -> String?{
        return imgUrl?.replacingOccurrences(of: "media/g", with: "media/resize/\(size)/-/g")
    }
    
  
    
}
