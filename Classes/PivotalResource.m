//
//	Copyright (c) 2008-2009, Mark Lussier
//	http://github.com/intabulas/ipivotal
//	All rights reserved.
//
//	This software is released under the terms of the BSD License.
//	http://www.opensource.org/licenses/bsd-license.php
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//	* Redistributions of source code must retain the above copyright notice, this
//	  list of conditions and the following disclaimer.
//	* Redistributions in binary form must reproduce the above copyright notice,
//	  this list of conditions and the following disclaimer
//	  in the documentation and/or other materials provided with the distribution.
//	* Neither the name of iPivotal nor the names of its contributors may be used
//	  to endorse or promote products derived from this software without specific
//	  prior written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//	IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//	INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
//	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//	DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//	LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
//	OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
//	OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "PivotalResource.h"
#import "ASIHTTPRequest.h"

@implementation PivotalResource

@synthesize status, error, savingStatus;

- (id)init {
	[super init];
	self.status = PivotalResourceStatusNotLoaded;
    self.savingStatus = PivotalResourceStatusNotSaved;
    return self;
}

- (BOOL)isLoading {
	return status == PivotalResourceStatusLoading;
}

- (BOOL)isLoaded {
	return status == PivotalResourceStatusLoaded;
}

- (BOOL)isSaving {
	return savingStatus == PivotalResourceStatusSaving;
}

- (BOOL)isSaved {
	return savingStatus ==PivotalResourceStatusSaved;
}


- (void) dealloc {
	[error release];
	[super dealloc];
}


#pragma mark === HTTP Authentication Methods ===

+(ASIHTTPRequest *)authenticatedRequestForURL:(NSURL *)theURL {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:kDefaultsApiToken];
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:theURL] autorelease];
#ifdef NO_COMPRESS_RESPONSE    
    [request setAllowCompressedResponse:NO];
    [request setShouldCompressRequestBody:NO];
#endif    
    [request addRequestHeader:kTrackerTokenHeader value:token];
    return request;
}

@end
