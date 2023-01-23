//
//  NoteDetailScreenViewController.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 18.01.2023.
//

import UIKit

class NoteDetailScreenViewController: UIViewController {

    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var gameButton: UIButton!
    
    private var viewModel: NoteDetailScreenViewModel = NoteDetailScreenViewModel()
    
    var note: Note?
    var game: APIModel?
    private var updateNote: NoteDetailModel?
    weak var delegateNoteScreen: NoteDetailScreenViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTitle.text = note?.noteTitle ?? ""
        noteTextView.text = note?.noteDetail ?? ""
    }
    
    func setGame(game: APIModel? , confirmation: Bool = true) {
        
    }

    private func saveValidator() {
        saveButton.isEnabled = false
        guard !(noteTitle.text?.isEmpty ?? true) else {return}
        guard !noteTextView.text.isEmpty else {return}
        guard noteTextView.textColor == UIColor.label else {return}
        guard game != nil else {return}
        saveButton.isEnabled = true
    }
    
    private func setUpdateNote() {
        updateNote = NoteDetailModel(gameID: Int(game?.id ?? 0) , noteDetail: noteTextView.text, noteDetailTitle: noteTitle.text, gameTitle: game?.name, imageID: getGameImageID(imgUrl: game?.imageWide), imageUrl: game?.imageWide)
    }
    
    private func getGameImageID(imgUrl: String?) -> String? {
        URL(string: imgUrl ?? "")?.lastPathComponent
    }
                                     
                                     
    @IBAction func didTitleChanged(_ sender: Any) {
        saveValidator()
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        setUpdateNote()
        if let updateNote {
            if let note {
                viewModel.editNote(obj: note, newObj: updateNote)
            }
            else {
                viewModel.newNote(obj: updateNote)
            }
            Settings.sharedInstance.isNotesChanged = true
            delegateNoteScreen?.viewWillAppear(true)
            self.dismiss(animated: true)
            
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func gameAction(_ sender: Any) {
        // to search page
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchScreenViewController
        destinationVC.modalTransitionStyle = .crossDissolve
        destinationVC.modalPresentationStyle = .formSheet
        //destinationVC.searchController = UISearchController()
        self.present(destinationVC, animated: true)
    }

}
extension NoteDetailScreenViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if noteTextView.textColor == UIColor.placeholderText {
            noteTextView.text = nil
            noteTextView.textColor = UIColor.label
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        saveValidator()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if noteTextView.text.isEmpty {
            //noteTextView.text
            noteTextView.textColor = UIColor.placeholderText
        }
    }
    
}
