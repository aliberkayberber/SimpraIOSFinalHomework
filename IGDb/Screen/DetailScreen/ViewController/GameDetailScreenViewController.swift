//
//  GameDetailScreenViewController.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 22.01.2023.
//

import UIKit
import UIImageColors

class GameDetailScreenViewController: UIViewController {

    

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameDeveloperName: UILabel!
    @IBOutlet weak var gameDateLabel: UILabel!
    @IBOutlet weak var gameRateLabel: UILabel!
    @IBOutlet weak var gameDetailView: UITextView!
    
    var gameId: Int?
    var delegateFavorite: FavoriteScreenViewController?
    private var viewModel: GameDetailScreenViewModelProtocol = GameDetailScrenViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let id = gameId else {return}
        // transfer data
        
        gameImageView.layer.cornerRadius = 7.5
        viewModel.delegate = self
        viewModel.fetchGame(id)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            if Settings.sharedInstance.isFavoriteChanged {
                delegateFavorite?.viewWillAppear(true)
            }
        }
    }
    
    @IBAction func pressedFav(_ sender: Any) {
        //
        favoriteHandler(status: viewModel.handleFavorite())
    }
    
    private func favoriteHandler(status: Bool?) {
        if let status {
            if status {
                favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                favButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            favButton.isHidden = false
            return
        }
        favButton.isHidden = true
        return
    }
    
    private func colorPage() {
        background.isHidden = false
        DispatchQueue.main.async {
            self .gameImageView.image?.getColors(quality: .lowest) {
                colors in UIView.transition(with: self.view, duration: 0.25, options: .transitionCrossDissolve) {
                    self.gameRateLabel.textColor = colors?.detail
                    self.gameDetailView.textColor = colors?.detail
                    self.gameDateLabel.textColor = .white
                    self.gameNameLabel.textColor = colors?.secondary
                    self.gameDeveloperName.textColor = colors?.secondary
                    
                    //self.view.backgroundColor = colors?.background
                }
            }
        }
    }
    
    
}

extension GameDetailScreenViewController: GameDetailScreenViewModelDelegate {
    func gameLoaded() {
        if let id = self.gameId {
            self.favoriteHandler(status: self.viewModel.isFavoriteGame(id))
        }
        self.gameNameLabel.text = self.viewModel.getGameTitle()
        self.gameDeveloperName.text = self.viewModel.getGameDeveloper()
        self.gameDetailView.text = self.viewModel.getGameDetail()
        //self.gameRateLabel.text = self.viewModel.getGameRate()
        if self.viewModel.getGameRate() != nil {
            let gameMetacriticArr = self.viewModel.getGameRate()?.description.components(separatedBy: "l")
            gameRateLabel.text = gameMetacriticArr?[0] ?? ""
        }
        else {
            gameRateLabel.text = "unknow"
        }
        self.gameDateLabel.text = self.viewModel.getGameDate()
        self.gameImageView.kf.indicatorType = .activity
        self .gameImageView.kf.setImage(with: self.viewModel.getGameImageUrl(640)) {_ in
            if(Settings.sharedInstance.isLocalColorCalculationEnabled){
                self.colorPage()
            }
        }
        
    }
}

