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
    weak var delegateNoteScreen: NoteScreenViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
        noteTitle.text = note?.noteTitle ?? ""
        noteTextView.text = note?.noteDetail ?? ""
        setGame(game: game, confirmation: false)
        noteTextView.backgroundColor = .gray
    }
    func setGame(game: APIModel? , confirmation: Bool = true) {
        
        if let game {
            self.game = game
            gameButton.configuration = .gray()
            gameButton.configuration?.imagePadding = 5
            gameButton.setTitle(game.name, for: .normal)
            print(game)
        }
        if(confirmation) {
            saveValidator()
        }
    }

     func saveValidator() {
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
                                     
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! HomeScreenViewController
        destinationVC.sender = 1
        destinationVC.delegateDetailNote = self
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
        performSegue(withIdentifier: "NoteToHome", sender: nil)
      /*
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeScreenViewController
        destinationVC.modalTransitionStyle = .crossDissolve
        destinationVC.modalPresentationStyle = .formSheet
        destinationVC.sender = 1
        navigationController?.pushViewController(destinationVC, animated: true)
        self.present(destinationVC, animated: true)
        */
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

