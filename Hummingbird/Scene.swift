//
//  Scenes.swift
//  Hummingbird
//
//  Created by Adam on 4/10/18.
//  Copyright © 2018 Adam. All rights reserved.
//

import Foundation
import UIKit

class BackgroundImageView : UIImageView {
	
	static var count : Int = 0
	
	override var description: String {
		//BackgroundImageView.count += 1
		return "\(self.tagString) : \(BackgroundImageView.count)"
	}
	
	var scene : Scene!
	
	var tagString : String!
	
	init(frame: CGRect, withinScene scene : Scene, withTag tag : String) {
		self.scene = scene
		self.tagString = tag
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override var center: CGPoint {
		didSet {
			if (self.center.x <= (-self.frame.size.width / 2)) {
				resetFrame()
			}
		}
	}
	
	func resetFrame() {
		let maxY : CGFloat = self.scene.objectsFrame.height - (self.scene.objectFrame.height / 2)
		let ry : CGFloat = CGFloat(arc4random_uniform(UInt32(maxY)))
		self.center.x = self.scene.objectsFrame.size.width + self.frame.size.width
		self.center.y = ry
		if let _ = self.scene.animator {
			self.scene.animator!.updateItem(usingCurrentState: self)
		}
	}
}

protocol SceneDelegate {
	func onHomePressed()
}

extension SceneDelegate {
	func onHomePressed() {
		
	}
}

class Scene : NSObject, UIDynamicAnimatorDelegate {
	
	static let ButtonHeight : CGFloat = 40.0
	static let ButtonWidth : CGFloat = 60.0
	static let ObjectNumber : Int = 7
	static let ObjectFraction : CGFloat = 0.25
	
	var tag : String
	
	var homeButton : BackgroundImageView?
	var sunMoonImageView : UIImageView?
	var lowerLeftImageView : UIImageView?
	var lowerRightImageView : UIImageView?
	
	var delegate : SceneDelegate?
	
	var animatedViews : [UIView] = [UIView]()
	var objectsFrame : CGRect!
	var objectFrame : CGRect!
	
	var animator : UIDynamicAnimator?
	var gravity : UIGravityBehavior?
	
	var mainView : UIView!
	
	override init() {
		self.tag = "virtual"
		super.init()
	}
	
	static func == (lhs: Scene, rhs: Scene) -> Bool {
		if lhs.tag == rhs.tag {
			return true
		}
		return false
	}
	
	func configureView(_ view : UIView) {
		self.objectsFrame = CGRect.init()
		let frameHeight = Ratios.SceneRatio * view.frame.size.height - view.safeAreaInsets.bottom
		objectsFrame.origin.y = 0
		objectsFrame.origin.x = 0
		objectsFrame.size.width = view.frame.size.width
		objectsFrame.size.height = frameHeight
	}
	
	func configureView(_ view : UIView, withObjectRatio objectRatio : CGFloat) {
		let fractionWidth : CGFloat = Scene.ObjectFraction * objectsFrame.size.width
		self.objectFrame = CGRect.init(x: 0, y: 0, width: fractionWidth, height: objectRatio * fractionWidth)
	}
	
	func configureView(_ view : UIView, withImage image : UIImage) {
		
		let maxX : CGFloat = self.objectsFrame.width - self.objectFrame.width
		let maxY : CGFloat = self.objectsFrame.height - self.objectFrame.height
		for _ in 1...Scene.ObjectNumber {
			let rx : CGFloat = CGFloat(arc4random_uniform(UInt32(maxX)))
			let ry : CGFloat = CGFloat(arc4random_uniform(UInt32(maxY)))
			let imageView : BackgroundImageView = BackgroundImageView.init(frame: CGRect.init(x: rx, y: ry, width: self.objectFrame.size.width, height: self.objectFrame.size.height), withinScene : self, withTag : "Star/Cloud")
			imageView.image = image
			view.addSubview(imageView)
			self.animatedViews.append(imageView)
		}
		
		let mainWidth = view.frame.size.width * Ratios.MainViewRatio
		let mainHeight = mainWidth * Images.PhilipHWRatio
		let mainY = (self.objectsFrame.size.height / 2) - (mainHeight / 2)
		let mainX = (self.objectsFrame.size.width / 2) - (mainWidth / 2)
		let mainFrame : CGRect = CGRect.init(x: mainX, y: mainY, width: mainWidth, height: mainHeight)
		self.mainView = UIImageView.init(frame: mainFrame)
		(self.mainView as! UIImageView).image = Images.PhilipImage
		view.addSubview(self.mainView)
	}
	
