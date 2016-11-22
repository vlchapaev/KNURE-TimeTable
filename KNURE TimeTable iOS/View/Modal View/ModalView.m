//
//  ModalView.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 25.03.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "ModalView.h"

@implementation ModalView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.33;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 0.5;
    self.layer.cornerRadius = 10.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

@end
