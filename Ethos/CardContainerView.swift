//
//  CardContainerView.swift
//  Ethos
//
//  Created by Scott Fitsimones on 9/4/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class CardContainerView: UIView, CardViewDelegate {
    
    override init (frame : CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.hexStringToUIColor("c9c9c9")
        addCard()
        addCard()
        addCard()
    }
    convenience init () {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupCards() {
        
    }

     func addCard() {
        let cardFrame = CGRect(x: 15, y: 15, width: self.frame.width-30, height: self.frame.height-30)
        let card = CardView(frame: cardFrame, delegate: self)
        self.addSubview(card)
        
    }
    
    func shouldMoveCard(_ card: CardView) -> Bool {
        return true
    }

}
