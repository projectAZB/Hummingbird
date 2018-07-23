//
//  SettingsViewController.m
//  Hummingbird
//
//  Created by Adam on 4/16/18.
//  Copyright © 2018 Adam. All rights reserved.
//

#import "SettingsViewController.h"

#import "Hummingbird-Swift.h"

@interface SettingsViewController ()


@property (weak, nonatomic) IBOutlet UITextView *instructionsTextView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *onOffSegControl;


@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	UIGraphicsBeginImageContext(self.view.frame.size);
	[[UIImage imageNamed:@"passageBg.pdf"] drawInRect:self.view.bounds];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UISwipeGestureRecognizer * swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(onSwipeDown:)];
	swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
	[self.view addGestureRecognizer: swipeDown];
	
	self.instructionsTextView.text = @"-Swipe left/right to go forwards/backwards on pages\n-Swipe down to dismiss this page\n-Clicking on random things might result in different animations\n-A \"charm\" is the technical term for a group of hummingbirds";
	self.instructionsTextView.textAlignment = NSTextAlignmentCenter;
	
	self.onOffSegControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] boolForKey: @"Autoplay"] ? 0 : 1;
	
	self.view.backgroundColor = [UIColor colorWithPatternImage: image];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear: animated];
	if (self.onOffSegControl.selectedSegmentIndex == 0) {
		[[NSUserDefaults standardUserDefaults] setBool: YES forKey: @"Autoplay"];
	}
	else {
		[[NSUserDefaults standardUserDefaults] setBool: NO forKey: @"Autoplay"];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)onSwipeDown: (UISwipeGestureRecognizer *)swipe {
	[self dismissViewControllerAnimated: YES completion:^{
		
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
