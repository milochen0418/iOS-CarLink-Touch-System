//
//  AppObject.m
//  touch
//
//  Created by Milo Chen on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppObject.h"

@implementation AppObject
@synthesize mITuneInstallURL,mNativeApplicationURLScheme;
@synthesize mAppIconUrl,mAppName,mAppDescription;


-(AppObject*) initWithUrlScheme:(NSString*)urlScheme andITuneUrl:(NSString*)iTuneUrl {
    self = [super init];
    if(self) {
        self.mNativeApplicationURLScheme = urlScheme;
        self.mITuneInstallURL = iTuneUrl;
    }
    return self;
}


-(void) reloadAppIconAndName {
    mAppName = nil;
    mAppIconUrl = nil;
    mAppDescription = nil;
    [self loadAppIconAndName];
}


-(void) loadAppIconAndName {
    if(mAppName == nil || mAppIconUrl ==nil || mAppDescription == nil) 
    {
        mAppName = @"";
        mAppIconUrl = @"";
        mAppDescription = @"";
        
        NSString * urlStr= @"http://itunes.apple.com/us/app/fahrinfo-berlin/id284971745?mt=8";
        urlStr = mITuneInstallURL;
        
        NSURL * url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"GET"];
        
        NSData * returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString * loadData = [[NSMutableString alloc] initWithData:returnData encoding:NSISOLatin1StringEncoding];
        NSString * loadData2 = [self stringByRemovingNewLinesAndWhitespace:loadData];

//        NSLog(@"loadData2 = %@", loadData2);
        NSString * strFilterTitle = nil;
        NSString * strTitle = nil;
        NSString * strFilterIconUrl1 = nil;
        NSString * strIconUrl = nil;
        
        NSString * strDescFilter1 = nil;
        NSString * strDescFilter2 = nil;
//        NSString * strDescTxt = nil;
        strFilterTitle = [self extractValueBetweenBeginStr:@"<div id=\"title\" class=\"intro \">" andEndStr:@" </div>" inTxtStr:loadData2];
        strTitle = [self extractValueBetweenBeginStr:@"<h1>" andEndStr:@"</h1>" inTxtStr:strFilterTitle];
                
        strFilterIconUrl1 = [self extractValueBetweenBeginStr:@"<div class=\"artwork\"><img width=\"175\" height=\"175\"" andEndStr:@"</div>" inTxtStr:loadData];
        strIconUrl = [self extractValueBetweenBeginStr:@"class=\"artwork\" src=\"" andEndStr:@"\" />" inTxtStr:strFilterIconUrl1];
        
        if(strTitle != nil) {
            self.mAppName = strTitle;
        }

        if(strIconUrl!=nil){
            mAppIconUrl = strIconUrl;
        }
        
        strDescFilter1 = [self extractValueBetweenBeginStr:@"Description </h4>" andEndStr:@"</div>" inTxtStr:loadData2];
//        NSLog(@"strDescFilter1 = %@", strDescFilter1);
        
        strDescFilter2 = [self stringByConvertingHTMLToPlainText:strDescFilter1];
//        NSLog(@"strDescFilter2 = %@", strDescFilter2);
        
        mAppDescription = strDescFilter2;
        
        
        
    
    }
}

-(NSString*) getAppName 
{
    if(mAppName == nil) 
    {
        [self loadAppIconAndName];
    }

    return mAppName;
}

-(NSString*) getAppIconUrl 
{
    if(mAppIconUrl == nil) 
    {
        [self loadAppIconAndName];
    }
    return mAppIconUrl;
}


-(BOOL) isInstalled {
    if(mNativeApplicationURLScheme ==nil) return NO;
    NSURL *url = [NSURL URLWithString:mNativeApplicationURLScheme];
    if(url == nil) return NO;
    return [[UIApplication sharedApplication] canOpenURL:url];
}

-(void) openITuneForInstall {
    if(mITuneInstallURL==nil) return;
    NSURL *url = [NSURL URLWithString:mITuneInstallURL];
    if(url == nil) return;
    if(![[UIApplication sharedApplication] canOpenURL:url]) return;
    [[UIApplication sharedApplication] openURL:url];
}



