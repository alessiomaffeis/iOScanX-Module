//
//  iSXMAnalysisModule.m
//  iOScanX Module
//
//  Created by Alessio Maffeis on 17/06/13.
//  Copyright (c) 2013 Alessio Maffeis. All rights reserved.
//

#import "iSXMAnalysisModule.h"
#import "NSFileManager+DirectoryLocations.h"


@implementation iSXMAnalysisModule {
    
    NSString *_bundleIdentifier;
    NSString *_tmpPath;
    NSBundle *_bundle;
}

@synthesize delegate = _delegate;
@synthesize name = _name;
@synthesize prefix = _prefix;
@synthesize metrics = _metrics;

- (id) init {
    
    self = [super init];
    if (self) {
        _bundle = [NSBundle bundleForClass:[iSXMAnalysisModule class]];
        NSString *plist = [_bundle pathForResource:@"Module" ofType:@"plist"];
        NSDictionary *moduleInfo = [NSDictionary dictionaryWithContentsOfFile:plist];
        _name = [[NSString alloc] initWithString:[moduleInfo objectForKey:@"name"]];
        _prefix = [[NSString alloc] initWithString:[moduleInfo objectForKey:@"prefix"]];
        _readonly = [[moduleInfo objectForKey:@"readonly"] boolValue];

        NSMutableArray *metrics = [NSMutableArray array];
        for(NSDictionary *metric in [moduleInfo objectForKey:@"metrics"]) {
            SXMetric *sxm = [[SXMetric alloc] initWithName:[metric objectForKey:@"name"] andInfo:[metric objectForKey:@"description"]];
            [metrics addObject:sxm];
            [sxm release];
        }
        _metrics = [[NSArray alloc] initWithArray:metrics];
        _bundleIdentifier = [[_bundle bundleIdentifier] retain];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *modulesPath = [fm applicationSupportSubDirectory:@"Modules"];
        _tmpPath = [[NSString stringWithFormat:@"%@/%@/tmp", modulesPath, _bundleIdentifier] retain];
        [fm createDirectoryAtPath:_tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return self;
}


- (void) analyze:(id)item {
    
    NSString *theId = [item objectAtIndex:0];
    iSXApp *theItem = [item objectAtIndex:1];
    
    NSMutableDictionary *results = [[[NSMutableDictionary alloc] init] autorelease];
    for(SXMetric *metric in _metrics)
        [results setObject:[NSNull null] forKey:[NSString stringWithFormat:@"%@_%@", _prefix, metric.name]];

    if ([self itemIsValid:theItem])
    {
        NSString *itemPath = [self temporaryItem:theItem];
        if(itemPath != nil)
        {
            // DO YOUR NASTY THINGS HERE.
            
            [self deleteItem:theItem];
        }
    }
    
    [_delegate storeMetrics:results forItem:theId];
}

- (BOOL) itemIsValid:(iSXApp*)item {
    
    if (item.path == nil)
        return NO;
    if (item.ID == nil)
        return NO;
    
    return YES;
}

- (NSString*) temporaryItem:(iSXApp*)item {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (_readonly)
    {
        @synchronized(self)
        {
            if (![fm fileExistsAtPath:[item.path stringByDeletingPathExtension]])
            {
                NSString *dir = [NSString stringWithFormat:@"--directory=%@", [item.path stringByDeletingLastPathComponent]];
                NSArray *args = [NSArray arrayWithObjects: @"-xf", item.path, dir, nil];
                NSTask *untar = [[NSTask alloc] init];
                [untar setLaunchPath:@"/usr/bin/tar"];
                [untar setArguments:args];
                [untar launch];
                [untar waitUntilExit];
                int exitCode = [untar terminationStatus];
                [untar release];
                
                if (exitCode != 0)
                    return nil;
            }
        }
        
        return [item.path stringByDeletingLastPathComponent];
    }
    else
    {
        NSString *tmpItemPath = [_tmpPath stringByAppendingPathComponent:item.ID];
        [fm createDirectoryAtPath:tmpItemPath withIntermediateDirectories:YES attributes:nil error:nil];

        NSString *dir = [NSString stringWithFormat:@"--directory=%@", tmpItemPath];
        NSArray *args = [NSArray arrayWithObjects: @"-xf", item.path, dir, nil];
        
        NSTask *untar = [[NSTask alloc] init];
        [untar setLaunchPath:@"/usr/bin/tar"];
        [untar setArguments:args];
        [untar launch];
        [untar waitUntilExit];
        int exitCode = [untar terminationStatus];
        [untar release];
        
        return  exitCode == 0 ? [tmpItemPath stringByAppendingPathComponent:item.name] : nil;
    }
}

- (BOOL) deleteItem:(iSXApp*)item {
    
    if (_readonly)
        return YES;
    
    return [[NSFileManager defaultManager] removeItemAtPath:[_tmpPath stringByAppendingPathComponent:item.ID] error:nil];
}

- (void) dealloc {
    
    [_name release];
    [_prefix release];
    [_metrics release];
    [_bundleIdentifier release];
    [_tmpPath release];
    [super dealloc];
}

@end