	func configureView(_ view : UIView, withHomeImage image : UIImage) {
		let bx : CGFloat = view.frame.size.width - self.objectFrame.size.width
		let by : CGFloat = view.safeAreaInsets.top
		self.homeButton = BackgroundImageView.init(frame: CGRect.init(x: bx, y: by, width: self.objectFrame.size.width, height: self.objectFrame.size.height), withinScene : self, withTag : "Home")
		self.homeButton!.image = image
		self.homeButton!.isUserInteractionEnabled = true
		self.homeButton!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(buttonAction(sender:))))
		view.addSubview(self.homeButton!)
	}
	
	func configureView(_ view: UIView, withSunMoonImage sunMoonImage : UIImage) {
		let sunMoonWidth = view.frame.size.width * Ratios.SunMoonRatio
		let sunMoonHeight = sunMoonWidth * Images.SunHWRatio
		let sunMoonFrame : CGRect = CGRect.init(x: 0.0, y: 0.0, width: sunMoonWidth, height: sunMoonHeight)
		self.sunMoonImageView = UIImageView.init(frame: sunMoonFrame)
		self.sunMoonImageView?.image = sunMoonImage
		view.addSubview(self.sunMoonImageView!)
	}
	
	@objc func buttonAction(sender: UIButton!) {
		delegate?.onHomePressed()
	}
	
	func addAnimationsInView(_ view : UIView) {
		if let _ = self.homeButton {
			self.animatedViews.append(self.homeButton!)
		}
		self.animator = UIDynamicAnimator.init(referenceView: view)
		self.animator?.delegate = self
		self.gravity = UIGravityBehavior.init(items: self.animatedViews)
		self.gravity!.gravityDirection = CGVector.init(dx: -0.008, dy: 0.0)
		self.animator!.addBehavior(self.gravity!)
		
		addHoverToView(self.mainView, withDuration: 0.9)
	}
	
	func addHoverToView(_ view : UIView, withDuration duration : CFTimeInterval) {
		let hover = CABasicAnimation(keyPath: "position")
		
		hover.isAdditive = true
		hover.fromValue = NSValue(cgPoint: CGPoint.zero)
		hover.toValue = NSValue(cgPoint: CGPoint(x: 0.0, y: 50.0))
		hover.autoreverses = true
		hover.duration = duration
		hover.repeatCount = Float.infinity
		
		view.layer.add(hover, forKey: "hover")
	}
	
	func shakeView(_ view : UIView, withDuration duration : CFTimeInterval) {
		let animation = CABasicAnimation(keyPath: "position")
		animation.duration = duration
		animation.repeatCount = 4
		animation.autoreverses = true
		animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 20, y: view.center.y))
		animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 20, y: view.center.y))
		view.layer.add(animation, forKey: "position")
	}
	
	func addLowerLeftImage(_ image : UIImage, withRatio ratio : CGFloat, inView view : UIView) {
		let lWidth = objectsFrame.size.width * Ratios.LowerLeftRatio
		let lHeight : CGFloat = lWidth * ratio
		let lx : CGFloat = 0.0
		let ly : CGFloat = self.objectsFrame.maxY - lHeight
		let lFrame : CGRect = CGRect.init(x: lx, y: ly, width: lWidth, height: lHeight)
		self.lowerLeftImageView = UIImageView.init(frame: lFrame)
		self.lowerLeftImageView?.image = image
		self.lowerLeftImageView!.isUserInteractionEnabled = true
		view.addSubview(self.lowerLeftImageView!)
	}
	
	func addLowerRightImage(_ image : UIImage, withRatio ratio : CGFloat, inView view : UIView) {
		let lWidth = objectsFrame.size.width * Ratios.LowerRightRatio
		let lHeight : CGFloat = lWidth * ratio
		let lx : CGFloat = self.objectsFrame.maxX - lWidth
		let ly : CGFloat = self.objectsFrame.maxY - lHeight
		let lFrame : CGRect = CGRect.init(x: lx, y: ly, width: lWidth, height: lHeight)
		self.lowerRightImageView = UIImageView.init(frame: lFrame)
		self.lowerRightImageView?.image = image
		self.lowerRightImageView!.isUserInteractionEnabled = true
		view.addSubview(self.lowerRightImageView!)
	}
	
	func removeAnimations() {
		self.animator?.removeAllBehaviors()
	}
	
	func sceneWillDisappear() {
		self.animatedViews = [UIView]()
		self.removeAnimations()
	}
	
	//UIDynamicAnimatorDelegate
	
	public func dynamicAnimatorWillResume(_ animator: UIDynamicAnimator) {
		//print("RESUME")
	}
	
	public func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
		//print("PAUSE")
	}
	
}

class Day : Scene {
	
	override init() {
		super.init()
		self.tag = "day"
	}

	override func configureView(_ view : UIView) {
		super.configureView(view)
		super.configureView(view, withObjectRatio: Images.CloudHWRatio)
		view.backgroundColor = Colors.SwansDown
		super.configureView(view, withSunMoonImage: Images.SunImage)
		super.configureView(view, withImage: Images.CloudImage)
	}
}

class DayPage : Day {
	override init() {
		super.init()
		self.tag = "day_page"
	}
	
	override func configureView(_ view: UIView) {
		super.configureView(view)
		super.configureView(view, withHomeImage: Images.CloudHomeImage)
		super.addAnimationsInView(view)
		view.bringSubview(toFront: self.mainView)
	}
}

