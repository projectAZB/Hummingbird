//
//  AboutViewController.swift
//  Hummingbird
//
//  Created by Adam on 4/16/18.
//  Copyright © 2018 Adam. All rights reserved.
//

import UIKit
import CoreGraphics

class AboutViewController: UIViewController {
	
	var lastPoint = CGPoint.zero
	var brushWidth: CGFloat = 10.0
	var opacity: CGFloat = 1.0
	var drawing = false
	
	var drawImageView : UIImageView!
	var textView : UITextView!
	
	var ans1Frame : CGRect!
	var ans2Frame : CGRect!
	var ans3Frame : CGRect!
	
	/// Collect every point that is drawn
	var points = [CGPoint]()
	
	var viewsConfigured : Bool = false
	
	var parentalView : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		UIGraphicsBeginImageContext(self.view.frame.size)
		Images.PassageBgImage.draw(in: self.view.bounds)
		let image : UIImage? = UIGraphicsGetImageFromCurrentImageContext()
		if let _ = image {
			self.view.backgroundColor = UIColor.init(patternImage: image!);
		}
		UIGraphicsEndImageContext()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	func formatParentalLabel(_ label : UILabel) {
		label.font = UIFont.init(name: FontNames.TaluhlaBold, size: 36.0)
		label.textColor = Colors.MountbattenPink
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.5
		label.textAlignment = .center
	}
	
