//
//  SearchScreenViewController.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 17.01.2023.
//

import UIKit

class SearchScreenViewController: UIViewController {

    weak var delegateDetailNote: NoteDetailScreenViewController?
    var sender: Int?
    
    private var viewModel: HomeScreenViewModelProtocol = HomeScreenViewModel()
    
    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!
    
    var searchController = UISearchController()
    
    
    @IBOutlet weak var searchText: UILabel! {
        didSet {
            searchCase(0)
        }
    }
    
    
    @IBOutlet weak var searchListTableView: UITableView! {
        didSet {

            searchListTableView.register(UINib(nibName: "SearchScreenTableViewCell", bundle: nil), forCellReuseIdentifier: "searchCell")
            searchListTableView.rowHeight = 150.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        //searchLabel.becomeFirstResponder()
        searchListTableView.delegate = self
        searchListTableView.dataSource = self
        searchIndicator.startAnimating()
        let searchController = UISearchController(searchResultsController: nil)
        //
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    private func searchCase(_ status: Int) {
        searchText.tag = status
        switch status {
        case 0:
            searchText.isHidden = false
        case 1:
            searchText.isHidden = true
            searchIndicator.startAnimating()
        case 2:
            searchText.isHidden = false
        case 3:
            searchText.isHidden = true
        default:
            searchText.isHidden = true
            searchText.text = ""
        }
    }

}

extension SearchScreenViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.getGameCount()
        if searchText.tag == 0 {
            searchCase(0)
        }
        else if count <= 0 {
            searchCase(2)
        }
        else {
            searchCase(3)
        }
        print(count)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchScreenTableViewCell,
              let model = viewModel.getGame(at: indexPath.row)
        else {
            return UITableViewCell()
        }
        DispatchQueue.main.async {
            cell.configureTableViewCell(model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      /*
        if let sender {
            switch sender {
            case 1:
                delegateDetailNote?.setGame(game: viewModel.getGame(at: indexPath.row))
                dismiss(animated: true)
            default:
                tableView.deselectRow(at: indexPath, animated: true)
            }

        }
       */
        if let gameID = viewModel.getGameId(at: indexPath.row) {
            // MARK :
            let destinationVC = storyboard?.instantiateViewController(withIdentifier: "GameDetailVC") as? GameDetailScreenViewController
            destinationVC?.gameId = gameID
            self.navigationController?.pushViewController(destinationVC!, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchScreenViewController: HomeScreenViewModelDelegate {
    func gamesLoadFinish() {
        searchListTableView.reloadData()
        print("deneme")
        searchIndicator.stopAnimating()
    }
}

extension SearchScreenViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
      guard let text = searchController.searchBar.text else {
          return
      }
      print(text)
      searchCase(1)
      viewModel.searchGames(text)
      print(text)
      self.searchListTableView.reloadData()
      self.view.endEditing(true) 
  }
}
