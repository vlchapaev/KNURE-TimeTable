//
//  ModalView.h
//  KNURE TimeTable iOS
//
//  Created by Vlad Chapaev on 25.03.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalViewDelegate <NSObject>

- (void)didSelectItem:(NSString *)itemID;

@end

@interface ModalView : UIView

@property (weak, nonatomic) id <ModalViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *lesson;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *auditory;
@property (strong, nonatomic) IBOutlet UILabel *groups;
@property (strong, nonatomic) IBOutlet UILabel *teacher;

@end
