//
//  AppModel.m
//  testSearch
//
//  Created by Ion Silviu-Mihai on 28/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

+ (AppModel *)sharedModel
{
    static AppModel *sharedModel;
    if (sharedModel == nil)
    {
        sharedModel = [[AppModel alloc] init];
    }
    return sharedModel;
}

-(NSMutableArray *)collections
{
    if(_collections == nil)
    {
        _collections = [[NSMutableArray alloc] init];
    }
    return _collections;
}

//-(NSMutableArray *)images
//{
//    if (_images == nil) {
 //       _images = [[NSMutableArray alloc] init];
//    }
//    return _images;
//}

#pragma mark -Server methods

- (void)requestDataFromServerWithParameter:(NSString *)parameter
{
    static BOOL isPreviousRequestWorking;
    self.collections = [[NSMutableArray alloc] init];
    self.images = [[NSMutableDictionary alloc] init];
    dispatch_queue_t requestQueue = dispatch_queue_create("Search Request Queue", NULL);
    if (isPreviousRequestWorking == NO)
    {
        isPreviousRequestWorking = YES;
        
        dispatch_async(requestQueue, ^{
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ipi.sparktechsoft.net/api/v1/items/search?q=%@&extra=1&type=all&auth_token=5aX2KzMc2JJwj4FGzAQh", parameter]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
            
            [request setHTTPMethod:@"GET"];
            
            NSHTTPURLResponse *httpResponse;
            
            NSData *searchData = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:nil];
            
            for (int retryCount = 1; ((searchData == nil || [httpResponse statusCode] != 200) && retryCount < 5); retryCount++)
            {
                searchData = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:nil];
                NSLog(@"A intrat in eroare: %ld", (long)[httpResponse statusCode]);
            }
            if (searchData) {
                id response = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingAllowFragments error:nil];
                //call the function to remove null objects
                
                // . . .
                
                //end
                
                
                if ([httpResponse statusCode] == 200 && [response isKindOfClass:[NSDictionary class]] ) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.collections = response[@"items"];
                       // NSLog(@"Items: %@, %@, %@",self.collections[0][@"title"],self.collections[0][@"collection_id"],self.collections[0][@"collection_name"]);
                        for (NSDictionary *dict in self.collections) {
                            //NSLog(@"ITEMS TO SHOW: %@, %@, %@, %@\n", dict[@"title"],dict[@"collection_id"],dict[@"collection_name"],dict[@"medium_small_image_url"]);
                            NSLog(@"Collection items: %@", dict);
                        }
                        //NSLog(@"%@", self.collections[0][@"resource_links_api"][@"youtube"]);
                        //if ([self.collections[0][@"resource_links_api" ] isKindOfClass:[NSDictionary class]]) {
                         //   NSLog(@"NDDictionary");
                        //}
                        //if ([self.collections[0][@"resource_links_api" ] isKindOfClass:[NSArray class]]) {
                          // NSLog(@"NDDictionary");
                        //}
                        
                        
                        //[self getPhotos];
                        [[NSNotificationCenter defaultCenter] postNotificationName:[AppModel searchResultReturned] object:self];
                    });
                    
                   // self.collections = response[@"collection"];
                    //NSLog(@"Did receive search result: %@", self.collections);
                    
                }
            }
            
            
        });
    }
    dispatch_async(requestQueue, ^{
        isPreviousRequestWorking = NO;
    });
}

-(void)getPhotosAtIndex:(int)index
{
    
    NSLog(@"A INTRAT IN GET PHOTOS AT INDEX: %d", index);
/*
    dispatch_queue_t downloadImagesQueue = dispatch_queue_create("Image Download Queue", NULL);
    dispatch_async(downloadImagesQueue, ^{
        for (NSDictionary *dict in self.collections) {
            NSLog(@"Linkul de download este %@:", dict[@"medium_small_image_url"]);
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", dict[@"medium_small_image_url"]]]];
            //result = [UIImage imageWithData:data];
            [self.images addObject:data];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dataDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:12]
                                                                 forKey:@"valoarePasata"];
            [[NSNotificationCenter defaultCenter] postNotificationName:[AppModel imageDownloadFinished] object:self userInfo:dataDict];
        });
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:[AppModel imageDownloadFinished] object:self];
    });
 */
    
    dispatch_queue_t downloadImagesQueue = dispatch_queue_create("Image Download Queue", NULL);
    dispatch_async(downloadImagesQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.collections[index][@"medium_small_image_url"]]]];
            //result = [UIImage imageWithData:data];
        //[self.images addObject:data];

        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"MAIN QUEUE");
            if (index < self.collections.count) {
                [self.images setObject:data forKey:self.collections[index][@"id"]];
                NSDictionary *dataDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:index]
                                                                     forKey:@"valoarePasata"];
                [[NSNotificationCenter defaultCenter] postNotificationName:[AppModel imageDownloadFinished] object:self userInfo:dataDict];
            }
        });
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:[AppModel imageDownloadFinished] object:self];
    });
    
}

#pragma mark - Notifications Area

+(NSString *)searchResultReturned
{
    return @"searchResultReturned";
}
+(NSString *)imageDownloadFinished
{
    return @"imageDownloadFinished";
}

@end
