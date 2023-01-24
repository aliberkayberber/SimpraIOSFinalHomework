//
//  HomeScreenCollectionViewCell.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 15.01.2023.
//

import UIKit
import Kingfisher
class HomeScreenCollectionViewCell: UICollectionViewCell {

    
    
    @IBOutlet weak var homeRatedLabel: UILabel!
    @IBOutlet weak var homeReleaseLabel: UILabel!
    @IBOutlet weak var homeNameLabel: UILabel!
    @IBOutlet weak var homeCellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        homeCellImageView.layer.cornerRadius = 7.5
        homeCellImageView.kf.indicatorType = .activity
        
        homeNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        homeNameLabel.textColor = .systemYellow
        homeReleaseLabel.font = .systemFont(ofSize: 15, weight: .bold)
        homeRatedLabel.font = .systemFont(ofSize: 15, weight: .bold)
    }
    func configureCell(_ game:APIModel){
        homeNameLabel.text = game.name
        homeReleaseLabel.text = game.released
        if  game.metacritic != nil {
            let gameMetacriticArr = game.metacritic?.description.components(separatedBy: "l")
            //print(gameMetacriticArr?[1] ?? "")
            
            homeRatedLabel.text = gameMetacriticArr?[0] ?? ""
           // homeRatedLabel.text = "\(game.metacritic)"
        }
        else { homeRatedLabel.text = "unknow" }
        print("\(game.metacritic)" )
        changeImage(imgUrl: game.imageWide)
    }
    private func changeImage(imgUrl:String?){
        if let imgSized = Settings.sharedInstance.resizeImageRemote(imgUrl: imgUrl){
            guard let url = URL(string: imgSized) else { return }
            DispatchQueue.main.async {
                self.homeCellImageView.kf.setImage(with: url, placeholder: nil)
            }
        }
    }

}
