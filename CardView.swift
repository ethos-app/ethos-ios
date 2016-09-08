import UIKit
import Darwin
import Swift


// MARK: CardViewDelegate
@objc protocol CardViewDelegate {
    /*!
     * Method called when the view will begin pan gesture
     * @param Card * Card
     */
    optional func willBeginSwipeInCard(card: CardView)
    
    /*!
     * Method called when the view did end pan gesture
     * @param Card * Card
     */
    optional func didEndSwipeInCard(card: CardView)
    
    /*!
     * Method called when the view did not reach a detected position
     * @param Card * Card
     */
    optional func didCancelSwipeInCard(card: CardView)
    
    /*!
     * Method called when the view was swiped left
     * @param Card * Card
     */
    optional func swipedLeftInCard(card: CardView)
    
    /*!
     * Method called when the view was swiped right
     * @param Card * Card
     */
    optional func swipedRightInCard(card: CardView)
    
    /*!
     * Method called when the view was swiped up
     * @param Card * Card
     */
    optional func swipedUpInCard(card: CardView)
    
    /*!
     * Method called when the view was swiped down
     * @param Card * Card
     */
    optional func swipedDownInCard(card: CardView)
    
    /*!
     * Method called when the view button was pressed
     * @param Card * Card;
     */
    optional func wasTouchedDownInCard(card: CardView)
    
    /*!
     *    Method called when the state was changed
     *
     *    @param  Card * Card;
     */
    optional func didChangeStateInCard(card: CardView)
    
    /*!
     *    Ask the delegate if the card should move
     *
     *    @param Card the card
     *
     *    @return YES if the card should move
     */
    func shouldMoveCard(card: CardView) -> Bool
}

// MARK: CardView Enums
enum CardState : Int {
    case Idle = 0, Moving, Gone
}

enum CardPosition : Int {
    case Top = 0, Back
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
    var state : CardState = .Idle
    var position : CardPosition = .Top
    
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
    private func setup() {
        // Draw Shadow
        // And round the view
        self.layer.cornerRadius = 10;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSizeMake(1,1);
        self.backgroundColor = UIColor.whiteColor()
        
        //Register Pan Gesture and Delegates
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        self.addGestureRecognizer(panRecognizer)
    }
    
    // MARK: Pan Gesture Recognizer Handlers
    @objc private func handlePanGesture(panRecognizer: UIPanGestureRecognizer) {
        
        self.xFromCenter = panRecognizer.translationInView(self).x;
        self.yFromCenter = panRecognizer.translationInView(self).y;
        
        
        let isPossibleMove = self.delegate.shouldMoveCard(self)
        
        switch(panRecognizer.state) {
        case .Began:
            self.originalPoint = self.center
            
            if isPossibleMove {
                self.delegate.willBeginSwipeInCard?(self)
            }
            break;
        case .Changed:
            
            if isPossibleMove {
                self.animateView()
            }
            break;
        case .Ended:
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
    private func animateView() {
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
        let rotateTransform = CGAffineTransformMakeRotation(rotationAngle)
        
        // scale depending on the rotation
        let scaleTransform = CGAffineTransformScale(rotateTransform, scale, scale)
        
        // apply transformations
        self.transform = scaleTransform
    }
    
    
    /*!
     * With all the values fetched
     * from the pan gesture
     * gets the direction of the swipe
     * when the swipe is done
     */
    private func detectSwipeDirection(){
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
    
    private func changeStateToIdle() {
        // Idle state indicates that the card
        // is showing in the view, but not moving.
        
        self.state = .Idle
    }
    
    private func changeStateToGone() {
        // Gone state indicates that the card
        // was removed from the view
        
        self.state = .Gone
    }
    
    private func changeStateToMoving() {
        self.state = .Moving
        
        // Cancel Swipe if Moving but not should
        if self.delegate.shouldMoveCard(self) {
            self.performCenterAnimation()
        }
    }
    
    // MARK: Animation Methods
    
    /*!
     * The view will go to the right
     */
    private func performRightAnimation() {
        
        UIView.animateWithDuration(0.3,
                                   delay: 0,
                                   options: .BeginFromCurrentState,
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
    private func performLeftAnimation() {
        
        UIView.animateWithDuration(0.3,
                                   delay: 0,
                                   options: .BeginFromCurrentState,
                                   animations: { () -> Void in
                                    self.center = self.originalPoint
        }) { (finished) -> Void in
        
            self.changeStateToIdle()
            self.delegate.swipedLeftInCard?(self)
        }
    }
    
    // Throw out card
    private func performUpAnimation() {
        let finishPoint = CGPoint(x: 2 *  self.xFromCenter + self.originalPoint.x, y: -200)
        
        UIView.animateWithDuration(0.3,
                                   delay: 0,
                                   options: .BeginFromCurrentState,
                                   animations: { () -> Void in
                                    self.center = finishPoint
                                    self.transform = CGAffineTransformMakeRotation(1.2)
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
    private func performDownAnimation() {
        print("called")
        let finishPoint = CGPoint(x: 2 *  self.xFromCenter + self.originalPoint.x, y: self.frame.height+200)

        UIView.animateWithDuration(0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 0.56,
                                   initialSpringVelocity: 0.0,
                                   options: .BeginFromCurrentState,
                                   animations: { () -> Void in
                                    self.center = finishPoint
                                    self.transform = CGAffineTransformMakeRotation(0)
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
    private func performCenterAnimation() {
        UIView.animateWithDuration(0.7,
                                   delay: 0,
                                   usingSpringWithDamping: 0.56,
                                   initialSpringVelocity: 0.0,
                                   options: .BeginFromCurrentState,
                                   animations: { () -> Void in
                                    self.center = self.originalPoint
                                    self.transform = CGAffineTransformMakeRotation(0)
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