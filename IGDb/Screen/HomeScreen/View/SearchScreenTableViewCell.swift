//
//  SearchScreenTableViewCell.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 17.01.2023.
//

import UIKit
import Kingfisher

class SearchScreenTableViewCell: UITableViewCell {

    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchNameLabel: UILabel!
    @IBOutlet weak var searchReleaseLabel: UILabel!
    @IBOutlet weak var searchRateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchImageView.layer.cornerRadius = 8
        searchImageView.kf.indicatorType = .activity
        
        searchNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        searchNameLabel.textColor = .systemYellow
        searchReleaseLabel.font = .systemFont(ofSize: 16, weight: .bold)
        searchRateLabel.font = .systemFont(ofSize: 15, weight: .bold)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        searchImageView.image = nil
    }
    
    func configureTableViewCell(_ game: APIModel) {
        searchNameLabel.text = game.name
        searchReleaseLabel.text = game.released
        if game.metacritic != nil {
            let gameMetacriticArr = game.metacritic?.description.components(separatedBy: "l")
            searchRateLabel.text = gameMetacriticArr?[0] ?? ""
        }
        else {
            searchRateLabel.text = "unknow"
        }
        changeImage(imgUrl: game.imageWide)
    }
    
    private func changeImage(imgUrl: String?) {
        if let imageSized = Settings.sharedInstance.resizeImageRemote(imgUrl: imgUrl){
            guard let url = URL(string: imageSized) else { return }
            DispatchQueue.main.async {
                self.searchImageView.kf.setImage(with: url, placeholder: nil)
            }
        }

    }
}
