//
//  NoteDetailScreenViewModel.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 22.01.2023.
//

import Foundation

protocol NoteDetailScreenViewModelProtocol {
    var delegate: NoteDetailScreenViewModelDelegate? {get set}
    func newNote(obj: NoteDetailModel)
    func editNote(obj: Note , newObj: NoteDetailModel)
}
protocol NoteDetailScreenViewModelDelegate: AnyObject {
    func setGame()
}

final class NoteDetailScreenViewModel: NoteDetailScreenViewModelProtocol {
    var delegate: NoteDetailScreenViewModelDelegate?
    
    private var notes = [Note]()
    
    func newNote(obj: NoteDetailModel) {
        _ = NoteCoreData.shared.setNote(obj: obj)
    }
    
    func editNote(obj: Note , newObj: NoteDetailModel) {
        NoteCoreData.shared.editNote(obj: obj, newObj: newObj)
    }
}
