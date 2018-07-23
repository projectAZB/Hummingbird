//
//  Constants.swift
//  Hummingbird
//
//  Created by Adam on 4/13/18.
//  Copyright © 2018 Adam. All rights reserved.
//

import Foundation
import UIKit

struct Keys {
	static let PageIndex = "PageIndex"
	static let Autoplay = "Autoplay"
}

struct Extensions {
	static let TXT : String = "txt"
}

struct Filenames {
	static let PageOne : String = "PageOne"
	static let PageTwo : String  = "PageTwo"
	static let PageThree : String  = "PageThree"
	static let PageFour : String  = "PageFour"
	static let PageFive : String  = "PageFive"
	static let PageSix : String  = "PageSix"
}

struct Strings {
	static let Title = "A Hummingbird's Heart"
	static let Start = "Start"
	static let Settings = "Settings"
	static let About = "About"
}

struct FontNames {
	static let TaluhlaRegular = "TALUHLA-Regular"
	static let TaluhlaBold = "TALUHLA-Bold"
}

struct Ratios {
	static let SceneRatio : CGFloat = 0.75
	static let PassageRatio : CGFloat = 1 - Ratios.SceneRatio
	
	static let MainViewRatio : CGFloat = 0.5
	static let SunMoonRatio : CGFloat = 0.35
	
	static let LowerLeftRatio : CGFloat = 0.4
	static let LowerRightRatio : CGFloat = 0.4
	
	static let DrawContentRatio : CGFloat = 0.5
}

struct Padding {
	static let Four : CGFloat = 4.0
	static let Eight : CGFloat = 8.0
	static let Sixteen : CGFloat = 16.0
}

struct Colors {
	static let SwansDown = UIColor.init(red: 216/255.0, green: 236/255.0, blue: 235/255.0, alpha: 1.0)
	static let Bunker = UIColor.init(red: 11/255.0, green: 17/255.0, blue: 24/255.0, alpha: 1.0)
	static let Walnut = UIColor.init(red: 125.0 / 255.0, green: 60.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0)
	static let Mahogany = UIColor.init(red: 55.0 / 255.0, green: 17.0 / 255.0, blue: 3.0 / 255.0, alpha: 1.0)
	static let MountbattenPink = UIColor.init(red: 154.0 / 255.0, green: 120.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
}

struct Images {
	static let CloudImage : UIImage = UIImage.init(named: "cloud")!
	static let CloudHomeImage : UIImage = UIImage.init(named: "cloudHome")!
	static let CloudHWRatio : CGFloat = 100.0 / 164.0
	
	static let StarImage : UIImage = UIImage.init(named: "star")!
	static let StarHomeImage : UIImage = UIImage.init(named: "starHome")!
	static let StarHWRatio : CGFloat = 156.0 / 164.0
	
	static let PhilipImage : UIImage = UIImage.init(named: "philip")!
	static let PhilipHWRatio : CGFloat = 900.0 / 826.0
	
	static let PassageBgImage : UIImage = UIImage.init(named: "passageBg")!
	
	static let SunImage : UIImage = UIImage.init(named: "sun")!
	static let SunHWRatio : CGFloat = 300.0 / 300.0
	
	static let MoonImage : UIImage = UIImage.init(named: "moon")!
	static let MoonHWRatio : CGFloat = 300.0 / 300.0
	
	static let TextBubbleImage : UIImage = UIImage.init(named: "textBubble")!
	static let TextBubbleHWRatio : CGFloat = 194.0 / 232.0
	
	static let BranchImage : UIImage = UIImage.init(named: "branch")!
	static let BranchHWRatio : CGFloat = 142.0 / 285.0
	
	static let HummingbirdsImage : UIImage = UIImage.init(named: "hummingbirds")!
	static let HummingbirdsHWRatio : CGFloat = 422.0 / 580.0
	
	static let PauseImage : UIImage = UIImage.init(named: "pause")!
	static let PlayImage : UIImage = UIImage.init(named: "play")!
	
	static let CancelImage : UIImage = UIImage.init(named: "cancel_pink")!
	
	static let OtherBranchImage : UIImage = UIImage.init(named: "otherBranch")!
	static let OtherBranchHWRatio : CGFloat = 243.0 / 295.0
	
	static let BirdBathImage : UIImage = UIImage.init(named: "birdBath")!
	static let BirdBathHWRatio : CGFloat = 1280.0 / 850.0
	
	static let RedFlowerImage : UIImage = UIImage.init(named: "redflower")!
	static let RedFlowerHWRatio : CGFloat = 686.0 / 1407.0
}

extension Notification.Name {
	static let toHome = Notification.Name("toHome")
}
