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

#import "NetDavidmartinsTipdfModule.h"

@implementation NetDavidmartinsTipdfModule

#pragma mark Internal

// This is generated for your module, please do not change it
- (id)moduleGUID
{
  return @"14fee4d1-915e-45cc-8893-400191632c75";
}

// This is generated for your module, please do not change it
- (NSString *)moduleId
{
  return @"net.davidmartins.tipdf";
}

#pragma mark Lifecycle

- (void)startup
{
  // this method is called when the module is first loaded
  // you *must* call the superclass
  [super startup];
  
  NSLog(@"[DEBUG] %@ Módulo Ti PDF Loaded", self);
}

-(void)shutdown:(id)sender
{
    // this method is called when the module is being unloaded
    // typically this is during shutdown. make sure you don't do too
    // much processing here or the app will be quit forceably
    // you *must* call the superclass
    
    [super shutdown:sender];
}

#pragma Public APIs

@end
