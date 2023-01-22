//
//  FavoriteScreenViewController.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 21.01.2023.
//

import UIKit

class FavoriteScreenViewController: UIViewController {

    
    @IBOutlet weak var favActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var favTableView: UITableView!

    private var viewModel: FavoriteScreenViewModelProtocol = FavoriteScreenViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        favTableView.delegate = self
        favTableView.dataSource = self
        favTableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteTableViewCell")
        favTableView.rowHeight = 175.0
        viewModel.delegate = self
        favActivityIndicator.startAnimating()
        viewModel.getFavoriteGame()
        Settings.sharedInstance.isFavoriteChanged = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Settings.sharedInstance.isFavoriteChanged {
            favActivityIndicator.startAnimating()
            viewModel.getFavoriteGame()
        }
    }
   


}

extension FavoriteScreenViewController: FavoriteScreenViewModelDelegate {
    func gettedFavorite() {
        favTableView.reloadData()
        favActivityIndicator.stopAnimating()
        
    }
}

extension FavoriteScreenViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        count = viewModel.getGameCount()
        return count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"FavoriteTableViewCell" , for: indexPath) as? FavoriteTableViewCell,
                let data = viewModel.getGameName(at: indexPath.row)
        else {return UITableViewCell()}
        DispatchQueue.main.async {
            cell.specialCell(data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // present
    }
    
  /*
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //
    }
   */
}
