//
//  HomeScreenViewController.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 15.01.2023.
//

import UIKit
import AVFoundation

class HomeScreenViewController: UIViewController {

    weak var delegateDetailNote: NoteDetailScreenViewController?
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    private var viewModel: HomeScreenViewModelProtocol = HomeScreenViewModel()
    var sender: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.delegate = self
        viewModel.fetchAllGames()
        waitingIndicator.startAnimating()
        //viewModel.fetchNewReleasedGames()
    }
    private func setupUI() {
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        homeCollectionView.register(.init(nibName: "HomeScreenCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeScreenCollectionViewCell")
    }
}

extension HomeScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let sender {
            switch sender {
            case 1:
                delegateDetailNote?.setGame(game: viewModel.getGame(at: indexPath.row))
                let desitinationVC = storyboard?.instantiateViewController(withIdentifier: "NoteDetailVC") as? NoteDetailScreenViewController
               
                desitinationVC?.game = viewModel.getGame(at: indexPath.row)
                navigationController?.pushViewController(desitinationVC!, animated: true)
                dismiss(animated: true)
            default:
                return
            }

        }
        if let gameID = viewModel.getGameId(at: indexPath.row) {
            // MARK :
            let destinationVC = storyboard?.instantiateViewController(withIdentifier: "GameDetailVC") as? GameDetailScreenViewController
            destinationVC?.gameId = gameID
            self.navigationController?.pushViewController(destinationVC!, animated: true)
        }
        /*
        let vc = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "GameDetailVC") as! GameDetailScreenViewController
        destinationVC.modalTransitionStyle = .crossDissolve
        destinationVC.modalPresentationStyle = .formSheet
        let gameId = viewModel.getGameId(at: indexPath.row)
        destinationVC.gameId = viewModel.getGameId(at: indexPath.row)
        self.present(destinationVC, animated: true)
*/
    }
}
extension HomeScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) // 2 //iki sütün için kullanılır
      return CGSize(width: itemSize, height: itemSize)
    }

}


extension HomeScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
           return CGSize(width: 200.0, height: 200.0)
        }
        return viewModel.getGameCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeScreenCollectionViewCell", for: indexPath) as! HomeScreenCollectionViewCell
        let obj = (viewModel.getGame(at: indexPath.row))!
        
        DispatchQueue.main.async {
            cell.configureCell(obj)
        }
        return cell
    }
}
extension HomeScreenViewController: HomeScreenViewModelDelegate {
    func gamesLoadFinish() {
        homeCollectionView.reloadData()
        waitingIndicator.stopAnimating()
    }
    
    
    
    
    @IBAction func homeSegmentClicked(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            
        case 0:
            viewModel.filterList(filter: sender.selectedSegmentIndex)
            print("0")
            gamesLoadFinish()
        case 1:
            viewModel.filterList(filter: sender.selectedSegmentIndex)
            print("1")
            gamesLoadFinish()
        case 2:
            viewModel.filterList(filter: sender.selectedSegmentIndex)
            print("2")
            gamesLoadFinish()
        default:
            break
        }
    }
}


