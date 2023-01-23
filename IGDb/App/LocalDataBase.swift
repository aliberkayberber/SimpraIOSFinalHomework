//
//  LocalDataBase.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 21.01.2023.
//

import UIKit
import CoreData

final class FavoriteCoreData {
    
    private var managedContext: NSManagedObjectContext! = nil
    static let shared = FavoriteCoreData()
    
    private init() {
        let appDelagate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelagate.persistentContainer.viewContext
    }
    
    func setFavorite(gameId: Int , imageId: String) -> Bool? {
        let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext)!
        let game = NSManagedObject(entity: entity, insertInto: managedContext)
        game.setValue(gameId, forKey: "gameID")
        game.setValue(imageId, forKey: "imageID")
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            
            
            // error alert
            return nil
        }
    }
    
    func getFavorite() -> [Favorite] {
        let getFavorites = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        do {
            let game = try managedContext.fetch(getFavorites)
            return game as! [Favorite]
            
        } catch let error as NSError {
            return []
        }
    }
    
    func editFavorite(obj: Favorite, imageId: String) {
        let game = managedContext.object(with: obj.objectID)
        game.setValue(imageId, forKey: "imageID")
        do {
            try managedContext.save()
        } catch let error as NSError {
            //MARK: error
        }
    }
    
    func deleteFavorite(game: Favorite) {
        managedContext.delete(game)
        do {
            try managedContext.save()
        } catch let error as NSError {
            //MARK: error
        }
    }
    
    func isFavorite(_ id:Int) -> Bool? {
        let fetchRequest: NSFetchRequest<Favorite>
        fetchRequest = Favorite.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "gameID = %d", id)
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            if objects.count > 0 {
                return true
            }
            return false
        } catch let error as NSError {
            return nil
        }
        
    }
    
    func deleteFavoriteAndId(id: Int) -> Bool? {
        let getRequest: NSFetchRequest<Favorite>
        getRequest = Favorite.fetchRequest()
        
        getRequest.predicate = NSPredicate(format: "gameID = %d", id)
        do {
            let data = try managedContext.fetch(getRequest)
            for game in data {
                deleteFavorite(game: game)
            }
            return false
        } catch let error as NSError {
            // MARK: error
            return nil
        }
    }
    
    func trueFavorite(_ id: Int) -> Bool? {
        let getRequest: NSFetchRequest<Favorite>
        getRequest = Favorite.fetchRequest()
        getRequest.predicate = NSPredicate(format: "gameID", id)
        do {
            let data = try managedContext.fetch(getRequest)
            if data.count > 0 {
                return true
            }
            return false
        } catch let error as NSError {
            // MARK: Erorr
            return nil
        }
    }
    
    
}
final class NoteCoreData {
    static let shared = NoteCoreData()
    private let managedContext: NSManagedObjectContext!
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func setNote(obj: NoteDetailModel) -> Note? {
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)!
        let note = NSManagedObject(entity: entity, insertInto: managedContext)
        note.setValue(obj.gameID, forKey: "gameID")
        note.setValue(obj.gameTitle, forKey: "gameTitle")
        note.setValue(obj.noteDetail, forKey: "noteDetail")
        note.setValue(obj.noteDetailTitle, forKey: "noteTitle")
        note.setValue(obj.imageID, forKey: "imageID")
        note.setValue(obj.imageUrl, forKey: "imageURL")
        
        do {
            try managedContext.save()
            return note as? Note
        } catch let error as NSError {
            //MARK: error
        }
        return nil
    }
    
    func getNote() -> [Note] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        do {
            let notes = try managedContext.fetch(fetchRequest)
            return notes as! [Note]
        } catch let error as NSError {
            //MARK: error
        }
        return[]
    }
    
    func delegateNote(note: Note) {
        managedContext.delete(note)
        do {
            try managedContext.save()
        } catch let error as NSError {
            //MARK: error
        
        }
    }
    
    func editNote(obj: Note , newObj: NoteDetailModel) {
        let note = managedContext.object(with: obj.objectID)
        note.setValue(newObj.gameID, forKey: "gameID")
        note.setValue(newObj.gameTitle, forKey: "gameTitle")
        note.setValue(newObj.noteDetail, forKey: "noteDetail")
        note.setValue(newObj.noteDetailTitle, forKey: "noteTitle")
        note.setValue(newObj.imageID, forKey: "imageID")
        note.setValue(newObj.imageUrl, forKey: "imageURL")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            //MARK: error
        }
    }
}
