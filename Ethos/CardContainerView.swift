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
        self.backgroundColor = UIColor.hexStringToUIColor("e9e9e9")
        addCard()
        addCard()
        addCard()
    }
    convenience init () {
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupCards() {
        
    }

     func addCard() {
        let cardFrame = CGRectMake(15, 15, self.frame.width-30, self.frame.height-30)
        let card = CardView(frame: cardFrame, delegate: self)
        self.addSubview(card)
        
    }
    
    func shouldMoveCard(card: CardView) -> Bool {
        return true
    }

}
