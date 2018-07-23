//
//  RootViewController.swift
//  Hummingbird
//
//  Created by Adam on 4/9/18.
//  Copyright © 2018 Adam. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate {

	var pageViewController: UIPageViewController?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		// Configure the page view controller and add it as a child view controller.
		self.pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
		self.pageViewController!.delegate = self

		let startingViewController: DataViewController = self.modelController.viewControllerAtIndex(StateManager.shared().getLastPage())!
		let viewControllers = [startingViewController]
		self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })

		self.pageViewController!.dataSource = self.modelController

		self.addChildViewController(self.pageViewController!)
		self.view.addSubview(self.pageViewController!.view)

		self.pageViewController!.didMove(toParentViewController: self)
		
		NotificationCenter.default.addObserver(self, selector: #selector(dismissFromNotification(notification:)), name: .toHome, object: nil)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	var modelController: ModelController {
		// Return the model controller object, creating it if necessary.
		// In more complex implementations, the model controller may be passed to the view controller.
		if _modelController == nil {
			let page1 : PageViewModel = PageViewModel.init(withPassage: PagePassage.init(withFilename: Filenames.PageOne), scene: FirstDayPage.init())
			let page2 : PageViewModel = PageViewModel.init(withPassage: PagePassage.init(withFilename: Filenames.PageTwo), scene: SecondDayPage.init())
			let page3 : PageViewModel = PageViewModel.init(withPassage: PagePassage.init(withFilename: Filenames.PageThree), scene: FirstNightPage.init())
			let page4 : PageViewModel = PageViewModel.init(withPassage: PagePassage.init(withFilename: Filenames.PageFour), scene: ThirdDayPage.init())
			let page5 : PageViewModel = PageViewModel.init(withPassage: PagePassage.init(withFilename: Filenames.PageFive), scene: FourthDayPage.init())
			let page6 : PageViewModel = PageViewModel.init(withPassage: PagePassage.init(withFilename: Filenames.PageSix), scene: SecondNightPage.init())
			_modelController = ModelController.init(withPageViewModels: [page1, page2, page3, page4, page5, page6])
		}
		return _modelController!
	}

	var _modelController: ModelController? = nil

	// MARK: - UIPageViewController delegate methods

	func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
		if (orientation == .portrait) || (orientation == .portraitUpsideDown) || (UIDevice.current.userInterfaceIdiom == .phone) {
		    // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.
		    let currentViewController = self.pageViewController!.viewControllers![0]
		    let viewControllers = [currentViewController]
		    self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })

		    self.pageViewController!.isDoubleSided = false
		    return .min
		}

		// In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
		let currentViewController = self.pageViewController!.viewControllers![0] as! DataViewController
		var viewControllers: [UIViewController]

		let indexOfCurrentViewController = self.modelController.indexOfViewController(currentViewController)
		if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
		    let nextViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerAfter: currentViewController)
		    viewControllers = [currentViewController, nextViewController!]
		} else {
		    let previousViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerBefore: currentViewController)
		    viewControllers = [previousViewController!, currentViewController]
		}
		self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })

		return .mid
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	@objc func dismissFromNotification(notification : NSNotification) {
		if let nav = self.navigationController {
			nav.popViewController(animated: true)
		}
	}

}

