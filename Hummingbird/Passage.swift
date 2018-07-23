//
//  Passages.swift
//  Hummingbird
//
//  Created by Adam on 4/13/18.
//  Copyright © 2018 Adam. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import AVFoundation

class Passage : NSObject {
	
	var tag = "virtual"
	
	var filename : String?
	var content : String!
	
	var bgView : UIView!
	
	var customView : UIView!
	var textView : UITextView?
	
	static func == (lhs: Passage, rhs: Passage) -> Bool {
		return (lhs.tag == rhs.tag) && (lhs.content == rhs.content)
	}
	
	init(withFilename filename : String?) {
		self.filename = filename
		if let _ = self.filename {
			self.content = FileReader.stringContentsOfTxtFile(self.filename!)
		}
		else {
			self.content = Strings.Title
		}
	}
	
	func configureView(_ view : UIView) {
		self.bgView =  UIView.init(frame: CGRect.init(x: Padding.Eight, y: Ratios.SceneRatio * view.frame.height - view.safeAreaInsets.bottom - Padding.Eight, width: view.frame.width - (Padding.Eight * 2), height: Ratios.PassageRatio * view.frame.height - view.safeAreaInsets.bottom))
		
		UIGraphicsBeginImageContext(bgView.frame.size)
		Images.PassageBgImage.draw(in: bgView.bounds)
		let image : UIImage? = UIGraphicsGetImageFromCurrentImageContext()
		if let _ = image {
			bgView.backgroundColor = UIColor.init(patternImage: image!);
		}
		UIGraphicsEndImageContext()
		
		bgView.layer.shadowColor = UIColor.black.cgColor
		bgView.layer.shadowOpacity = 0.3
		bgView.layer.shadowRadius = 3.0
		bgView.layer.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
		
		view.addSubview(bgView)
		
		self.customView = UIView.init(frame: CGRect.init(x: Padding.Eight, y: Padding.Eight, width: bgView.frame.size.width - (Padding.Eight * 2), height: bgView.frame.size.height - (Padding.Eight * 2)))
		self.customView.backgroundColor = UIColor.clear
		bgView.addSubview(self.customView!)
	}
}

protocol MenuPassageDelegate {
	func onAboutPressed()
	func onSettingsPressed()
	func onStartPressed()
}

class MenuPassage : Passage {
	
	var delegate : MenuPassageDelegate?
	
	override init(withFilename filename: String?) {
		super.init(withFilename: filename)
	}
	
	func formatMenuButton(_ menuButton : UIButton) {
		UIGraphicsBeginImageContext(menuButton.frame.size)
		Images.PassageBgImage.draw(in: menuButton.bounds)
		let image : UIImage? = UIGraphicsGetImageFromCurrentImageContext()
		if let _ = image {
			menuButton.backgroundColor = UIColor.init(patternImage: image!);
		}
		UIGraphicsEndImageContext()
		
		menuButton.layer.borderColor = Colors.MountbattenPink.cgColor
		menuButton.layer.borderWidth = 1.5
		menuButton.layer.cornerRadius = 3.0
		
		menuButton.setTitleColor(Colors.MountbattenPink, for: .normal)
		menuButton.titleLabel?.font = UIFont.init(name: FontNames.TaluhlaBold, size: 42.0)
		menuButton.titleLabel?.adjustsFontSizeToFitWidth = true
		menuButton.titleLabel?.minimumScaleFactor = 0.5
	}
	