	func configureParentalView() {
		self.parentalView = UIView(frame: self.view.bounds)
		self.parentalView.backgroundColor = Colors.Bunker
		
		self.drawImageView = UIImageView.init(frame: self.view.bounds)
		self.parentalView.addSubview(self.drawImageView)
		
		let cWidth = Ratios.DrawContentRatio * self.parentalView.frame.size.width
		let cHeight = cWidth
		let cx : CGFloat = (self.parentalView.frame.size.width / 2) - (cWidth / 2)
		let cy : CGFloat = (self.parentalView.frame.size.height / 2) - (cHeight / 2)
		let contentAreaView : UIView = UIView(frame: CGRect(x: cx, y: cy, width: cWidth, height: cHeight))
		contentAreaView.backgroundColor = UIColor.clear
		
		let label : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: cWidth, height: cHeight / 4))
		label.backgroundColor = UIColor.clear
		label.text = "Circle the square root of -1?"
		label.numberOfLines = 2
		formatParentalLabel(label)
		contentAreaView.addSubview(label)
		
		let ansWidth : CGFloat = (contentAreaView.bounds.width - (Padding.Sixteen * 2)) / 3
		let ansHeight : CGFloat = cHeight / 4
		let ansY : CGFloat = contentAreaView.bounds.height - ansHeight
		
		let ans1x : CGFloat = 0.0
		let ans1L : UILabel = UILabel(frame: CGRect(x: ans1x, y: ansY, width: ansWidth, height: ansHeight))
		formatParentalLabel(ans1L)
		ans1L.text = "i"
		contentAreaView.addSubview(ans1L)
		self.ans1Frame = self.view.convert(ans1L.frame, from: contentAreaView)
		
		let ans2x : CGFloat = ans1x + ansWidth + Padding.Sixteen
		let ans2L : UILabel = UILabel(frame: CGRect(x: ans2x, y: ansY, width: ansWidth, height: ansHeight))
		formatParentalLabel(ans2L)
		ans2L.text = "1"
		contentAreaView.addSubview(ans2L)
		self.ans2Frame = self.view.convert(ans2L.frame, from: contentAreaView)
		
		let ans3x : CGFloat = ans2x + ansWidth + Padding.Sixteen
		let ans3L : UILabel = UILabel(frame: CGRect(x: ans3x, y: ansY, width: ansWidth, height: ansHeight))
		formatParentalLabel(ans3L)
		ans3L.text = "q"
		contentAreaView.addSubview(ans3L)
		self.ans3Frame = self.view.convert(ans3L.frame, to: contentAreaView)
		
		self.parentalView.addSubview(contentAreaView)
		
		self.view.addSubview(self.parentalView)
	}
	
	func configureCancelView() {
		let cancelHW : CGFloat = 44.0
		let cancelY : CGFloat = Padding.Sixteen + self.view.safeAreaInsets.top
		let cancelX : CGFloat = self.view.frame.size.width - cancelHW - Padding.Sixteen
		let cancelFrame : CGRect = CGRect(x: cancelX, y: cancelY, width: cancelHW, height: cancelHW)
		let cancelButton : UIButton = UIButton(frame: cancelFrame)
		cancelButton.addTarget(self, action: #selector(onCancelPressed), for: .touchUpInside)
		cancelButton.setImage(Images.CancelImage, for: .normal)
		self.view.addSubview(cancelButton)
	}
	
	@objc func onCancelPressed() {
		self.dismiss(animated: true, completion: nil)
	}
	
	func configureTextView() {
		let tWidth = Ratios.DrawContentRatio * self.view.frame.size.width
		let tHeight = tWidth
		let cx : CGFloat = (self.view.frame.size.width / 2) - (tWidth / 2)
		let cy : CGFloat = (self.view.frame.size.height / 2) - (tHeight / 2)
		self.textView = UITextView(frame: CGRect(x: cx, y: cy, width: tWidth, height: tHeight))
		self.textView.backgroundColor = UIColor.clear
		self.textView.textAlignment = .center
		self.textView.font = UIFont.init(name: FontNames.TaluhlaBold, size: 24.0)
		self.textView.textColor = Colors.MountbattenPink
		self.textView.text = "About the Author:\nMy name is Adam and I'm from Pennsylvania"
		self.textView.isEditable = false
		self.textView.isUserInteractionEnabled = false
		self.view.addSubview(self.textView)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if !self.viewsConfigured {
			configureTextView()
			configureParentalView()
			configureCancelView()
			self.viewsConfigured = true
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@objc func onSwipeDown() {
		self.dismiss(animated: true, completion: nil)
	}
	
	//
	// MARK: - Touches
	//
	
	/// Draw a line segment
	func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
		
		// Create the canvas
		UIGraphicsBeginImageContext(view.frame.size)
		let context = UIGraphicsGetCurrentContext()
		drawImageView.image?.draw(in: CGRect(x: 0, y: 0,
											 width: view.frame.size.width,
											 height: view.frame.size.height))
		
		// Create line segment
		context!.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
		context!.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
		
		// Set the `pen`
		context!.setLineCap(.round)
		context!.setLineWidth(brushWidth)
		context!.setStrokeColor(Colors.MountbattenPink.cgColor)
		context!.setBlendMode(.normal)
		
		// Stroke the path with the pen
		context!.strokePath()
		
		// Copy the canvas on the imageview
		drawImageView.image = UIGraphicsGetImageFromCurrentImageContext()
		drawImageView.alpha = opacity
		UIGraphicsEndImageContext()
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		drawing = false
		if let touch = touches.first {
			lastPoint = touch.location(in: self.view)
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		drawing = true
		if let touch = touches.first {
			let currentPoint = touch.location(in: view)
			drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
			lastPoint = currentPoint
			points.append(currentPoint)
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if !drawing {
			drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
		}
		drawImageView.image = nil
		let intersect = percentageIntersect(frame1: squareRectFromPoints(), frame2: self.ans1Frame)
		if  intersect > 0.5 {
			UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
				self.parentalView.frame.origin.y = self.view.frame.size.height
			}.startAnimation()
		}
		self.points = [CGPoint]()
	}
	
	func percentageIntersect(frame1 : CGRect, frame2 : CGRect) -> CGFloat {
		if frame1.intersects(frame2) {
			let intersection : CGRect = frame1.intersection(frame2)
			let frame1Area : CGFloat = frame1.width * frame1.height
			let frame2Area : CGFloat = frame2.width * frame2.height
			let combinedFrameArea : CGFloat = (frame1Area + frame2Area) / 2.0
			let intersectionArea : CGFloat = intersection.width * intersection.height
			return intersectionArea / combinedFrameArea
		}
		return 0.0
	}
	
	func squareRectFromPoints() -> CGRect {
		var maxX : CGFloat = 0.0
		var minX : CGFloat = self.view.frame.size.width
		var maxY : CGFloat = 0.0
		var minY : CGFloat = self.view.frame.size.height
		for point in points {
			maxX = point.x > maxX ? point.x : maxX
			minX = point.x < minX ? point.x : minX
			maxY = point.y > maxY ? point.y : maxY
			minY = point.y < minY ? point.y : minY
		}
		let origin : CGPoint = CGPoint(x: minX, y: minY)
		let width : CGFloat = maxX - minX
		let height : CGFloat = maxY - minY
		let frame : CGRect = CGRect(x: origin.x, y: origin.y, width: width, height: height)
		return frame
	}

}
