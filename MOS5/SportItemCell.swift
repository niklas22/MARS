//
//  SportItemCell.swift
//  MOS5
//
//  Created by Niklas Mayr on 08.01.16.
//  Copyright © 2016 Niklas Mayr. All rights reserved.
//

import UIKit

class SportItemCell: UICollectionViewCell {
    
    @IBOutlet weak var symbolImage: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    
    func setColorForComponents(color: UIColor){
        valueLabel.textColor = color
        unitLabel.textColor = color
        setImageColor(color)
    }
    
    private func setImageColor(color: UIColor) {
        let tintableImage = symbolImage.image!.imageWithRenderingMode(.AlwaysTemplate)
        symbolImage.image = tintableImage
        symbolImage.tintColor = color
    }
    
    
}
