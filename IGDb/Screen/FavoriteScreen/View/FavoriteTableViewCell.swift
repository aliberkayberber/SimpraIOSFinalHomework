//
//  FavoriteTableViewCell.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 19.01.2023.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var favoriteName: UILabel!
    @IBOutlet weak var favoriteDeveloper: UILabel!
    @IBOutlet weak var favoriteRelease: UILabel!
    @IBOutlet weak var favoriteRate: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteImage.layer.cornerRadius = 7.5
        
        
        favoriteImage.kf.indicatorType = .activity
        
        favoriteName.font = .systemFont(ofSize: 17, weight: .bold)
        favoriteName.textColor = .systemYellow
        favoriteRelease.font = .systemFont(ofSize: 16, weight: .bold)
        favoriteRelease.font = .systemFont(ofSize: 15, weight: .bold)
    
    }

    override func prepareForReuse() {
        favoriteImage.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }
    
    func specialCell(_ game: DetailModel) {
        favoriteName.text = game.name
        favoriteRelease.text = game.released
        //favoriteDeveloper.text =
        if game.metacritic != nil {
            let gameMetacriticArr = game.metacritic?.description.components(separatedBy: "l")
            favoriteRate.text = gameMetacriticArr?[0] ?? ""
        }
        else {
            favoriteRate.text = "unknow"
        }
        getDeveloperName(game)
        changeImage(imgUrl: game.imageWide)
    }
    
    private func getDeveloperName(_ game: DetailModel) {
        if let developer = game.developers {
           if developer.count > 0 {
                var studio = developer[0].name ?? ""
               favoriteDeveloper.text = studio
            }
        }
    }
    
    private func changeImage(imgUrl: String?) {
        if let imgSized = Settings.sharedInstance.resizeImageRemote(imgUrl: imgUrl) {
            guard let url = URL(string: imgSized) else {return}
            DispatchQueue.main.async {
                self.favoriteImage.kf.setImage(with: url)
            }
        }
    }
    
}
