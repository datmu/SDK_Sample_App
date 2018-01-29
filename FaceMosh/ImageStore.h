//
//  ImageStore.h
//  FaceMosh
//
//  Created by DabKick Developer on 1/28/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageStore : NSObject

+ (ImageStore*)sharedStore;

- (UIImage*)imageAtIndexPath:(NSIndexPath*)path;
- (NSInteger)numberOfImages;
- (void)saveImage:(UIImage*)image completion:(void (^)(BOOL success))completion;
- (NSArray<UIImage*>*)getImages;
- (void)deleteItemsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths;
- (void)saveImagesToDiskWithCompletion:(void (^)(BOOL success))completion;

@end