	override func configureView(_ view: UIView) {
		super.configureView(view)
		
		let titleHeight : CGFloat = (self.customView!.frame.size.height / 2) - Padding.Eight
		let titleWidth : CGFloat = self.customView!.frame.size.width
		let titleFrame : CGRect = CGRect.init(x: 0, y: 0, width: titleWidth, height: titleHeight)
		let titleLabel : UILabel = UILabel.init(frame: titleFrame)
		titleLabel.font = UIFont.init(name: FontNames.TaluhlaBold, size: 64.0)
		titleLabel.textColor = Colors.MountbattenPink
		titleLabel.adjustsFontSizeToFitWidth = true
		titleLabel.minimumScaleFactor = 0.2
		titleLabel.text = self.content
		titleLabel.textAlignment = .center
		customView!.addSubview(titleLabel)
		
		let buttonHeight : CGFloat = (self.customView!.frame.size.height / 2) - Padding.Eight
		let buttonWidth : CGFloat = (self.customView!.frame.size.width - (Padding.Sixteen)) / 3
		let buttonY : CGFloat = (self.customView!.frame.size.height / 2) + Padding.Eight
		let startX : CGFloat = 0
		let startFrame : CGRect = CGRect.init(x: startX, y: buttonY, width: buttonWidth, height: buttonHeight)
		let startButton : UIButton = UIButton.init(frame: startFrame)
		startButton.setTitle(Strings.Start, for: .normal)
		startButton.addTarget(self, action: #selector(startPressed(_:)), for: .touchUpInside)
		formatMenuButton(startButton)
		self.customView!.addSubview(startButton)
		let aboutFrame : CGRect = CGRect.init(x: startFrame.maxX + Padding.Eight, y: buttonY, width: buttonWidth, height: buttonHeight)
		let aboutButton : UIButton = UIButton.init(frame: aboutFrame)
		aboutButton.setTitle(Strings.About, for: .normal)
		aboutButton.addTarget(self, action: #selector(aboutPressed(_:)), for: .touchUpInside)
		formatMenuButton(aboutButton)
		self.customView!.addSubview(aboutButton)
		let settingsFrame : CGRect = CGRect.init(x: aboutFrame.maxX + Padding.Eight, y: buttonY, width: buttonWidth, height: buttonHeight)
		let settingsButton : UIButton = UIButton.init(frame: settingsFrame)
		settingsButton.setTitle(Strings.Settings, for: .normal)
		settingsButton.addTarget(self, action: #selector(settingsPressed(_:)), for: .touchUpInside)
		formatMenuButton(settingsButton)
		let buttons = [startButton, aboutButton, settingsButton]
		var minFontSize : CGFloat? = 0.0
		for button in buttons {
			print(button.titleLabel!.font.pointSize)
			minFontSize = button.titleLabel?.font.pointSize
		}
		if let _ = minFontSize {
			for button in buttons {
				button.titleLabel?.font.withSize(minFontSize!)
			}
		}
		self.customView!.addSubview(settingsButton)
	}
	
	@objc func startPressed(_ button : UIButton) {
		self.delegate?.onStartPressed()
	}
	
	@objc func aboutPressed(_ button : UIButton) {
		self.delegate?.onAboutPressed()
	}
	
	@objc func settingsPressed(_ button : UIButton) {
		self.delegate?.onSettingsPressed()
	}
	
}

class PagePassage : Passage, AVSpeechSynthesizerDelegate {
	
	var synthesizer : AVSpeechSynthesizer = AVSpeechSynthesizer()
	var attributedText : NSMutableAttributedString!
	var previousRange : NSRange?
	var originalAttributes : [NSAttributedStringKey : Any]?
	var playPauseButton : UIButton!
	
	var startedSpeaking : Bool = false
	
	var isSpeaking : Bool = false {
		didSet {
			if (isSpeaking) {
				self.textView!.isUserInteractionEnabled = false
				self.playPauseButton.setImage(Images.PauseImage, for: .normal)
			}
			else {
				self.textView!.isUserInteractionEnabled = true
				self.playPauseButton.setImage(Images.PlayImage, for: .normal)
			}
		}
	}
	
	override init(withFilename filename: String?) {
		super.init(withFilename: filename)
	}
	
	override func configureView(_ view: UIView) {
		super.configureView(view)
		self.textView = UITextView.init(frame: self.customView.bounds)
		self.textView?.backgroundColor = UIColor.clear
		self.textView?.isEditable = false
		self.originalAttributes = [.font : UIFont(name: FontNames.TaluhlaBold, size: 24.0)!, .foregroundColor : Colors.MountbattenPink]
		self.attributedText = NSMutableAttributedString(string: self.content, attributes: self.originalAttributes)
		self.textView?.attributedText = self.attributedText
		self.customView.addSubview(self.textView!)
		self.configurePlayPauseButtonInView(view)
		self.isSpeaking = StateManager.shared().autoplayEnabled()
	}
	
	func configurePlayPauseButtonInView(_ view : UIView) {
		let buttonHW : CGFloat = 44.0
		let by : CGFloat = self.bgView.frame.origin.y - buttonHW - Padding.Eight
		let bx : CGFloat = view.frame.size.width - buttonHW - Padding.Eight
		let bFrame : CGRect = CGRect.init(x: bx, y: by, width: buttonHW, height: buttonHW)
		self.playPauseButton = UIButton(frame: bFrame)
		self.playPauseButton.addTarget(self, action: #selector(playPausePressed(_:)), for: .touchUpInside)
		view.addSubview(self.playPauseButton)
	}
	
	@objc func playPausePressed(_ : UIButton) {
		if (self.startedSpeaking && self.isSpeaking) { //needs to be paused
			self.pauseSpeaking()
		}
		else if (self.startedSpeaking && !self.isSpeaking) { //needs to be resumed
			self.continueSpeaking()
		}
		else if (!self.startedSpeaking && !self.isSpeaking) { //needs to be started
			self.startSpeaking()
		}
		self.isSpeaking = !self.isSpeaking
	}
	
	func startSpeaking() {
		self.textView?.setContentOffset(.zero, animated: false)
		self.synthesizer.delegate = self
		let voice = AVSpeechSynthesisVoice(language: "en-AU")
		let utterance = AVSpeechUtterance(string: self.content!)
		utterance.voice = voice
		utterance.pitchMultiplier = 1.0
		utterance.rate = 0.5
		self.synthesizer.speak(utterance)
		self.startedSpeaking = true
	}
	
	func continueSpeaking() {
		self.synthesizer.continueSpeaking()
	}
	
	func pauseSpeaking() {
		self.synthesizer.pauseSpeaking(at: .immediate)
	}
	
	func stopSpeaking() {
		synthesizer.stopSpeaking(at: .immediate)
	}
	
	//AVSpeechSynthesizerDelegate
	
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
						   didStart utterance: AVSpeechUtterance) {
		
	}
	
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
						   willSpeakRangeOfSpeechString characterRange: NSRange,
						   utterance: AVSpeechUtterance) {
		if let _ = self.previousRange {
			self.attributedText.addAttribute(.foregroundColor,
											 value: Colors.MountbattenPink,
											 range: self.previousRange!)
		}
		self.attributedText.addAttribute(.foregroundColor, value: UIColor.black, range: characterRange)
		self.textView!.attributedText = self.attributedText
		let frame : CGRect = frameOfRange(characterRange, inTextView: self.textView!)
		if (self.textView!.contentOffset.y + self.textView!.frame.height + (frame.origin.y - self.textView!.contentOffset.y)) <= self.textView!.contentSize.height {
			//only do animation if there is more room to scroll
			UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut, animations: {
				self.textView!.contentOffset.y = frame.origin.y
			}).startAnimation()
		}
		self.previousRange = characterRange
	}
	
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
		if let _ = self.previousRange {
			self.attributedText.addAttribute(.foregroundColor,
											 value: Colors.MountbattenPink,
											 range: self.previousRange!)
		}
		self.textView!.attributedText = self.attributedText
		self.startedSpeaking = false
		self.isSpeaking = false
	}
	
	func frameOfRange(_ range : NSRange, inTextView textView : UITextView) -> CGRect
	{
		let beginning : UITextPosition = textView.beginningOfDocument
		let start : UITextPosition = textView.position(from: beginning, offset: range.location)!
		let end : UITextPosition = textView.position(from: start, offset: range.length)!
		let textRange : UITextRange = textView.textRange(from: start, to: end)!
		let rect : CGRect = textView.firstRect(for: textRange)
		return textView.convert(rect, to: self.textView!.textInputView)
	}
	
}
