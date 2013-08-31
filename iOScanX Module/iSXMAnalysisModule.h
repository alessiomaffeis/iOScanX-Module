//
//  iSXMAnalysisModule.h
//  iOScanX Module
//
//  Created by Alessio Maffeis on 17/06/13.
//  Copyright (c) 2013 Alessio Maffeis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ScanX/SXModule.h>

@interface iSXMAnalysisModule : NSObject <SXModule>

@property (assign) NSString* tmpPath;

- (BOOL) itemIsValid:(id) item;

@end