class FirstDayPage : DayPage
{
	override init() {
		super.init()
		self.tag = "first_day_page"
	}
	
	override func configureView(_ view: UIView) {
		super.configureView(view)
		super.addLowerLeftImage(Images.TextBubbleImage, withRatio: Images.TextBubbleHWRatio, inView: view)
		view.bringSubview(toFront: self.mainView)
		self.lowerLeftImageView!.isUserInteractionEnabled = true
		self.lowerLeftImageView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bubbleAnimation)))
	}
	
	@objc func bubbleAnimation() {
		let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform")
		animation.duration = 1.25
		animation.repeatCount = 0
		animation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.75, 1.75, 1.75))
		self.lowerLeftImageView!.layer.add(animation, forKey: "transform")
	}
}

class SecondDayPage : DayPage
{
	override init() {
		super.init()
		self.tag = "second_day_page"
	}
	
	override func configureView(_ view: UIView) {
		super.configureView(view)
		super.addLowerRightImage(Images.HummingbirdsImage, withRatio: Images.HummingbirdsHWRatio, inView: view)
		self.addHoverToView(self.lowerRightImageView!, withDuration: 1.4)
		view.bringSubview(toFront: self.mainView)
		super.addLowerLeftImage(Images.BranchImage, withRatio: Images.BranchHWRatio, inView: view)
		
		let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(onBirdsTap))
		view.addGestureRecognizer(tapGesture)
	}
	
	@objc func onBirdsTap() {
		super.shakeView(self.lowerRightImageView!, withDuration: 0.07)
	}
}

class ThirdDayPage : DayPage {
	override init() {
		super.init()
		self.tag = "third_day_page"
	}
	
	override func configureView(_ view: UIView) {
		super.configureView(view)
		super.addLowerRightImage(Images.HummingbirdsImage, withRatio: Images.HummingbirdsHWRatio, inView: view)
		self.addHoverToView(self.lowerRightImageView!, withDuration: 1.4)
		view.bringSubview(toFront: self.mainView)
		super.addLowerLeftImage(Images.BranchImage, withRatio: Images.BranchHWRatio, inView: view)
		let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(onBirdsTap))
		view.addGestureRecognizer(tapGesture)
	}
	
	@objc func onBirdsTap() {
		super.shakeView(self.lowerRightImageView!, withDuration: 0.07)
	}
}

class FourthDayPage : DayPage {
	override init() {
		super.init()
		self.tag = "fourth_day_page"
	}
	
	override func configureView(_ view: UIView) {
		super.configureView(view)
		super.addLowerRightImage(Images.BirdBathImage, withRatio: Images.BirdBathHWRatio, inView: view)
		super.addLowerLeftImage(Images.OtherBranchImage, withRatio: Images.OtherBranchHWRatio, inView: view)
		view.bringSubview(toFront: self.mainView)
		self.lowerRightImageView!.frame.origin.y = self.lowerRightImageView!.frame.origin.y + (Padding.Sixteen * 4)
	}
}

class Night : Scene {
	
	override init() {
		super.init()
		self.tag = "night"
	}
	
	override func configureView(_ view : UIView) {
		super.configureView(view)
		super.configureView(view, withObjectRatio: Images.StarHWRatio)
		view.backgroundColor = Colors.Bunker
		super.configureView(view, withSunMoonImage: Images.MoonImage)
		super.configureView(view, withImage: Images.StarImage)
		view.bringSubview(toFront: self.sunMoonImageView!)
	}
}

class NightPage : Night {
	
	override init() {
		super.init()
		self.tag = "night_page"
	}
	
	override func configureView(_ view : UIView) {
		super.configureView(view)
		super.configureView(view, withHomeImage: Images.StarHomeImage);
		super.addAnimationsInView(view)
		view.bringSubview(toFront: self.mainView)
		view.bringSubview(toFront: self.sunMoonImageView!) //bring moon to front
	}
}

class FirstNightPage : NightPage
{
	override init() {
		super.init()
		self.tag = "first_night_page"
	}
	
	override func configureView(_ view: UIView) {
		super.configureView(view)
		super.addLowerLeftImage(Images.BranchImage, withRatio: Images.BranchHWRatio, inView: view)
	}
}

class SecondNightPage : NightPage
{
	override init() {
		super.init()
		self.tag = "second_night_page"
	}
	
	override func configureView(_ view: UIView) {
		super.configureView(view)
		super.addLowerLeftImage(Images.RedFlowerImage, withRatio: Images.RedFlowerHWRatio, inView: view)
		super.addLowerRightImage(Images.RedFlowerImage, withRatio: Images.RedFlowerHWRatio, inView: view)
		
		let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(fadePhilipOut))
		self.mainView!.isUserInteractionEnabled = true
		self.mainView!.addGestureRecognizer(tapGesture)
	}
	
	@objc func fadePhilipOut() {
		UIViewPropertyAnimator(duration: 4.0, curve: .easeOut) {
			self.mainView.alpha = 0.0;
		}.startAnimation()
	}
}
