//
//  LessonRepository.h
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 07/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LessonRepository : NSObject

- (void)remote_timetableWithId:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
