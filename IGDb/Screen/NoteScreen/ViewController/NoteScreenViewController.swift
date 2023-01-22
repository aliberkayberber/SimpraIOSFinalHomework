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
    
}
