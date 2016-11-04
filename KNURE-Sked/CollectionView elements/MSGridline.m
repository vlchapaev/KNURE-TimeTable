//
//  MSGridlineCollectionReusableView.m
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 2/26/13.
//  Copyright (c) 2015 Vlad Chapaev. All rights reserved.
//

#import "MSGridline.h"

@implementation MSGridline

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1];
    }
    return self;
}

@end
