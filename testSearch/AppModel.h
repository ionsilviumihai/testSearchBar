//
//  AppModel.h
//  testSearch
//
//  Created by Ion Silviu-Mihai on 28/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject

@property (nonatomic, strong) NSMutableArray *collections;

@property (nonatomic, strong) NSMutableDictionary *images;

+(AppModel *)sharedModel;


//server methods
- (void)requestDataFromServerWithParameter:(NSString *)parameter;

-(void)getPhotosAtIndex:(int)index;

//notifications area
+(NSString *)searchResultReturned;
+(NSString *)imageDownloadFinished;

@end
