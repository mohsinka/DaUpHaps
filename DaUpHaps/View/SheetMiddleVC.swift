//
//  SheetMiddleVC.swift
//  DaUpHaps
//
//  Created by Apple on 27/05/2021.
//


import UIKit

enum SheetClosingType: Int {
    
    case closeWithoutDelegate = 0
    case closeWithDelegate = 1
}

protocol SheetMiddleDelegate: class {
    func sheetClosed()
    func sheetClosedForType(_ params: [String: Any])
}

class SheetMiddleVC: UIViewController , UIGestureRecognizerDelegate {
    
    private var tapOutsideRecognizer: UITapGestureRecognizer!
    var controller:UIViewController?
    weak var delegate: SheetMiddleDelegate?
    
    var type: Int = SheetClosingType.closeWithoutDelegate.rawValue
    var params: [String: Any] = [String: Any]()
    
    var dismissTap: Bool = true
    var height:CGFloat = 0
    
    @IBOutlet weak var containerMiddleView: UIView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller?.didMove(toParent: self)
        controller?.view.frame = self.containerMiddleView.bounds
        self.containerMiddleView.addSubview(controller!.view)
        constraintHeight.constant = height
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        if (self.tapOutsideRecognizer == nil) {
            self.tapOutsideRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapBehind))
            self.tapOutsideRecognizer.numberOfTapsRequired = 1
            self.tapOutsideRecognizer.cancelsTouchesInView = false
            self.tapOutsideRecognizer.delegate = self
            self.view.addGestureRecognizer(tapOutsideRecognizer)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.tapOutsideRecognizer != nil) {
            self.view.window?.removeGestureRecognizer(self.tapOutsideRecognizer)
            self.tapOutsideRecognizer = nil
        }
    }
    
    func close(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func closeWithoutAnimation() {
        
        if type == SheetClosingType.closeWithoutDelegate.rawValue {
            
            self.dismiss(animated: false, completion: nil)
        
        } else {
            
            self.dismiss(animated: false, completion: {
                
                if let del = self.delegate {
                    del.sheetClosedForType(self.params)
                }
            })
        }
        
        
    }
    
        
    // MARK: - Gesture methods to dismiss this with tap outside
    @objc func handleTapBehind(sender: UITapGestureRecognizer) {
        if dismissTap == true {
            if (sender.state == UIGestureRecognizer.State.ended) {
                let location: CGPoint = sender.location(ofTouch: 0, in: self.controller?.view)
                
                if (checkIfTapLocationIsValidForView(location: location, childView: self.controller!.view)) {
                    self.view.window?.removeGestureRecognizer(sender)
                    if let del = delegate {
                        del.sheetClosed()
                    }
                    self.close(sender: sender)
                }
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func checkIfTapLocationIsValidForView(location:CGPoint, childView:UIView) -> Bool {
        var isValid = false
        let locationX = location.x
        let locationY = location.y
        let viewWidth = childView.frame.size.width
        let viewHeight = childView.frame.size.height
        
        let isXValid = (locationX < 0 || locationX > viewWidth)
        let isYValid = (locationY < 0 || locationY > viewHeight)
        
        //Mutually exclusive check for adaptibility for container view
        //Only 1 out of 4 conditions need to be true inorder to dismiss parent
        if (isXValid || isYValid) {
            isValid = true
        }
        
        return isValid
    }
    
    
}
