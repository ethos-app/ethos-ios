import UIKit
import Darwin
import Swift


// MARK: CardViewDelegate
@objc protocol CardViewDelegate {
    /*!
     * Method called when the view will begin pan gesture
     * @param Card * Card
     */
    @objc optional func willBeginSwipeInCard(_ card: CardView)
    
    /*!
     * Method called when the view did end pan gesture
     * @param Card * Card
     */
    @objc optional func didEndSwipeInCard(_ card: CardView)
    
    /*!
     * Method called when the view did not reach a detected position
     * @param Card * Card
     */
    @objc optional func didCancelSwipeInCard(_ card: CardView)
    
    /*!
     * Method called when the view was swiped left
     * @param Card * Card
     */
    @objc optional func swipedLeftInCard(_ card: CardView)
    
    /*!
     * Method called when the view was swiped right
     * @param Card * Card
     */
    @objc optional func swipedRightInCard(_ card: CardView)
    
    /*!
     * Method called when the view was swiped up
     * @param Card * Card
     */
    @objc optional func swipedUpInCard(_ card: CardView)
    
    /*!
     * Method called when the view was swiped down
     * @param Card * Card
     */
    @objc optional func swipedDownInCard(_ card: CardView)
    
    /*!
     * Method called when the view button was pressed
     * @param Card * Card;
     */
    @objc optional func wasTouchedDownInCard(_ card: CardView)
    
    /*!
     *    Method called when the state was changed
     *
     *    @param  Card * Card;
     */
    @objc optional func didChangeStateInCard(_ card: CardView)
    
    /*!
     *    Ask the delegate if the card should move
     *
     *    @param Card the card
     *
     *    @return YES if the card should move
     */
    func shouldMoveCard(_ card: CardView) -> Bool
}

// MARK: CardView Enums
enum CardState : Int {
    case idle = 0, moving, gone
}

enum CardPosition : Int {
    case top = 0, back
}

// Constants Declaration

// This constant represent the distance from the center
// where the action applies. A higher value means that
// the user needs to draw the view further in order for
// the action to be executed.
let X_ACTION_MARGIN : CGFloat = 120

// This constant is the distance from the center. But vertically
let Y_ACTION_MARGIN : CGFloat = 100

// This constant represent how quickly the view shrinks.
// The view will shrink when is beign moved out the visible
// area.
// A Higher value means slower shrinking
let SCALE_QUICKNESS = 4

// This constant represent how much the view shrinks.
// A Higher value means less shrinking
let SCALE_MAX : Float = 0.93

// This constant represent the rotation angle
let ROTATION_ANGLE = M_PI / 8

// This constant represent the maximum rotation angle
// allowed in radiands.
// A higher value enables more rotation for the view
let ROTATION_MAX : CGFloat = 1

//// This constant defines how fast
// the rotation should be.
// A higher values means a faster rotation.
let ROTATION_QUICKNESS : CGFloat = 320

// MARK: CardView
class CardView: UIView {
    
    
    // MARK: Internal Variables
    var state : CardState = .idle
    var position : CardPosition = .top
    
    var xFromCenter : CGFloat = 0
    var yFromCenter : CGFloat = 0
    var originalPoint : CGPoint = CGPoint(x: 0, y: 0)
    
    var delegate : CardViewDelegate
    
