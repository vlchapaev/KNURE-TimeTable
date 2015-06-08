//
//  ModalViewController.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 08.10.14.
//  Copyright (c) 2014 Shogunate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalViewController : UIViewController

- (id)initWithDictionary:(NSDictionary *)sked index:(NSInteger)index isTablet:(BOOL)isTablet;

@end
