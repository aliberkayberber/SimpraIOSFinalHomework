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
        
    }

    override func prepareForReuse() {
        favoriteImage.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }
    
    
    
    
}
