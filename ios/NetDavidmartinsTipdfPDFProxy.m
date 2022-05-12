/**
* Ti PDF
*
* Created by Dave McMartin
* Copyright (c) 2018-2019 Dave McMartin
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
* documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
* rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
* persons to whom the Software is furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
* Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
* WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
* OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#import "NetDavidmartinsTipdfPDFProxy.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation NetDavidmartinsTipdfPDFProxy

#pragma mark Internal

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lineWidth = [NSNumber numberWithDouble:0.1];
        _textSize = [NSNumber numberWithInt:14];
        textColor = [UIColor darkGrayColor];
        drawColor = [UIColor darkGrayColor];
        fillColor = [UIColor clearColor];
        _pageWidth = [NSNumber numberWithInt:612];
        _pageHeight = [NSNumber numberWithInt:792];
        _pageCount = [NSNumber numberWithInt:0];
        _textAlign = @"left";
        _textVerticalAlign = @"top";
        
        if(context != NULL) {
            // Close the old PDF context if exists and write the contents out.
            UIGraphicsEndPDFContext();
            // Sets null
            context = NULL;
        }
        
        [self rememberSelf];
    }
    return self;
}

-(void)openPDF:(id)args
{
    if(args != NULL && [args count] > 0) {
        NSString *pdfPath = [args objectAtIndex:0];
        
        if(pdfPath == nil || (pdfPath != nil && [pdfPath isEqualToString:@""])) {
            NSLog(@"[ERROR] PDF path is required.");
            
        } else {
            // if a PDF is being being created
            if(context != NULL) {
                // Close the PDF context and write the contents out.
                UIGraphicsEndPDFContext();
                // Release context
                context = NULL;
                
            } else {
                if( _pdfName == nil || [_pdfName isEqualToString:@""] ) {
                    _pdfName = @"output";
                }
            }
            
            NSArray *arrayPaths =
            NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                NSUserDomainMask,
                                                YES);
            NSString *path = [arrayPaths objectAtIndex:0];
            NSString* pdfFileName = [path stringByAppendingPathComponent:[_pdfName stringByAppendingString:@".pdf"]];
            
            // Create the PDF context using the default page size of 612 x 792
            UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, props);
            context = UIGraphicsGetCurrentContext();
            
            // Reset pageCount and gets new context
            _pageCount = [NSNumber numberWithInt:0];
            
            CFURLRef url = CFURLCreateWithFileSystemPath (NULL, (CFStringRef)pdfPath, kCFURLPOSIXPathStyle, 0);
            // Open PDF File
            CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithURL(url);
            // Release
            CFRelease(url);
            // Get amount of pages
            size_t count = CGPDFDocumentGetNumberOfPages(pdfRef);
            // For each page
            for(size_t pageNumber = 1; pageNumber <= count; pageNumber++) {
                // Get bounds of template page
                CGPDFPageRef templatePage = CGPDFDocumentGetPage(pdfRef, pageNumber);
                CGRect templatePageBounds = CGPDFPageGetBoxRect(templatePage, kCGPDFCropBox);
                
                // Keep template page width and height
                UIGraphicsBeginPDFPageWithInfo(templatePageBounds, nil);
                
                // Flip context due to different origins
                CGContextTranslateCTM(context, 0, templatePageBounds.size.height);
                CGContextScaleCTM(context, 1.0f, -1.0f);
                
                // Copy content of template page on the corresponding page in new file
                CGContextDrawPDFPage(context, templatePage);
                
                // Increment page count
                _pageCount = [NSNumber numberWithInt:[_pageCount intValue] + 1];
                
                // Flip context back
                CGContextTranslateCTM(context, 0, templatePageBounds.size.height);
                CGContextScaleCTM(context, 1.0f, -1.0f);
            }
            // Release PDF
            CGPDFDocumentRelease(pdfRef);
        }
        
    } else {
        NSLog(@"[ERROR] Incorrect number of parameters for function openPDF.");
    }
}

-(void)setProperties:(id)args
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    // Time to boring validation
    if(args != NULL && [[args objectForKey:@"pdfName"] isKindOfClass:[NSString class]]) {
        _pdfName = [args objectForKey:@"pdfName"];
    }
    if(args != NULL && [[args objectForKey:@"author"] isKindOfClass:[NSString class]]) {
        [dictionary setObject:(NSString *)[args objectForKey:@"author"] forKey:(NSString *)kCGPDFContextAuthor];
    }
    if(args != NULL && [[args objectForKey:@"title"] isKindOfClass:[NSString class]]) {
        [dictionary setObject:(NSString *)[args objectForKey:@"title"] forKey:(NSString *)kCGPDFContextTitle];
    }
    if(args != NULL && [[args objectForKey:@"subject"] isKindOfClass:[NSString class]]) {
        [dictionary setObject:(NSString *)[args objectForKey:@"subject"] forKey:(NSString *)kCGPDFContextSubject];
    }
    if(args != NULL && [[args objectForKey:@"keywords"] isKindOfClass:[NSString class]]) {
        [dictionary setObject:(NSString *)[args objectForKey:@"keywords"] forKey:(NSString *)kCGPDFContextKeywords];
    }
    if(args != NULL && [[args objectForKey:@"creator"] isKindOfClass:[NSString class]]) {
        [dictionary setObject:(NSString *)[args objectForKey:@"creator"] forKey:(NSString *)kCGPDFContextCreator];
    }
    
    props = [dictionary copy];
}
-(NSDictionary *)getProperties:(id)args
{
    NSString *title = [props objectForKey:(NSString *)kCGPDFContextAuthor];
    NSString *author = [props objectForKey:(NSString *)kCGPDFContextTitle];
    NSString *subject = [props objectForKey:(NSString *)kCGPDFContextSubject];
    NSString *keywords = [props objectForKey:(NSString *)kCGPDFContextKeywords];
    NSString *creator = [props objectForKey:(NSString *)kCGPDFContextCreator];
    
    return @{@"pdfName":_pdfName,
             @"title":title,
             @"author":author,
             @"subject":subject,
             @"keywords":keywords,
             @"creator":creator};
}

-(void)addNewPage:(id)args
{
    if(context != NULL) {
        
        // Mark the beginning of a new page.
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, [_pageWidth intValue], [_pageHeight intValue]), nil);
        
        _pageCount = [NSNumber numberWithInt:[_pageCount intValue] + 1];
        
    } else {
        if( _pdfName == nil || [_pdfName isEqualToString:@""] ) {
            _pdfName = @"output";
        }
        
        NSArray *arrayPaths =
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                            NSUserDomainMask,
                                            YES);
        NSString *path = [arrayPaths objectAtIndex:0];
        NSString* pdfFileName = [path stringByAppendingPathComponent:[_pdfName stringByAppendingString:@".pdf"]];
        
        // If the file exists, delete it, actually it's not a problem b'coz CoreGraphics library
        // detect it and handle everything for us but just in case
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if([fileManager fileExistsAtPath:pdfFileName]) {
            NSError *error = nil;
            [fileManager removeItemAtPath:pdfFileName error: &error];
        }
        
        // Create the PDF context using the default page size of 612 x 792.
        UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, props);
        context = UIGraphicsGetCurrentContext();
        
        // Mark the beginning of a new page.
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, [_pageWidth intValue], [_pageHeight intValue]), nil);
        
        _pageCount = [NSNumber numberWithInt:[_pageCount intValue] + 1];
    }
}

-(void)deletePage:(id)args
{
    if(args != NULL && [args count] > 0) {
        NSNumber *pageToDelete = NULL;
        
        // Time to boring validation
        if([[args objectAtIndex:0] isKindOfClass:[NSNumber class]]) {
            pageToDelete = [args objectAtIndex:0];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the first argument.");
        }
        
        // Is everything ok?
        if(pageToDelete != NULL) {
            if(pageToDelete > _pageCount || pageToDelete < [NSNumber numberWithInt:1]) {
                NSLog(@"[ERROR] Can't delete a page that doesn't exist. Wrong index.");
                
            } else {
                // if a PDF is being being created
                if(context != NULL) {
                    // Close the PDF context and write the contents out.
                    UIGraphicsEndPDFContext();
                    // Sets null
                    context = NULL;
                }
                
                // Rename pdf file
                NSArray *arrayPaths =
                NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                    NSUserDomainMask,
                                                    YES);
                
                NSString *path = [arrayPaths objectAtIndex:0];
                
                NSString *pdfPath = [path stringByAppendingPathComponent:[_pdfName stringByAppendingString:@".pdf"]];
                NSString *tmpPath = [path stringByAppendingPathComponent:@"tmpPdfFile.pdf"];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSError *error = nil;
                
                // just in case
                if([fileManager fileExistsAtPath:tmpPath]) {
                    [fileManager removeItemAtPath:tmpPath error: &error];
                }
                
                // Rename file to a temporary name and then recreate pdf
                if([fileManager moveItemAtPath:pdfPath toPath:tmpPath error: &error]) {
                    
                    // Create the PDF context using the default page size of 612 x 792
                    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, props);
                    context = UIGraphicsGetCurrentContext();
                    
                    // Reset pageCount and gets new context
                    _pageCount = [NSNumber numberWithInt:0];
                    
                    CFURLRef url = CFURLCreateWithFileSystemPath (NULL, (CFStringRef)tmpPath, kCFURLPOSIXPathStyle, 0);
                    // Open PDF File
                    CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithURL(url);
                    // Release URL
                    CFRelease(url);
                    // Get amount of pages
                    size_t count = CGPDFDocumentGetNumberOfPages(pdfRef);
                    // For each page
                    for(size_t pageNumber = 1; pageNumber <= count; pageNumber++) {
                        // Copy all pages except the one to be deleted
                        if(pageNumber != [pageToDelete unsignedLongValue]) {
                            // Get bounds of template page
                            CGPDFPageRef templatePage = CGPDFDocumentGetPage(pdfRef, pageNumber);
                            CGRect templatePageBounds = CGPDFPageGetBoxRect(templatePage, kCGPDFCropBox);
                            
                            // Keep template page width and height
                            UIGraphicsBeginPDFPageWithInfo(templatePageBounds, nil);
                            
                            // Flip context due to different origins
                            CGContextTranslateCTM(context, 0, templatePageBounds.size.height);
                            CGContextScaleCTM(context, 1.0f, -1.0f);
                            
                            // Copy content of template page on the corresponding page in new file
                            CGContextDrawPDFPage(context, templatePage);
                            
                            // Increment page count
                            _pageCount = [NSNumber numberWithInt:[_pageCount intValue] + 1];
                            
                            // Flip context back
                            CGContextTranslateCTM(context, 0, templatePageBounds.size.height);
                            CGContextScaleCTM(context, 1.0f, -1.0f);
                        }
                    }
                    // Release PDF
                    CGPDFDocumentRelease(pdfRef);
                    
                    // Delete PDF tmp file
                    if([fileManager fileExistsAtPath:tmpPath]) {
                        [fileManager removeItemAtPath:tmpPath error: &error];
                    }
                    
                } else {
                    NSLog(@"[ERROR] Could not rename file to a temporary name. %@", error.localizedDescription);
                }
            }
        }
        
    } else {
        NSLog(@"[ERROR] Incorrect number of parameters for function deletePage.");
    }
}

-(void)forEachPage:(id)args
{
    if(args != NULL && [args count] > 0 && [[args objectAtIndex:0] isKindOfClass:[KrollCallback class]]) {
        
        // Callback from JS applied to each page
        KrollCallback *callback = [args objectAtIndex:0];
        
        // Actually I don't know how to correctly validate this, I guess is this way
        if(callback) {
            // if a PDF is being being created
            if(context != NULL) {
                // Close the PDF context and write the contents out.
                UIGraphicsEndPDFContext();
                // Sets null
                context = NULL;
            }
            
            // Rename pdf file
            NSArray *arrayPaths =
            NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                NSUserDomainMask,
                                                YES);
            
            NSString *path = [arrayPaths objectAtIndex:0];
            
            NSString *pdfPath = [path stringByAppendingPathComponent:[_pdfName stringByAppendingString:@".pdf"]];
            NSString *tmpPath = [path stringByAppendingPathComponent:@"tmpPdfFile.pdf"];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error = nil;
            
            // just in case
            if([fileManager fileExistsAtPath:tmpPath]) {
                [fileManager removeItemAtPath:tmpPath error: &error];
            }
            
            // Rename file to a temporary name and then recreate pdf
            if([fileManager moveItemAtPath:pdfPath toPath:tmpPath error: &error]) {
                
                // Create the PDF context using the default page size of 612 x 792
                UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, props);
                context = UIGraphicsGetCurrentContext();
                
                // Reset pageCount and gets new context
                _pageCount = [NSNumber numberWithInt:0];
                
                // Open PDF File
                CFURLRef url = CFURLCreateWithFileSystemPath (NULL, (CFStringRef)tmpPath, kCFURLPOSIXPathStyle, 0);
                CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithURL(url);
                CFRelease(url);
                
                // Get amount of pages
                size_t count = CGPDFDocumentGetNumberOfPages(pdfRef);
                
                // For each page
                for(size_t pageNumber = 1; pageNumber <= count; pageNumber++) {
                    // Get bounds of template page
                    CGPDFPageRef templatePage = CGPDFDocumentGetPage(pdfRef, pageNumber);
                    CGRect templatePageBounds = CGPDFPageGetBoxRect(templatePage, kCGPDFCropBox);
                    
                    // Keep template page width and height
                    UIGraphicsBeginPDFPageWithInfo(templatePageBounds, nil);
                    
                    // Flip context due to different origins
                    CGContextTranslateCTM(context, 0.0f, templatePageBounds.size.height);
                    CGContextScaleCTM(context, 1.0f, -1.0f);
                    
                    // Copy content of template page on the corresponding page in new file
                    CGContextDrawPDFPage(context, templatePage);
                    
                    // Increment page count
                    _pageCount = [NSNumber numberWithInt:[_pageCount intValue] + 1];
                    
                    // Flip context back
                    CGContextTranslateCTM(context, 0.0f, templatePageBounds.size.height);
                    CGContextScaleCTM(context, 1.0f, -1.0f);
                    
                    // Callback JS function
                    NSArray *obj = @[@{
                      @"page" : [NSNumber numberWithUnsignedLong:pageNumber],
                      @"total": [NSNumber numberWithUnsignedLong:count]
                    }];
                    
                    [callback call:obj thisObject:nil];
                }
                // Release PDF
                CGPDFDocumentRelease(pdfRef);
                
                // Delete PDF tmp file
                if([fileManager fileExistsAtPath:tmpPath]) {
                    [fileManager removeItemAtPath:tmpPath error: &error];
                }
                
            } else {
                NSLog(@"[ERROR] Could not rename file to a temporary name. %@", error.localizedDescription);
            }
        } else {
            NSLog(@"[ERROR] Callback function not found.");
        }
        
    } else if(args != NULL && [args count] > 0 && [[args objectAtIndex:0] isKindOfClass:[NSArray class]]) {
        // drawing functions
        NSArray *json = [args objectAtIndex:0];
        
        for(unsigned long i = 0, len = json.count; i < len; i++) {
            if([json[i] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *obj = json[i];
                NSString *command = NULL;
                
                @try {
                    command = [obj objectForKey:@"action"];
                    id argsAction = [obj objectForKey:@"args"];
                    
                    if([command isEqualToString:@"setTextSize"] && [argsAction count] > 0) {
                        [self setTextSize:[argsAction objectAtIndex:0]];
                    }
                    else if([command isEqualToString:@"setPdfName"] && [argsAction count] > 0) {
                        [self setPdfName:[argsAction objectAtIndex:0]];
                    }
                    else if([command isEqualToString:@"setFontName"] && [argsAction count] > 0) {
                        [self setFontName:[argsAction objectAtIndex:0]];
                    }
                    else if([command isEqualToString:@"setLineWidth"] && [argsAction count] > 0) {
                        [self setLineWidth:[argsAction objectAtIndex:0]];
                    }
                    else if([command isEqualToString:@"setTextAlign"] && [argsAction count] > 0) {
                        [self setTextAlign:[argsAction objectAtIndex:0]];
                    }
                    else if([command isEqualToString:@"setTextVerticalAlign"] && [argsAction count] > 0) {
                        [self setTextVerticalAlign:[argsAction objectAtIndex:0]];
                    }
                    else if([command isEqualToString:@"setPageWidth"] && [argsAction count] > 0) {
                        [self setPageWidth:[argsAction objectAtIndex:0]];
                    }
                    else if([command isEqualToString:@"setPageHeight"] && [argsAction count] > 0) {
                        [self setPageHeight:[argsAction objectAtIndex:0]];
                    }
                    else if([command isEqualToString:@"setTextColor"]) {
                        [self setTextColor:argsAction];
                    }
                    else if([command isEqualToString:@"setDrawColor"]) {
                        [self setDrawColor:argsAction];
                    }
                    else if([command isEqualToString:@"setFillColor"]) {
                        [self setFillColor:argsAction];
                    }
                    else if([command isEqualToString:@"drawText"]) {
                        [self drawText:argsAction];
                    }
                    else if([command isEqualToString:@"drawLine"]) {
                        [self drawLine:argsAction];
                    }
                    else if([command isEqualToString:@"drawRect"]) {
                        [self drawRect:argsAction];
                    }
                    else if([command isEqualToString:@"drawImage"]) {
                        [self drawImage:argsAction];
                    }
                    else if([command isEqualToString:@"drawEllipse"]) {
                        [self drawEllipse:argsAction];
                    }
                    else if([command isEqualToString:@"addURL"]) {
                        [self addURL:argsAction];
                    }
                    else {
                        NSLog(@"[ERROR] Unknnow command for function forEachPage.");
                    }
                }
                @catch (NSException *exception) {
                    if(command != NULL) {
                        NSLog(@"[ERROR] %@, action: %@", exception.reason, command);
                    } else {
                        NSLog(@"[ERROR] %@", exception.reason);
                    }
                }
            }
        }
    }
    else {
        NSLog(@"[ERROR] Incorrect number of parameters for function forEachPage.");
    }
}

-(void)setTextColor:(id)args
{
    if(args != NULL && [args count] == 3) {
        NSNumber* red = NULL;
        NSNumber* green = NULL;
        NSNumber* blue = NULL;
        
        // Time to boring validation
        if([[args objectAtIndex:0] isKindOfClass:[NSNumber class]]) {
            red = [args objectAtIndex:0];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the first argument.");
        }
        if([[args objectAtIndex:1] isKindOfClass:[NSNumber class]]) {
            green = [args objectAtIndex:1];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the second argument.");
        }
        if([[args objectAtIndex:2] isKindOfClass:[NSNumber class]]) {
            blue = [args objectAtIndex:2];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the third argument.");
        }
        
        // Is everything ok?
        if(red != NULL && green != NULL && blue != NULL) {
            textColor = [UIColor colorWithRed:(red.intValue/255.0) green:(green.intValue/255.0) blue:(blue.intValue/255.0) alpha:1.0];
        }
        
    }
    else if(args != NULL && [args count] == 4) {
        NSNumber* red = NULL;
        NSNumber* green = NULL;
        NSNumber* blue = NULL;
        NSNumber* alpha = NULL;
        
        // Time to boring validation
        if([[args objectAtIndex:0] isKindOfClass:[NSNumber class]]) {
            red = [args objectAtIndex:0];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the first argument.");
        }
        if([[args objectAtIndex:1] isKindOfClass:[NSNumber class]]) {
            green = [args objectAtIndex:1];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the second argument.");
        }
        if([[args objectAtIndex:2] isKindOfClass:[NSNumber class]]) {
            blue = [args objectAtIndex:2];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the third argument.");
        }
        if([[args objectAtIndex:3] isKindOfClass:[NSNumber class]]) {
            alpha = [args objectAtIndex:3];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the fourth argument. %d");
        }
        
        // Is everything ok?
        if(red != NULL && green != NULL && blue != NULL && alpha != NULL) {
            textColor = [UIColor colorWithRed:(red.intValue/255.0) green:(green.intValue/255.0) blue:(blue.intValue/255.0) alpha:alpha.doubleValue];
        }
        
    }
    else {
        NSLog(@"[ERROR] Incorrect number of parameters for function setTextColor.");
    }
}
-(void)setDrawColor:(id)args
{
    if(args != NULL && [args count] == 3) {
        NSNumber* red = NULL;
        NSNumber* green = NULL;
        NSNumber* blue = NULL;
        
        // Time to boring validation
        if([[args objectAtIndex:0] isKindOfClass:[NSNumber class]]) {
            red = [args objectAtIndex:0];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the first argument.");
        }
        if([[args objectAtIndex:1] isKindOfClass:[NSNumber class]]) {
            green = [args objectAtIndex:1];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the second argument.");
        }
        if([[args objectAtIndex:2] isKindOfClass:[NSNumber class]]) {
            blue = [args objectAtIndex:2];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the third argument.");
        }
        
        // Is everything ok?
        if(red != NULL && green != NULL && blue != NULL) {
            drawColor = [UIColor colorWithRed:(red.intValue/255.0) green:(green.intValue/255.0) blue:(blue.intValue/255.0) alpha:1.0];
        }
        
    }
    else if(args != NULL && [args count] == 4) {
        NSNumber* red = NULL;
        NSNumber* green = NULL;
        NSNumber* blue = NULL;
        NSNumber* alpha = NULL;
        
        // Time to boring validation
        if([[args objectAtIndex:0] isKindOfClass:[NSNumber class]]) {
            red = [args objectAtIndex:0];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the first argument.");
        }
        if([[args objectAtIndex:1] isKindOfClass:[NSNumber class]]) {
            green = [args objectAtIndex:1];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the second argument.");
        }
        if([[args objectAtIndex:2] isKindOfClass:[NSNumber class]]) {
            blue = [args objectAtIndex:2];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the third argument.");
        }
        if([[args objectAtIndex:3] isKindOfClass:[NSNumber class]]) {
            alpha = [args objectAtIndex:3];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the fourth argument. %d");
        }
        
        // Is everything ok?
        if(red != NULL && green != NULL && blue != NULL && alpha != NULL) {
            drawColor = [UIColor colorWithRed:(red.intValue/255.0) green:(green.intValue/255.0) blue:(blue.intValue/255.0) alpha:alpha.doubleValue];
        }
        
    }
    else {
        NSLog(@"[ERROR] Incorrect number of parameters for function setDrawColor.");
    }
}
-(void)setFillColor:(id)args
{
    if(args != NULL && [args count] == 3) {
        NSNumber* red = NULL;
        NSNumber* green = NULL;
        NSNumber* blue = NULL;
        
        // Time to boring validation
        if([[args objectAtIndex:0] isKindOfClass:[NSNumber class]]) {
            red = [args objectAtIndex:0];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the first argument.");
        }
        if([[args objectAtIndex:1] isKindOfClass:[NSNumber class]]) {
            green = [args objectAtIndex:1];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the second argument.");
        }
        if([[args objectAtIndex:2] isKindOfClass:[NSNumber class]]) {
            blue = [args objectAtIndex:2];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the third argument.");
        }
        
        // Is everything ok?
        if(red != NULL && green != NULL && blue != NULL) {
            fillColor = [UIColor colorWithRed:(red.intValue/255.0) green:(green.intValue/255.0) blue:(blue.intValue/255.0) alpha:1.0];
        }
    }
    else if(args != NULL && [args count] == 4) {
        NSNumber* red = NULL;
        NSNumber* green = NULL;
        NSNumber* blue = NULL;
        NSNumber* alpha = NULL;
        
        // Time to boring validation
        if([[args objectAtIndex:0] isKindOfClass:[NSNumber class]]) {
            red = [args objectAtIndex:0];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the first argument.");
        }
        if([[args objectAtIndex:1] isKindOfClass:[NSNumber class]]) {
            green = [args objectAtIndex:1];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the second argument.");
        }
        if([[args objectAtIndex:2] isKindOfClass:[NSNumber class]]) {
            blue = [args objectAtIndex:2];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the third argument.");
        }
        if([[args objectAtIndex:3] isKindOfClass:[NSNumber class]]) {
            alpha = [args objectAtIndex:3];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the fourth argument. %d");
        }
        
        // Is everything ok?
        if(red != NULL && green != NULL && blue != NULL && alpha != NULL) {
            fillColor = [UIColor colorWithRed:(red.intValue/255.0) green:(green.intValue/255.0) blue:(blue.intValue/255.0) alpha:alpha.doubleValue];
        }
        
    }
    else {
        NSLog(@"[ERROR] Incorrect number of parameters for function setFillColor.");
    }
}

-(NSNumber *)getTextHeightForRect:(id)args
{
    if(args != NULL && [args count] == 2) {
        NSString *text = NULL;
        NSNumber *width = NULL;
        
        // Parameter type validation
        if([[args objectAtIndex:0] isKindOfClass:[NSString class]]) {
            text = [args objectAtIndex:0];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected String for the first argument.");
        }
        if([[args objectAtIndex:1] isKindOfClass:[NSNumber class]]) {
            width = [args objectAtIndex:1];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the second argument.");
        }
        
        // is everything ok?
        if(text != NULL && width != NULL) {
            
            // Text align
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            
            if([_textAlign isEqualToString:@"left"]) {
                [paragraphStyle setAlignment:NSTextAlignmentLeft];
            }
            else if([_textAlign isEqualToString:@"center"]) {
                [paragraphStyle setAlignment:NSTextAlignmentCenter];
            }
            else if([_textAlign isEqualToString:@"right"]) {
                [paragraphStyle setAlignment:NSTextAlignmentRight];
            }
            else if([_textAlign isEqualToString:@"justified"]) {
                [paragraphStyle setAlignment:NSTextAlignmentJustified];
            }
            else {
                [paragraphStyle setAlignment:NSTextAlignmentLeft];
            }
            
            CGRect textSize = [text boundingRectWithSize:CGSizeMake([width floatValue], CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:_fontName size:[_textSize intValue]]} context:nil];
            
            return [NSNumber numberWithFloat: textSize.size.height * 1.1];
        }
        
    } else {
        NSLog(@"[ERROR] Incorrect number of parameters for function getTextHeightForRect");
    }
    
    return [NSNumber numberWithInt:0];
}

-(void)drawText:(id)args
{
    if(args != NULL && [args count] >= 3) {
        
        NSString* textToDraw = NULL;
        NSNumber* xArg = NULL;
        NSNumber* yArg = NULL;
        NSNumber* widthArg = NULL;
        NSNumber* heightArg = NULL;
        
        // Time to boring validation
        if([[args objectAtIndex:0] isKindOfClass:[NSString class]]) {
            textToDraw = [args objectAtIndex:0];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected String for the first argument.");
        }
        if([[args objectAtIndex:1] isKindOfClass:[NSNumber class]]) {
            xArg = [args objectAtIndex:1];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the second argument.");
        }
        if([[args objectAtIndex:2] isKindOfClass:[NSNumber class]]) {
            yArg = [args objectAtIndex:2];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the third argument.");
        }
        if([[args objectAtIndex:3] isKindOfClass:[NSNumber class]]) {
            widthArg = [args objectAtIndex:3];
        } else {
            NSLog(@"[WARN] Wrong type of parameter, expected Number for the fourth argument, automatic width will be used instead");
        }
        if([[args objectAtIndex:4] isKindOfClass:[NSNumber class]]) {
            heightArg = [args objectAtIndex:4];
        } else {
            NSLog(@"[WARN] Wrong type of parameter, expected Number for the fifth argument, automatic text height will be used instead.");
        }
        
        // Is everything ok?
        if(textToDraw != NULL && xArg != NULL && yArg != NULL) {
            // Add new page if needed
            if(context == NULL) {
                [self addNewPage:NULL];
            }
            
            // Text align
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            
            if([_textAlign isEqualToString:@"left"]) {
                [paragraphStyle setAlignment:NSTextAlignmentLeft];
            }
            else if([_textAlign isEqualToString:@"center"]) {
                [paragraphStyle setAlignment:NSTextAlignmentCenter];
            }
            else if([_textAlign isEqualToString:@"right"]) {
                [paragraphStyle setAlignment:NSTextAlignmentRight];
            }
            else if([_textAlign isEqualToString:@"justified"]) {
                [paragraphStyle setAlignment:NSTextAlignmentJustified];
            }
            else {
                [paragraphStyle setAlignment:NSTextAlignmentLeft];
            }
            
            // Prepare the text using a Core Text Framesetter
            CTFontRef fontRef = CTFontCreateWithName((CFStringRef)_fontName, [_textSize intValue], NULL);
            NSDictionary *attDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                           (__bridge_transfer id)fontRef, (NSString *)kCTFontAttributeName,
                                           (id)[textColor CGColor], (NSString *)kCTForegroundColorAttributeName,
                                           (id)paragraphStyle, (NSString *)kCTParagraphStyleAttributeName,
                                           nil];
            
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:textToDraw attributes:attDictionary];
            
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge_retained CFAttributedStringRef)attString);
            
            // Text settings
            CGRect frameRect = CGRectMake(xArg.intValue, yArg.intValue + heightArg.intValue, widthArg.intValue, heightArg.intValue);;
            
            // Unfortunately doesn't work well for all text fonts
            if(heightArg == NULL || widthArg == NULL) {
                CGSize textSize = [textToDraw sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:_fontName size:[_textSize intValue]], NSParagraphStyleAttributeName: paragraphStyle}];
                
                if(heightArg == NULL) {
                    heightArg = [NSNumber numberWithInt:textSize.height];
                }
                
                if(widthArg == NULL) {
                    widthArg = [_pageWidth intValue] - [xArg intValue] > 0 ? [NSNumber numberWithInt:[_pageWidth intValue] - [xArg intValue]] : [NSNumber numberWithInt:textSize.width];
                }
                
            } else if([_textVerticalAlign isEqualToString:@"bottom"]) {
                CGSize textSize = [textToDraw sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:_fontName size:[_textSize intValue]], NSParagraphStyleAttributeName: paragraphStyle}];
                
                frameRect.origin.y = frameRect.origin.y + frameRect.size.height - textSize.height;
                
            } else if([_textVerticalAlign isEqualToString:@"middle"]) {
                CGSize textSize = [textToDraw sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:_fontName size:[_textSize intValue]], NSParagraphStyleAttributeName: paragraphStyle}];
                
                frameRect.origin.y = frameRect.origin.y + (frameRect.size.height - textSize.height) / 2;
                
            }
            
            CGMutablePathRef framePath = CGPathCreateMutable();
            CGPathAddRect(framePath, NULL, frameRect);
            
            // Get the frame that will do the rendering.
            CFRange currentRange = CFRangeMake(0, 0);
            CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
            CGPathRelease(framePath);
            
            // Put the text matrix into a known state. This ensures
            // that no old scaling factors are left in place
            CGContextSetTextMatrix(context, CGAffineTransformIdentity);
            
            // Core Text draws from the bottom-left corner up, so flip
            // the current transform prior to drawing.
            CGContextTranslateCTM(context, 0, frameRect.origin.y*2);
            CGContextScaleCTM(context, 1.0f, -1.0f);
            
            // Draw the frame
            CTFrameDraw(frameRef, context);
            
            // Return context to it's default matrix transform
            CGContextScaleCTM(context, 1.0f, -1.0f);
            CGContextTranslateCTM(context, 0, (-1)*frameRect.origin.y*2);
            
            CFRelease(frameRef);
            CFRelease(framesetter);
            
        } else {
            NSLog(@"[ERROR] Incorrect parameters for function drawText");
        }
        
    } else {
        NSLog(@"[ERROR] Incorrect number of parameters for function drawText");
    }
}

-(void)drawLine:(id)args
{
    if(args != NULL && [args count] == 4) {
        
        NSNumber* xStart = NULL;
        NSNumber* yStart = NULL;
        NSNumber* xEnd = NULL;
        NSNumber* yEnd = NULL;
        
        // Time to boring validation
        if([[args objectAtIndex:0] isKindOfClass:[NSNumber class]]) {
            xStart = [args objectAtIndex:0];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the first argument.");
        }
        if([[args objectAtIndex:1] isKindOfClass:[NSNumber class]]) {
            yStart = [args objectAtIndex:1];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the second argument.");
        }
        if([[args objectAtIndex:2] isKindOfClass:[NSNumber class]]) {
            xEnd = [args objectAtIndex:2];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the third argument.");
        }
        if([[args objectAtIndex:3] isKindOfClass:[NSNumber class]]) {
            yEnd = [args objectAtIndex:3];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the fourth argument. %d");
        }
        
        // Is everything ok?
        if(xStart != NULL && yStart != NULL && xEnd != NULL && yEnd != NULL) {
            // Add new page if needed
            if(context == NULL) {
                [self addNewPage:NULL];
            }
            
            CGPoint from = CGPointMake(xStart.intValue, yStart.intValue);
            CGPoint to = CGPointMake(xEnd.intValue, yEnd.intValue);
            
            CGContextSetLineWidth(context, _lineWidth.doubleValue);
            
            CGContextSetStrokeColorWithColor(context, [drawColor CGColor]);
            
            CGContextMoveToPoint(context, from.x, from.y);
            CGContextAddLineToPoint(context, to.x, to.y);
            
            CGContextStrokePath(context);
        }
        
    } else {
        NSLog(@"[ERROR] Incorrect number of parameters for function drawLine.");
    }
}

-(void)drawRect:(id)args
{
    if(args != NULL && [args count] == 4) {
        
        NSNumber* xArg = NULL;
        NSNumber* yArg = NULL;
        NSNumber* widthArg = NULL;
        NSNumber* heightArg = NULL;
        
        // Time to boring validation
        if([[args objectAtIndex:0] isKindOfClass:[NSNumber class]]) {
            xArg = [args objectAtIndex:0];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the first argument.");
        }
        if([[args objectAtIndex:1] isKindOfClass:[NSNumber class]]) {
            yArg = [args objectAtIndex:1];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the second argument.");
        }
        if([[args objectAtIndex:2] isKindOfClass:[NSNumber class]]) {
            widthArg = [args objectAtIndex:2];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the third argument.");
        }
        if([[args objectAtIndex:3] isKindOfClass:[NSNumber class]]) {
            heightArg = [args objectAtIndex:3];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the fourth argument.");
        }
        
        // Is everything ok?
        if(xArg != NULL && yArg != NULL && widthArg != NULL && heightArg != NULL) {
            // Add new page if needed
            if(context == NULL) {
                [self addNewPage:NULL];
            }
            CGRect rectangle = CGRectMake(xArg.intValue, yArg.intValue, widthArg.intValue, heightArg.intValue);
            
            CGContextSetLineWidth(context, _lineWidth.doubleValue);
            CGContextSetStrokeColorWithColor(context, [drawColor CGColor]);
            CGContextAddRect(context, rectangle);
            CGContextStrokePath(context);
            
            CGContextSetFillColorWithColor(context, [fillColor CGColor]);
            CGContextFillRect(context, rectangle);
            
        } else {
            NSLog(@"[ERROR] All parameters for drawRect were null.");
        }
        
    } else {
        NSLog(@"[ERROR] Incorrect number of parameters for function drawRect.");
    }
}

-(void)drawImage:(id)args
{
    if(args != NULL && ([args count] == 5 || [args count] == 6) ) {
        NSString* imgPath = NULL;
        NSNumber* xArg = NULL;
        NSNumber* yArg = NULL;
        NSNumber* widthArg = NULL;
        NSNumber* heightArg = NULL;
        NSString* defaultImage = NULL;
        
        // Time to boring validation
        if([[args objectAtIndex:0] isKindOfClass:[NSString class]]) {
            imgPath = [args objectAtIndex:0];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected String for the first argument.");
        }
        if([[args objectAtIndex:1] isKindOfClass:[NSNumber class]]) {
            xArg = [args objectAtIndex:1];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the second argument.");
        }
        if([[args objectAtIndex:2] isKindOfClass:[NSNumber class]]) {
            yArg = [args objectAtIndex:2];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the third argument.");
        }
        if([[args objectAtIndex:3] isKindOfClass:[NSNumber class]]) {
            widthArg = [args objectAtIndex:3];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the fourth argument.");
        }
        if([[args objectAtIndex:4] isKindOfClass:[NSNumber class]]) {
            heightArg = [args objectAtIndex:4];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the fifth argument.");
        }
        
        if([args count] == 6 && [[args objectAtIndex:5] isKindOfClass:[NSString class]]) {
            defaultImage = [args objectAtIndex:5];
        }
        
        // Is everything ok?
        if(imgPath != NULL && xArg != NULL && yArg != NULL && widthArg != NULL && heightArg != NULL) {
            // Add new page if needed
            if(context == NULL) {
                [self addNewPage:NULL];
            }
            
            // if it's from web we need to download it
            if([imgPath hasPrefix:@"http://"] || [imgPath hasPrefix:@"https://"]) {
                NSURL *url = [NSURL URLWithString:imgPath];
                
                NSError* error = NULL;
                NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
                
                if (error != NULL) {
                    if(defaultImage != NULL) {
                        defaultImage = [defaultImage stringByReplacingOccurrencesOfString:@"file://" withString:@""];
                        data = [NSData dataWithContentsOfFile:defaultImage];
                    } else {
                        NSLog(@"[ERROR] Failed to convert path to data and default image does not exist.");
                    }
                }
                
                UIImage *image = [[UIImage alloc] initWithData:data];
                
                CGRect rect = CGRectMake(xArg.intValue, yArg.intValue, widthArg.intValue, heightArg.intValue);
                [image drawInRect:rect];
                
            } else {
                // Remove "file://" from path
                imgPath = [imgPath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
                
                NSError* error = NULL;
                NSData *data = [NSData dataWithContentsOfFile:imgPath options:NSDataReadingUncached error:&error];
                
                if (error != NULL) {
                    if(defaultImage != NULL) {
                        defaultImage = [defaultImage stringByReplacingOccurrencesOfString:@"file://" withString:@""];
                        data = [NSData dataWithContentsOfFile:defaultImage];
                    } else {
                        NSLog(@"[ERROR] Failed to convert path to data and default image does not exist.");
                    }
                }
                
                UIImage *image = [UIImage imageWithData:data];
                CGRect rect = CGRectMake(xArg.intValue, yArg.intValue, widthArg.intValue, heightArg.intValue);
                
                [image drawInRect:rect];
            }
            
        } else {
            NSLog(@"[ERROR] All parameters were null for function drawImage.");
        }
        
    } else {
        NSLog(@"[ERROR] Incorrect number of parameters for function drawImage.");
    }
}

-(void)drawEllipse:(id)args
{
    if(args != NULL && [args count] == 4) {
        
        NSNumber* xArg = NULL;
        NSNumber* yArg = NULL;
        NSNumber* widthArg = NULL;
        NSNumber* heightArg = NULL;
        
        // Time to boring validation
        if([[args objectAtIndex:0] isKindOfClass:[NSNumber class]]) {
            xArg = [args objectAtIndex:0];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the first argument.");
        }
        if([[args objectAtIndex:1] isKindOfClass:[NSNumber class]]) {
            yArg = [args objectAtIndex:1];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the second argument.");
        }
        if([[args objectAtIndex:2] isKindOfClass:[NSNumber class]]) {
            widthArg = [args objectAtIndex:2];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the third argument.");
        }
        if([[args objectAtIndex:3] isKindOfClass:[NSNumber class]]) {
            heightArg = [args objectAtIndex:3];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the fourth argument.");
        }
        
        // Is everything ok?
        if(xArg != NULL && yArg != NULL && widthArg != NULL && heightArg != NULL) {
            // Add new page if needed
            if(context == NULL) {
                [self addNewPage:NULL];
            }
            CGRect rectangle = CGRectMake(xArg.intValue, yArg.intValue, widthArg.intValue, heightArg.intValue);
            
            CGContextSetLineWidth(context, _lineWidth.doubleValue);
            CGContextSetStrokeColorWithColor(context, [drawColor CGColor]);
            
            CGContextAddEllipseInRect(context, rectangle);
            CGContextStrokePath(context);
            
            CGContextSetFillColorWithColor(context, [fillColor CGColor]);
            CGContextFillEllipseInRect(context, rectangle);
        }
        
    } else {
        NSLog(@"[ERROR] Incorrect number of parameters for function drawEllipse.");
    }
}

-(void)addURL:(id)args
{
    if(args != NULL && [args count] == 5) {
        
        NSString* strUrl = NULL;
        NSNumber* xArg = NULL;
        NSNumber* yArg = NULL;
        NSNumber* widthArg = NULL;
        NSNumber* heightArg = NULL;
        
        // Time to boring validation
        if([[args objectAtIndex:0] isKindOfClass:[NSString class]]) {
            strUrl = [args objectAtIndex:0];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected String for the first argument.");
        }
        if([[args objectAtIndex:1] isKindOfClass:[NSNumber class]]) {
            xArg = [args objectAtIndex:1];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the second argument.");
        }
        if([[args objectAtIndex:2] isKindOfClass:[NSNumber class]]) {
            yArg = [args objectAtIndex:2];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the third argument.");
        }
        if([[args objectAtIndex:3] isKindOfClass:[NSNumber class]]) {
            widthArg = [args objectAtIndex:3];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the fourth argument.");
        }
        if([[args objectAtIndex:4] isKindOfClass:[NSNumber class]]) {
            heightArg = [args objectAtIndex:4];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Number for the fifth argument.");
        }
        
        // Is everything ok?
        if(strUrl != NULL && xArg != NULL && yArg != NULL && widthArg != NULL && heightArg != NULL) {
            // Add new page if needed
            if(context == NULL) {
                [self addNewPage:NULL];
            }
            
            if(strUrl == nil || [strUrl isEqualToString:@""]) {
                NSLog(@"[ERROR] Empty URL.");
                
            } else {
                CGRect rect = CGRectMake([xArg intValue], [yArg intValue], [widthArg intValue], [heightArg intValue]);
                NSURL* url = [NSURL URLWithString:strUrl];
                // Cast wasn't working, now it should work
                CFURLRef cUrl = CFBridgingRetain(url);
                
                CGPDFContextSetURLForRect(context, cUrl, rect);
                // Please, don't crash
                CFRelease(cUrl);
            }
        }
        
    } else {
        NSLog(@"[ERROR] Incorrect number of parameters for function addURL.");
    }
}

-(void)cancelPDF:(id)args
{
    if(context != NULL) {
        // Close the PDF context and write the contents out.
        UIGraphicsEndPDFContext();
        
        // Release context
        context = NULL;
        
        // Reset everything
        _lineWidth = [NSNumber numberWithDouble:0.1];
        _textSize = [NSNumber numberWithInt:14];
        textColor = [UIColor darkGrayColor];
        drawColor = [UIColor darkGrayColor];
        fillColor = [UIColor clearColor];
        _pageWidth = [NSNumber numberWithInt:612];
        _pageHeight = [NSNumber numberWithInt:792];
        _pageCount = [NSNumber numberWithInt:0];
        _textAlign = @"left";
        _textVerticalAlign = @"top";
        
        // Remove file
        NSArray *arrayPaths =
        NSSearchPathForDirectoriesInDomains(
                                            NSDocumentDirectory,
                                            NSUserDomainMask,
                                            YES);
        
        NSString *path = [arrayPaths objectAtIndex:0];
        
        NSString *pdfPath = [path stringByAppendingPathComponent:[_pdfName stringByAppendingString:@".pdf"]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        
        if([fileManager fileExistsAtPath:pdfPath]) {
            [fileManager removeItemAtPath:pdfPath error: &error];
        }
        
        if(error != nil) {
            NSLog(@"[ERROR] Failed to delete file. %@", [error localizedDescription]);
        }
        
    } else {
        NSLog(@"[WARN] PDF generation has already finished.");
    }
}

-(void)savePDF:(id)args
{
    NSString *pdfName = NULL;
    NSString *pdfFileName = NULL;
    KrollCallback *callback = NULL;
    
    if(args != NULL && [args count] == 2) {
        if( [[args objectAtIndex:0] isKindOfClass:[NSString class]] ) {
            pdfName = [args objectAtIndex:0];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected String for first parameter.");
        }
        if( [[args objectAtIndex:1] isKindOfClass:[KrollCallback class]] ) {
            callback = [args objectAtIndex:1];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Callback for second parameter.");
        }
        
    } else if(args != NULL && [args count] == 1) {
        if( [[args objectAtIndex:0] isKindOfClass:[KrollCallback class]] ) {
            callback = [args objectAtIndex:0];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Callback parameter.");
        }
    } else {
        NSLog(@"[ERROR] Incorrect number of parameters for function savePDF.");
    }
    
    if(callback != NULL) {
        // Create the PDF context
        if(context == NULL) {
            if(pdfName != NULL) {
                _pdfName = pdfName;
            }
            else if( _pdfName == NULL || [_pdfName isEqualToString:@""] ) {
                _pdfName = @"output";
            }
            // Adds a blank page
            [self addNewPage:NULL];
        }
        
        // Close the PDF context and write the contents out
        UIGraphicsEndPDFContext();
        
        // Release context
        context = NULL;
        
        // If pdf name is null or is set a new PDF name
        if( pdfName != NULL && ![_pdfName isEqualToString:pdfName] ) {
            // Rename PDF file
            NSArray *arrayPaths =
            NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                NSUserDomainMask,
                                                YES);
            
            NSString *path = [arrayPaths objectAtIndex:0];
            
            NSString *oldPath = [path stringByAppendingPathComponent:[_pdfName stringByAppendingString:@".pdf"]];
            NSString *newPath = [path stringByAppendingPathComponent:[pdfName stringByAppendingString:@".pdf"]];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error = nil;
            
            if([fileManager fileExistsAtPath:newPath]) {
                [fileManager removeItemAtPath:newPath error: &error];
            }
            
            if(error != nil) {
                NSLog(@"[ERROR] Failed to delete file. %@", [error localizedDescription]);
                error = nil;
            }
            
            if([fileManager moveItemAtPath:oldPath toPath:newPath error: &error]) {
                pdfFileName = newPath;
            } else {
                pdfFileName = oldPath;
            }
            
            if(error != nil) {
                NSLog(@"[ERROR] Failed rename file. %@", [error localizedDescription]);
                error = nil;
            }
            
        } else {
            NSArray *arrayPaths =
            NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                NSUserDomainMask,
                                                YES);
            
            NSString *path = [arrayPaths objectAtIndex:0];
            
            pdfFileName = [path stringByAppendingPathComponent:[_pdfName stringByAppendingString:@".pdf"]];
        }
        
        // Fire callback event
        NSArray *obj = @[@{
          @"url" : pdfFileName,
        }];
        
        [callback call:obj thisObject:nil];
        
    } else {
         NSLog(@"[ERROR] Callback not found for method savePDF.");
    }
}


-(void)generateFromJSON:(id)args
{
    KrollCallback *callback = NULL;
    NSArray *json = NULL;
    
    if(args != NULL && [args count] == 2) {
        if( [[args objectAtIndex:0] isKindOfClass:[NSArray class]] ) {
            json = [args objectAtIndex:0];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Object for first parameter.");
        }
        if( [[args objectAtIndex:1] isKindOfClass:[KrollCallback class]] ) {
            callback = [args objectAtIndex:1];
        } else {
            NSLog(@"[ERROR] Wrong type of parameter, expected Callback for second parameter.");
        }
        
    } else {
        NSLog(@"[ERROR] Incorrect number of parameters for function generateFromJSON.");
    }
    
    if(callback != NULL) {
        
        for(unsigned long i = 0, len = json.count; i < len; i++) {
            if([json[i] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *obj = json[i];
                NSString *command = NULL;
                
                @try {
                    command = [obj objectForKey:@"action"];
                    id argsAction = [obj objectForKey:@"args"];
                    
                    if([command isEqualToString:@"setTextSize"] && [argsAction count] > 0) {
                        [self setTextSize:[argsAction objectAtIndex:0]];
                    }
                    else if([command isEqualToString:@"setPdfName"] && [argsAction count] > 0) {
                        [self setPdfName:[argsAction objectAtIndex:0]];
                    }
                    else if([command isEqualToString:@"setFontName"] && [argsAction count] > 0) {
                        [self setFontName:[argsAction objectAtIndex:0]];
                    }
                    else if([command isEqualToString:@"setLineWidth"] && [argsAction count] > 0) {
                        [self setLineWidth:[argsAction objectAtIndex:0]];
                    }
                    else if([command isEqualToString:@"setTextAlign"] && [argsAction count] > 0) {
                        [self setTextAlign:[argsAction objectAtIndex:0]];
                    }
                    else if([command isEqualToString:@"setTextVerticalAlign"] && [argsAction count] > 0) {
                        [self setTextVerticalAlign:[argsAction objectAtIndex:0]];
                    }
                    else if([command isEqualToString:@"setPageWidth"] && [argsAction count] > 0) {
                        [self setPageWidth:[argsAction objectAtIndex:0]];
                    }
                    else if([command isEqualToString:@"setPageHeight"] && [argsAction count] > 0) {
                        [self setPageHeight:[argsAction objectAtIndex:0]];
                    }
                    else if([command isEqualToString:@"openPDF"]) {
                        [self openPDF:argsAction];
                    }
                    else if([command isEqualToString:@"setProperties"] && [argsAction count] > 0) {
                        [self setProperties:[argsAction objectAtIndex:0]];
                    }
                    else if([command isEqualToString:@"addNewPage"]) {
                        [self addNewPage:NULL];
                    }
                    else if([command isEqualToString:@"deletePage"]) {
                        [self deletePage:argsAction];
                    }
                    else if([command isEqualToString:@"forEachPage"]) {
                        [self forEachPage:argsAction];
                    }
                    else if([command isEqualToString:@"setTextColor"]) {
                        [self setTextColor:argsAction];
                    }
                    else if([command isEqualToString:@"setDrawColor"]) {
                        [self setDrawColor:argsAction];
                    }
                    else if([command isEqualToString:@"setFillColor"]) {
                        [self setFillColor:argsAction];
                    }
                    else if([command isEqualToString:@"drawText"]) {
                        [self drawText:argsAction];
                    }
                    else if([command isEqualToString:@"drawLine"]) {
                        [self drawLine:argsAction];
                    }
                    else if([command isEqualToString:@"drawRect"]) {
                        [self drawRect:argsAction];
                    }
                    else if([command isEqualToString:@"drawImage"]) {
                        [self drawImage:argsAction];
                    }
                    else if([command isEqualToString:@"drawEllipse"]) {
                        [self drawEllipse:argsAction];
                    }
                    else if([command isEqualToString:@"addURL"]) {
                        [self addURL:argsAction];
                    }
                    else {
                        NSLog(@"[ERROR] Unknow command at generateFromJSON");
                    }
                }
                @catch (NSException *exception) {
                    if(command != NULL) {
                        NSLog(@"[ERROR] %@, action: %@", exception.reason, command);
                    } else {
                        NSLog(@"[ERROR] %@", exception.reason);
                    }
                }
                
            } else {
                NSLog(@"[ERROR] json is not of type NSDictionary generateFromJSON");
            }
        }
        
        // Create the PDF context if needed
        if(context == NULL) {
            if( _pdfName == NULL || [_pdfName isEqualToString:@""] ) {
                _pdfName = @"output";
            }
            // Adds a blank page
            [self addNewPage:NULL];
        }
        
        // Close the PDF context and write the contents out
        UIGraphicsEndPDFContext();
        
        // Release context
        context = NULL;
        
        NSArray *arrayPaths =
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                            NSUserDomainMask,
                                            YES);
        
        NSString *path = [arrayPaths objectAtIndex:0];
        NSString *pdfFileName = [path stringByAppendingPathComponent:[_pdfName stringByAppendingString:@".pdf"]];
        
        // Fire callback event
        NSArray *obj = @[@{
          @"url" : pdfFileName,
        }];
        
        [callback call:obj thisObject:nil];
        
    } else {
        NSLog(@"[ERROR] %@", @"Callback from method generateFromJSON not found");
    }
}

@end
