//
//  Request.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 25.03.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "Request.h"

const NSString *baseURL = @"http://cist.nure.ua/ias/app/tt/";

NSString *const RequestAddressGroupList = @"http://cist.nure.ua/ias/app/tt/P_API_GROUP_JSON";
NSString *const RequestAddressTeacherList = @"http://cist.nure.ua/ias/app/tt/P_API_PODR_JSON";
NSString *const RequestAddressAuditoryList = @"http://cist.nure.ua/ias/app/tt/P_API_AUDITORIES_JSON";

@implementation Request

+ (void)loadItemListOfType:(ItemType)itemType delegate:(id)delegate {
    NSString *address = nil;
    switch (itemType) {
        case ItemTypeGroup:
            address = RequestAddressGroupList;
            break;
            
        case ItemTypeTeacher:
            address = RequestAddressTeacherList;
            break;
            
        case ItemtypeAuditory:
            address = RequestAddressAuditoryList;
            break;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:address parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [delegate requestDidLoadItemList:responseObject ofType:itemType];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [delegate requestDidFailWithError:error];
    }];
    
}

+ (void)loadTimeTableForItem:(Item *)item delegate:(id)delegate {
    NSString *address = [NSString stringWithFormat:@"%@P_API_EVENT_JSON?type_id=%hd&timetable_id=%@", baseURL, item.type, item.id];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:address parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [delegate requestDidLoadTimeTable:responseObject forItem:item];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [delegate requestDidFailWithError:error];
    }];
}

+ (void)loadTimeTableForItem:(Item *)item completion:(void (^)(id response))completion failure:(void (^)(NSError *error))failure {
    NSString *address = [NSString stringWithFormat:@"%@P_API_EVENT_JSON?type_id=%hd&timetable_id=%@", baseURL, item.type, item.id];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:address parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completion(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(error);
    }];
}

@end
