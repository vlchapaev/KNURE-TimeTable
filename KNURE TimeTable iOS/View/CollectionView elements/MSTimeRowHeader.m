//
//  MSTimeRowHeader.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 05.11.16.
//  Copyright (c) 2015 Vlad Chapaev. All rights reserved.
//

#import "MSTimeRowHeader.h"

@implementation MSTimeRowHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.title = [UILabel new];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.font = [UIFont systemFontOfSize:12.0];
        self.title.textAlignment = NSTextAlignmentRight;
        self.title.textColor = self.textColor;
        [self addSubview:self.title];
        
        [self.title makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.right.equalTo(self.right).offset(-5.0);
        }];
    }
    return self;
}

#pragma mark - MSTimeRowHeader

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.title.textColor = textColor;
}

- (void)setTime:(NSDate *)time {
    _time = time;
    
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"HH:mm";
    }
    self.title.text = [dateFormatter stringFromDate:time];
    [self setNeedsLayout];
}

@end