-(void) openApplication 
{
    if(mNativeApplicationURLScheme==nil) return;
    NSURL *url = [NSURL URLWithString:mNativeApplicationURLScheme];
    
//add by milo     
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:@"rosentouch://com.rosenapp.touch", @"callback",nil];
    url = [self urlByAddingParameters:paramDict inURL:url];  
    
    if(url == nil) return;
    if(![[UIApplication sharedApplication] canOpenURL:url]) return;
    [[UIApplication sharedApplication] openURL:url];    
}


- (NSURL *)urlByAddingParameters:(NSDictionary *)paramDict inURL:(NSURL*)url
{
	if (!paramDict || [paramDict count] == 0) 
    {
		return url;
	}    
  	NSString *absoluteString = [url absoluteString];  
	NSMutableArray *paramPairs = [NSMutableArray array];    
    
	for (NSString *key in [paramDict allKeys]) 
    {
        NSString * str = [paramDict objectForKey:key];
        NSString * encodedStr = [self URLEncodedString:NSUTF8StringEncoding inUrlStr:str];
        
  		NSString *pair = [NSString stringWithFormat:@"%@=%@", key,  encodedStr ];      
   		[paramPairs addObject:pair];
	}
    
	NSString *queryString = [paramPairs componentsJoinedByString:@"&"];
	NSRange parameterRange = [absoluteString rangeOfString:@"?"];
	if (parameterRange.location == NSNotFound) {
		absoluteString = [NSString stringWithFormat:@"%@?%@", absoluteString, queryString];
	} else {
		absoluteString = [NSString stringWithFormat:@"%@&%@", absoluteString, queryString];
	}
	return [NSURL URLWithString:absoluteString];
}

-(NSString *)URLEncodedString:(NSStringEncoding)encoding inUrlStr:(NSString*)urlStr{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
            (__bridge CFStringRef)urlStr,                                                                                 
            NULL,
           (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
            CFStringConvertNSStringEncodingToEncoding(encoding));
}
                                  


-(void)actionIt 
{
    if(mNativeApplicationURLScheme == nil) return;
    if([self isInstalled]){
        [self openApplication];
    }else {
        [self openITuneForInstall];
    }
}

-(UIImage*) getIconFromAppStore {
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.mAppIconUrl]]];
}


- (NSString *)stringByRemovingNewLinesAndWhitespace:(NSString*)str {
	NSScanner *scanner = [[NSScanner alloc] initWithString:str];
	[scanner setCharactersToBeSkipped:nil];
	NSMutableString *result = [[NSMutableString alloc] init];
	NSString *temp;
	NSCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:
        [NSString stringWithFormat:@" \t\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
	// Scan
	while (![scanner isAtEnd]) {
        
		// Get non new line or whitespace characters
		temp = nil;
		[scanner scanUpToCharactersFromSet:newLineAndWhitespaceCharacters intoString:&temp];
		if (temp) [result appendString:temp];
        
		// Replace with a space
		if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
			if (result.length > 0 && ![scanner isAtEnd]) // Dont append space to beginning or end of result
				[result appendString:@" "];
		}
        
	}
    
	// Cleanup
    scanner = nil;
    
	// Return
	NSString *retString = [NSString stringWithString:result];
    result = nil;
	//[result release];
    
    return retString;
}






