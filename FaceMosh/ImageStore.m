//
//  ImageStore.m
//  FaceMosh
//
//  Created by DabKick Developer on 1/28/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import "ImageStore.h"

@interface ImageStore()

// TEMP
@property (nonatomic) NSMutableArray* images;
@property (nonatomic) UIActivityIndicatorView* activityIndicator;

@end

@implementation ImageStore

- (UIActivityIndicatorView*)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicator.frame = [[[UIApplication sharedApplication] keyWindow] bounds];
        [_activityIndicator startAnimating];
    }
    return _activityIndicator;
}

- (void)deleteItemsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths {
    NSMutableArray* output = [NSMutableArray new];
    NSMutableArray* indexes = [NSMutableArray new];
    for (NSIndexPath* path in indexPaths) {
        [indexes addObject:@(path.row)];
    }
    for (int i = 0; i < self.images.count; i++) {
        if (![indexes containsObject:@(i)]) {
            [output addObject:self.images[i]];
        }
    }
    self.images = output;
}

- (NSMutableArray*)images {
    if (!_images) {
        _images = [self getSavedImages].mutableCopy;
        if (!_images) {
            _images = [NSMutableArray new];
        }
    }
    return _images;
}

+ (ImageStore*)sharedStore {
    static id instance;
    @synchronized(self) {
        if (!instance) {
            instance = [ImageStore new];
        }
        return instance;
    }
}

- (NSArray<UIImage*>*)getSavedImages {
    id output = [NSKeyedUnarchiver unarchiveObjectWithFile:[self fileName]];
    if (output) {
        return (NSArray<UIImage*>*)output;
    }
    return nil;
}

- (NSString*)fileName {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
    NSString* docsDir = paths[0];
    NSString* fileName = [docsDir stringByAppendingPathComponent:@"images"];
    return fileName;
}

- (void)saveImagesToDiskWithCompletion:(void (^)(BOOL success))completion {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.activityIndicator];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL result = [NSKeyedArchiver archiveRootObject:self.images toFile:[self fileName]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion)
                completion(result);
            [self.activityIndicator removeFromSuperview];
        });
    });
}

- (NSArray<UIImage*>*)imagesAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths {
    NSMutableArray* util = [NSMutableArray new];
    for (NSIndexPath* path in indexPaths) {
        [util addObject:@(path.row)];
    }
    NSMutableArray* output = [NSMutableArray new];
    for (int i = 0; i < self.images.count; i++) {
        if ([util containsObject:@(i)]) {
            [output addObject:self.images[i]];
        }
    }
    return output.copy;
}

- (UIImage*)imageAtIndexPath:(NSIndexPath*)path {
    if (path.row < self.images.count) {
        UIImage* image = self.images[path.row];
        return image;
    }
    return nil;
}

- (NSInteger)numberOfImages {
    return [self.images count];
}

- (void)saveImage:(UIImage *)image completion:(void (^)(BOOL success))completion {
    [self.images addObject:image];
    [self saveImagesToDiskWithCompletion:completion];
}

- (NSArray<UIImage*>*)getImages {
    return self.images;
}

@end
