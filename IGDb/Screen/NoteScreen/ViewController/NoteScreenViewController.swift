//
//  NoteScreenViewController.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 21.01.2023.
//

import UIKit

class NoteScreenViewController: UIViewController {
    
    private var viewModel: NoteScreenViewModelProtocol = NoteScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
extension NoteScreenViewController: NoteScreenViewModelDelegate {
    func getNotes() {
        
    }
}

