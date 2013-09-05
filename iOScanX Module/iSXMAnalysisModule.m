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
}

@synthesize delegate = _delegate;
@synthesize name = _name;
@synthesize prefix = _prefix;
@synthesize metrics = _metrics;

- (id) init {
    
    self = [super init];
    if (self) {
        
        NSDictionary *moduleInfo = [NSDictionary dictionaryWithContentsOfFile:@"Module.plist"];
        _name = [[NSString alloc] initWithString:[moduleInfo objectForKey:@"name"]];
        _prefix = [[NSString alloc] initWithString:[moduleInfo objectForKey:@"prefix"]];
        
        NSMutableArray *metrics = [NSMutableArray array];
        for(NSDictionary *metric in [moduleInfo objectForKey:@"metrics"]) {
            SXMetric *sxm = [[SXMetric alloc] initWithName:[metric objectForKey:@"name"] andInfo:[metric objectForKey:@"description"]];
            [metrics addObject:sxm];
            [sxm release];
        }
        _metrics = [[NSArray alloc] initWithArray:metrics];
        _bundleIdentifier = [[NSBundle bundleForClass:[iSXMAnalysisModule class]] bundleIdentifier];
        NSString *modulesPath = [[NSFileManager defaultManager] applicationSupportSubDirectory:@"Modules"];
        _tmpPath = [NSString stringWithFormat:@"%@/%@/tmp", modulesPath, _bundleIdentifier];
    }
    return self;
}


- (void) analyze:(id)item {
    
    NSString *theId = [item objectAtIndex:0];
    iSXApp *theItem = [item objectAtIndex:1];
    
    NSMutableDictionary *results = [[[NSMutableDictionary alloc] init] autorelease];
    for(SXMetric *metric in _metrics)
        [results setObject:nil forKey:[NSString stringWithFormat:@"%@_%@", _prefix, metric.name]];

    if ([self itemIsValid:theItem])
    {
       if ([self copyItem:theItem])
        {
            NSLog(@"%@ is analyzing: %@", _name, theItem.name);
            
            // DO YOUR NASTY THINGS HERE.
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

- (BOOL) copyItem:(iSXApp*)item {
    
    NSString *tmpItemPath = [_tmpPath stringByAppendingPathComponent:item.ID];
    [[NSFileManager defaultManager] createDirectoryAtPath:tmpItemPath withIntermediateDirectories:YES attributes:nil error:nil];

    NSString *dir = [NSString stringWithFormat:@"--directory=%@", tmpItemPath];
    NSArray *args = [NSArray arrayWithObjects: @"-xf", item.path, dir, nil];
    
    NSTask *untar = [[NSTask alloc] init];
    [untar setLaunchPath:@"/usr/bin/tar"];
    [untar setArguments:args];
    [untar launch];
    [untar waitUntilExit];
    int exitCode = [untar terminationStatus];
    [untar release];
    
    return  exitCode == 0 ? YES : NO;
}

- (void) dealloc {
    
    [_name release];
    [_prefix release];
    [_metrics release];
    [super dealloc];
}

@end
