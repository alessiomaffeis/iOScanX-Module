//
//  iSXMAnalysisModule.m
//  iOScanX Module
//
//  Created by Alessio Maffeis on 17/06/13.
//  Copyright (c) 2013 Alessio Maffeis. All rights reserved.
//

#import "iSXMAnalysisModule.h"
#import "iSXApp.h"

@implementation iSXMAnalysisModule {
    
}

@synthesize delegate = _delegate;
@synthesize name = _name;
@synthesize prefix = _prefix;
@synthesize metrics = _metrics;

- (id) init {
    
    [super init];
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
    }
    return self;
}


- (void) analyze:(id) item {
    
    NSMutableDictionary *results = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString *theId = [item objectAtIndex:0];
    iSXApp *theItem = [item objectAtIndex:1];
    
    if ([self itemIsValid:theItem]) {
        
        // DO YOUR NASTY THINGS HERE.
    }
    else {
                
        for(SXMetric *metric in _metrics){
            [results setObject:nil forKey:[NSString stringWithFormat:@"%@_%@", _prefix, metric.name]];
        }
    }
    [_delegate storeMetrics:results forItem:theId];
}

- (BOOL) itemIsValid:(id) item {
    
    // VALIDATE YOUR ITEM HERE.
    
    return NO;
}

- (void) dealloc {
    
    [_name release];
    [_prefix release];
    [_metrics release];
    [super dealloc];
}

@end
