//
//  SimpleFlickrAPI.m
//  Flickr+JSONSample
//
//  Created by Kirby Turner on 3/5/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//

#import "SimpleFlickrAPI.h"
#import "WebServiceClient.h"
#import "JSON.h"
#import "NSString+KTString.h"


#error Changes this value to your own application key. More info at http://www.flickr.com/services/api/misc.api_keys.html 
#define flickrAPIKey @"YOUR_FLICKR_APP_KEY"

#define flickrBaseURL @"http://api.flickr.com/services/rest/?format=json&"

#define flickrParamMethod @"method"
#define flickrParamAppKey @"api_key"
#define flickrParamUsername @"username"
#define flickrParamUserid @"user_id"
#define flickrParamPhotoSetId @"photoset_id"
#define flickrParamExtras @"extras"

#define flickrMethodFindByUsername @"flickr.people.findByUsername"
#define flickrMethodGetPhotoSetList @"flickr.photosets.getList"
#define flickrMethodGetPhotosWithPhotoSetId @"flickr.photosets.getPhotos"


@interface SimpleFlickrAPI ()
- (NSURL *)buildFlickrURLWithParameters:(NSDictionary *)parameters;
- (NSString *)stringByRemovingFlickrJavaScript:(NSData *)data;
- (id)flickrJSONSWithParameters:(NSDictionary *)parameters;
@end

@implementation SimpleFlickrAPI

- (NSString *)userIdForUsername:(NSString *)username
{
   NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:flickrMethodFindByUsername, flickrParamMethod, flickrAPIKey, flickrParamAppKey, username, flickrParamUsername, nil];
   NSDictionary *json = [self flickrJSONSWithParameters:parameters];
   NSDictionary *userDict = [json objectForKey:@"user"];
   NSString *nsid = [userDict objectForKey:@"nsid"];
   
   return nsid;
}

- (NSArray *)photoSetListWithUserId:(NSString *)userId
{
   NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:flickrMethodGetPhotoSetList, flickrParamMethod, flickrAPIKey, flickrParamAppKey, userId, flickrParamUserid, nil];
   NSDictionary *json = [self flickrJSONSWithParameters:parameters];
   NSDictionary *photosets = [json objectForKey:@"photosets"];
   NSArray *photoSet = [photosets objectForKey:@"photoset"];
   return photoSet;
}

- (NSArray *)photosWithPhotoSetId:(NSString *)photoSetId
{
   NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:flickrMethodGetPhotosWithPhotoSetId, flickrParamMethod, flickrAPIKey, flickrParamAppKey, photoSetId, flickrParamPhotoSetId, @"url_t, url_s, url_m", flickrParamExtras, nil];
   NSDictionary *json = [self flickrJSONSWithParameters:parameters];
   NSDictionary *photoset = [json objectForKey:@"photoset"];
   NSArray *photos = [photoset objectForKey:@"photo"];
   return photos;
}


#pragma -
#pragma Helper Methods

- (NSURL *)buildFlickrURLWithParameters:(NSDictionary *)parameters
{
   NSMutableString *URLString = [[NSMutableString alloc] initWithString:flickrBaseURL];
   for (id key in parameters) {
      NSString *value = [parameters objectForKey:key];
      [URLString appendFormat:@"%@=%@&", key, [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   }
   NSURL *URL = [NSURL URLWithString:URLString];
   return URL;
}

- (NSString *)stringByRemovingFlickrJavaScript:(NSData *)data
{
   // Flickr returns a JavaScript function containing the JSON data.
   // We need to strip out the JavaScript part before we can parse
   // the JSON data. Ex: jsonFlickrApi(JSON-DATA-HERE)
   NSMutableString *string = [[NSString stringWithData:data] mutableCopy];
   NSRange range = NSMakeRange(0, [@"jsonFlickrApi(" length]);
   [string deleteCharactersInRange:range];
   range = NSMakeRange([string length] - 1, 1);
   [string deleteCharactersInRange:range];
   
   return [string autorelease];
}

- (id)flickrJSONSWithParameters:(NSDictionary *)parameters
{
   NSURL *URL = [self buildFlickrURLWithParameters:parameters];
   NSData *data = [WebServiceClient fetchResponseWithURL:URL];
   NSString *string = [self stringByRemovingFlickrJavaScript:data];
   
   SBJsonParser *parser = [[SBJsonParser alloc] init];
   id json = [parser objectWithString:string];
   [parser release];
   
   return json;
}

@end
