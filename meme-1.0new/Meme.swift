//
//  Meme.swift
//  meme-1.0new
//
//  Created by Nitish on 29/10/16.
//  Copyright © 2016 Nitish. All rights reserved.
//

import Foundation
import UIKit

struct Meme{
    let topText:String
    let bottomText:String
    let image: UIImage
    let memedImage: UIImage
    
    init(topText: String, bottomText:String,image:UIImage,memedImage:UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}
