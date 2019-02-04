//
//  MSTimeRowHeader.m
//  KNURE TimeTable
//
//  Created by Vladislav Chapaev on 05.11.16.
//  Copyright (c) 2015 Vladislav Chapaev. All rights reserved.
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
        self.title.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.title];
        
        [self.title makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.right.equalTo(self.right).offset(-5.0);
            make.left.equalTo(self.left).offset(3.0);
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
        dateFormatter.dateFormat = @"H:mm";
    }
    self.title.text = [dateFormatter stringFromDate:time];
    [self setNeedsLayout];
}

@end
