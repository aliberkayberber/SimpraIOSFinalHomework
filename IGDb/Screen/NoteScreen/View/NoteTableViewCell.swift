//
//  NoteTableViewCell.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 21.01.2023.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    
    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var noteGameName: UILabel!
    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var noteGameTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        noteImageView.layer.cornerRadius = 7.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func specialCell(_ note:Note) {
        noteGameName.text = note.gameTitle
        noteGameTitle.text = note.noteTitle
        noteTextLabel.text = note.noteDetail
        changeImage(imgUrl: note.imageURL)
    }
    private func changeImage(imgUrl: String?) {
        if let imgSized = Settings.sharedInstance.resizeImageRemote(imgUrl: imgUrl){
            guard let url = URL(string: imgSized) else {return}
            DispatchQueue.main.async {
                self.noteImageView.kf.setImage(with: url)
            }
        }
    }
}
