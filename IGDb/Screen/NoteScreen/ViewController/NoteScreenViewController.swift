//
//  NoteScreenViewController.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 21.01.2023.
//

import UIKit

class NoteScreenViewController: UIViewController {
    
    private var viewModel: NoteScreenViewModelProtocol = NoteScreenViewModel()
    
    
    @IBOutlet weak var noteActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newNoteButton: UIButton!
    @IBOutlet weak var noteTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noteTableView.delegate = self
        noteTableView.dataSource = self
        noteTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteTableViewCell")
        noteTableView.rowHeight = 175
        viewModel.delegate = self
        noteActivityIndicator.startAnimating()
        viewModel.fetchNote()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(Settings.sharedInstance.isNotesChanged) {
            viewModel.fetchNote()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "NoteToDetail":
            if let note = sender as? Note {
                let goalVC = segue.destination as! NoteDetailScreenViewController
                let game = APIModel(id: Int(note.gameID), tba: nil, name: note.gameTitle, released: nil, metacritic: nil, rating: nil, parentPlatforms: nil, genres: nil, imageWide: note.imageURL)
                goalVC.delegateNoteScreen = self
                goalVC.game = game
                goalVC.note = note
            }

        default:
            return
        }
    }
    
    @IBAction func newButtonClicked(_ sender: Any) {
        //performSegue(withIdentifier: "NoteToNoteDetail", sender: nil)
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "NoteDetailVC") as! NoteDetailScreenViewController
        destinationVC.modalTransitionStyle = .crossDissolve
        destinationVC.modalPresentationStyle = .formSheet
        self.present(destinationVC, animated: true)
         
    }
    
    
    
}
extension NoteScreenViewController: NoteScreenViewModelDelegate {
    func getNotes() {
        noteActivityIndicator.stopAnimating()
        noteTableView.reloadData()
    }
}

extension NoteScreenViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.getNoteCount()
        return count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as? NoteTableViewCell,
              let obj = viewModel.getNote(at: indexPath.row)
        else {return UITableViewCell()}
        DispatchQueue.main.async {
            cell.specialCell(obj)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // present
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let note = viewModel.getNote(at: indexPath.row)
        
        let deleteConfirmAction = UIContextualAction(style: .destructive, title: "Delete"){ (contextualAction, view, bool ) in
            let alert = UIAlertController(title: "Are you sure you want to delete", message: "\(note?.noteTitle! ?? "")", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){action in
                tableView.reloadRows(at: [indexPath], with: .right)
                tableView.reloadData()
            }
            
            alert.addAction(cancelAction)
            
            let yesAction = UIAlertAction(title: "Delete", style: .destructive){action in
                self.viewModel.deleteNote(at: indexPath.row)
                tableView.reloadRows(at: [indexPath], with: .left)
                
            }
            alert.addAction(yesAction)
            // ipad Compatibility, min req ios 16
            alert.popoverPresentationController?.sourceItem = self.newNoteButton
            self.newNoteButton.isHidden = false
            self.present(alert, animated: true)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteConfirmAction])
           
            
        }
    }
    