- (NSString *)stringByConvertingHTMLToPlainText:(NSString*)txt {
    
	// Pool
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	// Character sets
	NSCharacterSet *stopCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"< \t\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
	NSCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@" \t\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
	NSCharacterSet *tagNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    
	// Scan and find all tags
//	NSMutableString *result = [[NSMutableString alloc] initWithCapacity:self.length];
	NSMutableString *result = [[NSMutableString alloc] initWithCapacity:txt.length];
//	NSScanner *scanner = [[NSScanner alloc] initWithString:self];
	NSScanner *scanner = [[NSScanner alloc] initWithString:txt];    
	[scanner setCharactersToBeSkipped:nil];
	[scanner setCaseSensitive:YES];
	NSString *str = nil, *tagName = nil;
	BOOL dontReplaceTagWithSpace = NO;
	do {
        
		// Scan up to the start of a tag or whitespace
		if ([scanner scanUpToCharactersFromSet:stopCharacters intoString:&str]) {
			[result appendString:str];
			str = nil; // reset
		}
        
		// Check if we've stopped at a tag/comment or whitespace
		if ([scanner scanString:@"<" intoString:NULL]) {
            
			// Stopped at a comment or tag
			if ([scanner scanString:@"!--" intoString:NULL]) {
                
				// Comment
				[scanner scanUpToString:@"-->" intoString:NULL]; 
				[scanner scanString:@"-->" intoString:NULL];
                
			} else {
                
				// Tag - remove and replace with space unless it's
				// a closing inline tag then dont replace with a space
				if ([scanner scanString:@"/" intoString:NULL]) {
                    
					// Closing tag - replace with space unless it's inline
					tagName = nil; dontReplaceTagWithSpace = NO;
					if ([scanner scanCharactersFromSet:tagNameCharacters intoString:&tagName]) {
						tagName = [tagName lowercaseString];
						dontReplaceTagWithSpace = ([tagName isEqualToString:@"a"] ||
												   [tagName isEqualToString:@"b"] ||
												   [tagName isEqualToString:@"i"] ||
												   [tagName isEqualToString:@"q"] ||
												   [tagName isEqualToString:@"span"] ||
												   [tagName isEqualToString:@"em"] ||
												   [tagName isEqualToString:@"strong"] ||
												   [tagName isEqualToString:@"cite"] ||
												   [tagName isEqualToString:@"abbr"] ||
												   [tagName isEqualToString:@"acronym"] ||
												   [tagName isEqualToString:@"label"]);
					}
                    
					// Replace tag with string unless it was an inline
					if (!dontReplaceTagWithSpace && result.length > 0 && ![scanner isAtEnd]) [result appendString:@" "];
                    
				}
                
				// Scan past tag
				[scanner scanUpToString:@">" intoString:NULL];
				[scanner scanString:@">" intoString:NULL];
                
			}
            
		} else {
            
			// Stopped at whitespace - replace all whitespace and newlines with a space
			if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
				if (result.length > 0 && ![scanner isAtEnd]) [result appendString:@" "]; // Dont append space to beginning or end of result
			}
            
		}
        
	} while (![scanner isAtEnd]);
    
	// Cleanup
//	[scanner release];
    scanner = nil;
    
	// Decode HTML entities and return
//	NSString *retString = [[result stringByDecodingHTMLEntities] retain];
    
    //need to check this function again by milo
 	//NSString *retString = [result stringByDecodingHTMLEntities];
    NSString *retString = result;
    
//	[result release];
    result = nil;
    
	// Drain
//	[pool drain];
    
	// Return
//	return [retString autorelease];
    return retString;
    
}


-(NSMutableArray*) extractStrArrayBySameTag : (NSString*)tagName inXmlStr:(NSString*)xmlStr {
    NSString *loadData = xmlStr;
    NSString *pattern = [NSString stringWithFormat:@"<%@ (.+?)/>", tagName];      
    NSError * err;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionCaseInsensitive | NSRegularExpressionSearch
                                  error:&err];
    
    if(err!=nil) 
    {
//        NSLog(@"err:%@",[err localizedDescription]);
        return nil;
    }
    
    
    NSArray * matches = [regex matchesInString:loadData options:0 range:NSMakeRange(0, loadData.length)];
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:1];
    
    
    for( NSTextCheckingResult * ntcr in matches) 
    {
        int captureIndex;
        for(captureIndex = 1; captureIndex < ntcr.numberOfRanges; captureIndex++) 
        {
            NSRange matchRange = [ntcr rangeAtIndex:captureIndex];
            NSString *match = [loadData substringWithRange:matchRange];
            [arr addObject:match];
        }
    }
    return arr;
}




-(NSString*) extractValueBetweenBeginStr:(NSString*)beginStr andEndStr:(NSString*)endStr inTxtStr:(NSString*)txtStr;
{
    if(beginStr==nil || endStr ==nil || txtStr ==nil) return nil;
    
    NSString *pattern = [NSString stringWithFormat:@"%@(.+?)%@", beginStr, endStr];    
    NSError * err = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:
                                  NSRegularExpressionCaseInsensitive
                                  error:&err];
    if(err!=nil) {
        NSLog(@"extractValueBetweenBeginStr get err = %@", [err localizedDescription]);
        return nil;
    }
    
    //    return [[regex matchesInString:loadData options:NSCaseInsensitiveSearch range:NSMakeRange(0,[loadData length])] objectAtIndex:0];
    
    NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:txtStr options:0 range:NSMakeRange(0, txtStr.length)];
    NSRange matchRange = [textCheckingResult rangeAtIndex:1];
    NSString *match = [txtStr substringWithRange:matchRange];
    if([match isEqualToString:@""]) {
        return nil;
    }
    return match;
    
}


@end
