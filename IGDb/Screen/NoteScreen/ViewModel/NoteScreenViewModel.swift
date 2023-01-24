//
//  NoteScreenViewModel.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 21.01.2023.
//

import Foundation

protocol NoteScreenViewModelProtocol {
    var delegate: NoteScreenViewModelDelegate? {get set}
    func fetchNote()
    func getNoteCount() -> Int?
    func getNote(at index: Int) -> Note?
    func editNote(obj: Note, newObj: NoteDetailModel)
    func deleteNote(at index: Int)
    func getGameID(at index:Int) -> Int?
    func getGameImageID(at index: Int) -> String?
}
protocol NoteScreenViewModelDelegate: AnyObject {
    func getNotes()
}

final class NoteScreenViewModel: NoteScreenViewModelProtocol {
    weak var delegate: NoteScreenViewModelDelegate?
    private var note = [Note]()
    
    func fetchNote() {
        Settings.sharedInstance.isNotesChanged = false
        note = NoteCoreData.shared.getNote()
        note = note.reversed()
        delegate?.getNotes()
        
    }
    
    func getNoteCount() -> Int? {
        note.count ?? 0
    }
    
    func getNote(at index: Int) -> Note? {
        if index > note.count - 1 {
            return nil
        }
        return note[index]
    }
    
    func editNote(obj: Note, newObj: NoteDetailModel) {
        NoteCoreData.shared.editNote(obj: obj, newObj: newObj)
    }
    
    func deleteNote(at index: Int) {
        NoteCoreData.shared.delegateNote(note: note[index])
        note.remove(at: index)
        delegate?.getNotes()
    }
    
    func getGameID(at index:Int) -> Int? {
        if index > note.count - 1 {
            return nil
        }
        return Int(note[index].gameID)
    }
    
    func getGameImageID(at index: Int) -> String? {
     if   index > note.count - 1 {
            return nil
        }
        return note[index].imageID
    }
}
