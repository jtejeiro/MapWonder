//
//  MainCollectionViewCell.swift
//  MapWonder
//
//  Created by Jaime Tejeiro on 24/2/23.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var stadiumImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var identifier:String!
    
    public static func nib() -> UINib {
        return UINib(nibName: MainCollectionViewCell.name(), bundle: nil)
    }
    
    public static func name() -> String {
      return String(describing: MainCollectionViewCell.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(model: PoisAnnotation) {
        identifier = model.identifier
        titleLabel.text = model.title ?? ""
        setStadiumUrlImageView(urlString: model.urlImg ?? "" )
    }
    
}
// MARK: Private
private extension MainCollectionViewCell {
    
    func setStadiumUrlImageView(urlString:String){
        if let url: URL = URL(string: urlString) {
            self.stadiumImg.kf.setImage(with: url,
                                        placeholder: UIImage(named: "placeholderstadium"),
                                        options: [
                                            .scaleFactor(UIScreen.main.scale),
                                            .transition(.fade(1)),
                                            .cacheOriginalImage
                                        ])
            self.stadiumImg.contentMode = .scaleAspectFill
        }
    }
}
