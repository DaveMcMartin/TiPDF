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

#import "TiProxy.h"
#import <CoreText/CoreText.h>

#ifndef NetDavidmartinsTipdfPDFProxy_h
#define NetDavidmartinsTipdfPDFProxy_h

@interface NetDavidmartinsTipdfPDFProxy : TiProxy {
    CGContextRef context;
    NSDictionary* props;
    UIColor* textColor;
    UIColor* drawColor;
    UIColor* fillColor;
}

/**
 PDF File name (without file extension), default is "output"
 */
@property(copy) NSString* pdfName;

/**
 Current font being used by drawText method, default is "Helvetica"
 */
@property(copy) NSString* fontName;

/**
 Number of pages of the PDF
 */
@property(copy) NSNumber* pageCount;

/**
 Line Width of the stroke, default is 0.1
 */
@property(copy) NSNumber* lineWidth;

/**
 Size of the text, is used by drawText method
 */
@property(copy) NSNumber* textSize;

/**
 Text alignment (left, center, right, justified), is used by drawText method
 */
@property(copy) NSString* textAlign;

/**
 Text alignment (top, middle, bottom), is used by drawText method
 */
@property(copy) NSString* textVerticalAlign;

/**
 Width of the PDF page, default is 612
 */
@property(copy) NSNumber* pageWidth;

/**
 Height of the PDF page, default is 792
 */
@property(copy) NSNumber* pageHeight;

/**
 Creates a new PDF File as copy from the specified PDF file

 @param args (path) string which is a path to the PDF file, is required
 */
-(void)openPDF:(id)args;

/**
 Sets the PDF properties

 @param args (dict) Dictionary (js object) with properties as follows:
 {
    "pdfName":"The Fox",
    "title":"John Due",
    "author":"John Due Again",
    "subject":"John is in everywhere",
    "keywords":"john, due",
    "creator":"John Due"
 }
 */
-(void)setProperties:(id)args;

/**
 Returns the PDF properties

 @param args Void
 @return return Dictionary (js object) with properties as follows
 {
     "pdfName":"The Fox",
     "title":"John Due",
     "author":"John Due Again",
     "subject":"John is in everywhere",
     "keywords":"john, due",
     "creator":"John Due"
 }
 */
-(NSDictionary *)getProperties:(id)args;


/**
 Adds a new page to the PDF

 @param args Void
 */
-(void)addNewPage:(id)args;


/**
 Deletes a page from the PDF, actually creates a new PDF without the specified page

 @param args (page) int which indicates the page to be deleted, is required
 */
-(void)deletePage:(id)args;

/**
 Creates a new PDF executing a js callback over each created page which enables redraw

 @param args (callback) KrollCallback (js callback) which will be executed for each page, is required
 */
-(void)forEachPage:(id)args;

/**
 Sets the text color for method drawText

 @param args (r, g, b, a)
 R -> Int, red color from 0 to 255, is required
 G -> Int, green color from 0 to 255, is required
 B -> Int, blue color from 0 to 255, is required
 A -> Double, alpha from 0.0 to 1.0, is optional default 1.0
 
 default color is darkGray
 */
-(void)setTextColor:(id)args;

/**
 Sets the stroke color for all drawing methods except drawText
 
 @param args (r, g, b, a)
 R -> Int, red color from 0 to 255, is required
 G -> Int, green color from 0 to 255, is required
 B -> Int, blue color from 0 to 255, is required
 A -> Double, alpha from 0.0 to 1.0, is optional default 1.0
 
 default color is darkGray
 */
-(void)setDrawColor:(id)args;

/**
 Sets the fill color for all shape drawing methods
 
 @param args (r, g, b, a)
 R -> Int, red color from 0 to 255, is required
 G -> Int, green color from 0 to 255, is required
 B -> Int, blue color from 0 to 255, is required
 A -> Double, alpha from 0.0 to 1.0, is optional default 1.0
 
 default color is darkGray
 */
-(void)setFillColor:(id)args;

/**
 Calculates the height of the text to the specified width
 
 @param args (text, width)
 text  -> String
 width -> Max width
 
 @return Number with the text height
 */
-(NSNumber *)getTextHeightForRect:(id)args;

/**
 Writes text into a rect

 @param args (text, x, y, width, height)
 text   -> String to be drawn, is required
 x      -> Int, the top-down horizontal coordinate where 0 is the start point at top, is required
 y      -> Int, the left-right vertical coordinate where 0 is the start point at left, is required
 width  -> Int, the width of the rect where the text will be drawn, is required
 height -> Int, the height of the rect where the text will be drawn, is required
 */
-(void)drawText:(id)args;


/**
 Draws a line between 2 points

 @param args (startX, startY, endX, endY)
 startX -> Int, the top-down vertical coordinate for the start point, is required
 startY -> Int, the left-right horizontal coordinate for the start point, is required
 endX   -> Int, the top-down vertical coordinate for the end point, is required
 endY   -> Int, the left-right horizontal coordinate for the end point, is required
 */
-(void)drawLine:(id)args;

/**
 Draws a rectangle

 @param args (x, y, width, height)
 x      -> Int, the top-down horizontal coordinate where 0 is the start point at top, is required
 y      -> Int, the left-right vertical coordinate where 0 is the start point at left, is required
 width  -> Int, the width of the rectangle, is required
 height -> Int, the height of the rectangle, is required
 */
-(void)drawRect:(id)args;

/**
 Draws an Image into a rectangle
 
 @param args (path, x, y, width, height, default)
 path   -> String, the path to the image, is required
 x      -> Int, the top-down horizontal coordinate where 0 is the start point at top, is required
 y      -> Int, the left-right vertical coordinate where 0 is the start point at left, is required
 width  -> Int, the width of the rectangle where the image will be drawn, is required
 height -> Int, the height of the rectangle where the image will be drawn, is required
 default-> String, the path to the default image if the first one is not loaded
 */
-(void)drawImage:(id)args;

/**
 Draws an Ellipse into a rectangle
 
 @param args (x, y, width, height)
 x      -> Int, the top-down horizontal coordinate where 0 is the start point at top, is required
 y      -> Int, the left-right vertical coordinate where 0 is the start point at left, is required
 width  -> Int, the width of the rectangle where the Ellipse will be drawn, is required
 height -> Int, the height of the rectangle where the Ellipse will be drawn, is required
 */
-(void)drawEllipse:(id)args;

/**
 Adds a clickable area into a rectangle which opens a link on click
 
 @param args (url, x, y, width, height)
 url    -> String, the link, is required
 x      -> Int, the top-down horizontal coordinate where 0 is the start point at top, is required
 y      -> Int, the left-right vertical coordinate where 0 is the start point at left, is required
 width  -> Int, the width of the rectangle for the clickable area, is required
 height -> Int, the height of the rectangle for the clickable area, is required
 */
-(void)addURL:(id)args;


/**
 Cancels the PDF drawing closing the context and deleting the PDF file

 @param args Void
 */
-(void)cancelPDF:(id)args;


/**
 Saves the PDF file closing the context and calling the callback

 @param args (pdfName, callback) PDF file name (without file extension)
 */
-(void)savePDF:(id)args;

/**
 Generate PDF from JSON, this way it generates everything in one bridge call
 
 @param args (array, callback)
 */
-(void)generateFromJSON:(id)args;

@end

#endif /* NetDavidmartinsTipdfPDFProxy_h */