    // MARK: Init
    init(frame: CGRect, delegate: CardViewDelegate) {
        self.delegate = delegate
        
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup Method
    fileprivate func setup() {
        // Draw Shadow
        // And round the view
        self.layer.cornerRadius = 10;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSize(width: 1,height: 1);
        self.backgroundColor = UIColor.white
        
        //Register Pan Gesture and Delegates
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CardView.handlePanGesture(_:)))
        self.addGestureRecognizer(panRecognizer)
    }
    
    // MARK: Pan Gesture Recognizer Handlers
    @objc fileprivate func handlePanGesture(_ panRecognizer: UIPanGestureRecognizer) {
        
        self.xFromCenter = panRecognizer.translation(in: self).x;
        self.yFromCenter = panRecognizer.translation(in: self).y;
        
        
        let isPossibleMove = self.delegate.shouldMoveCard(self)
        
        switch(panRecognizer.state) {
        case .began:
            self.originalPoint = self.center
            
            if isPossibleMove {
                self.delegate.willBeginSwipeInCard?(self)
            }
            break;
        case .changed:
            
            if isPossibleMove {
                self.animateView()
            }
            break;
        case .ended:
            if isPossibleMove {
                self.detectSwipeDirection()
            }
            break;
        default:
            
            break;
        }
    }
    
    // MARK: Helper Methods
    
    /*!
     * Rotates the view
     * and changes its scale and position
     */
    fileprivate func animateView() {
        // Do some black magic math
        // for rotating and scale
        
        // Gets the rotation quickness
        // see constants.
        let rotationQuickness = min(self.xFromCenter / ROTATION_QUICKNESS, ROTATION_MAX)
        
        // Change the rotation in radians
        let rotationAngle = CGFloat(ROTATION_ANGLE) * rotationQuickness
        
        // the height will change when the view reaches certain point
        let scale = CGFloat(max(1 - fabsf(Float(rotationQuickness)) / Float(SCALE_QUICKNESS), SCALE_MAX))
        
        // move the object center depending on the coordinate
        self.center = CGPoint(x: self.originalPoint.x + self.xFromCenter, y: self.originalPoint.y + self.yFromCenter)
        
        // rotate by the angle
        let rotateTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        // scale depending on the rotation
        let scaleTransform = rotateTransform.scaledBy(x: scale, y: scale)
        
        // apply transformations
        self.transform = scaleTransform
    }
    
    
    /*!
     * With all the values fetched
     * from the pan gesture
     * gets the direction of the swipe
     * when the swipe is done
     */
    fileprivate func detectSwipeDirection(){
        if self.xFromCenter > X_ACTION_MARGIN {
            self.performCenterAnimation()
        }
        else if self.xFromCenter < -X_ACTION_MARGIN {
            self.performCenterAnimation()
        }
        else if self.yFromCenter < -Y_ACTION_MARGIN {
            self.performUpAnimation()
        }
        else if self.yFromCenter > Y_ACTION_MARGIN {
            self.performDownAnimation()
        }
        else {
            self.performCenterAnimation()
        }
        
        // And tell the delegate
        // that the swipe just finished
        
        self.delegate.didEndSwipeInCard?(self)
    }
    
    fileprivate func changeStateToIdle() {
        // Idle state indicates that the card
        // is showing in the view, but not moving.
        
        self.state = .idle
    }
    
    fileprivate func changeStateToGone() {
        // Gone state indicates that the card
        // was removed from the view
        
        self.state = .gone
    }
    
    fileprivate func changeStateToMoving() {
        self.state = .moving
        
        // Cancel Swipe if Moving but not should
        if self.delegate.shouldMoveCard(self) {
            self.performCenterAnimation()
        }
    }
    
    // MARK: Animation Methods
    
    /*!
     * The view will go to the right
     */
    fileprivate func performRightAnimation() {
        
        UIView.animate(withDuration: 0.3,
                                   delay: 0,
                                   options: .beginFromCurrentState,
                                   animations: { () -> Void in
                                    self.center = self.originalPoint
        }) { (finished) -> Void in
            self.changeStateToIdle()
            self.delegate.swipedRightInCard?(self)
        }
    }
    
    /*!
     * The view will got to the left
     */
    fileprivate func performLeftAnimation() {
        
        UIView.animate(withDuration: 0.3,
                                   delay: 0,
                                   options: .beginFromCurrentState,
                                   animations: { () -> Void in
                                    self.center = self.originalPoint
        }) { (finished) -> Void in
        
            self.changeStateToIdle()
            self.delegate.swipedLeftInCard?(self)
        }
    }
    
    // Throw out card
    fileprivate func performUpAnimation() {
        let finishPoint = CGPoint(x: 2 *  self.xFromCenter + self.originalPoint.x, y: -200)
        
        UIView.animate(withDuration: 0.3,
                                   delay: 0,
                                   options: .beginFromCurrentState,
                                   animations: { () -> Void in
                                    self.center = finishPoint
                                    self.transform = CGAffineTransform(rotationAngle: 1.2)
        }) { (finished) -> Void in
            self.removeFromSuperview()
            self.changeStateToGone()
            self.delegate.swipedUpInCard?(self)
        }
    }
    
    /*!
     * The view will go down
     * do not remove from view
     * just perfom some goofy moves
     */
    fileprivate func performDownAnimation() {
        print("called")
        let finishPoint = CGPoint(x: 2 *  self.xFromCenter + self.originalPoint.x, y: self.frame.height+200)

        UIView.animate(withDuration: 0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 0.56,
                                   initialSpringVelocity: 0.0,
                                   options: .beginFromCurrentState,
                                   animations: { () -> Void in
                                    self.center = finishPoint
                                    self.transform = CGAffineTransform(rotationAngle: 0)
        }) { (finished) -> Void in
            self.removeFromSuperview()
            self.changeStateToGone()
            self.delegate.swipedDownInCard?(self)
        }
    }
    
    /*!
     * The view will go to the center
     * (cancel swipe) and reset the values
     */
    fileprivate func performCenterAnimation() {
        UIView.animate(withDuration: 0.7,
                                   delay: 0,
                                   usingSpringWithDamping: 0.56,
                                   initialSpringVelocity: 0.0,
                                   options: .beginFromCurrentState,
                                   animations: { () -> Void in
                                    self.center = self.originalPoint
                                    self.transform = CGAffineTransform(rotationAngle: 0)
        }) { (finished) -> Void in
            self.changeStateToIdle()
            self.delegate.didCancelSwipeInCard?(self)
        }
    }
    
    // MARK: Programatically Swipe Methods
    func swipeLeft() {
        
 //       self.changeStateToMoving()
        
        self.performLeftAnimation()
    }
    
    func swipeRight() {
      //  self.changeStateToMoving()
        
        self.performRightAnimation()
    }
    
    func swipeUp() {
        self.performUpAnimation()
        print("UP")

    }
    
    func swipeDown() {
        print("DOWN")
        self.performDownAnimation()
    }
    
    func cancelSwipe() {
        self.performCenterAnimation()
    }
}
