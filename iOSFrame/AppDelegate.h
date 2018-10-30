//
//  AppDelegate.h
//  iOSFrame
//
//  Created by 罗映星 on 2018/10/30.
//  Copyright © 2018 罗映星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

