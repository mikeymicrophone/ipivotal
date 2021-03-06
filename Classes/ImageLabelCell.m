//
//	Copyright (c) 2008-2011, Mark Lussier
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


#import "ImageLabelCell.h"


@implementation ImageLabelCell

@synthesize cellImage, cellLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(4.0f, 7.0f, 30.0f, 30.0f)];
        cellImage.contentMode = UIViewContentModeCenter;

        cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(36.0f, 0.0f, (self.contentView.frame.size.width - 36.0f) , self.contentView.frame.size.height)];
		cellLabel.autoresizingMask = UIViewAutoresizingNone;
		cellLabel.backgroundColor = [UIColor clearColor];
		cellLabel.highlightedTextColor = [UIColor whiteColor];
		cellLabel.font = [UIFont  fontWithName:@"Helvetica" size:14.0f];
		cellLabel.textColor = [UIColor blackColor];
		cellLabel.textAlignment = UITextAlignmentLeft;
        
        
        [self.contentView addSubview:cellImage];
		[self.contentView addSubview:cellLabel];
    }
    return self;
}

- (void)setImageContentMode:(UIViewContentMode)contentMode {
    cellImage.contentMode = contentMode;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setFrame:(CGRect)theFrame {
    [super setFrame:theFrame];
}    


- (void)setText:(NSString*)text {
	cellLabel.text = text;
}

- (NSString*)text {
	return cellLabel.text;
}

- (void)setImage:(UIImage*)theimage {
    cellImage.image = theimage;
}

- (UIImage*)image {
	return cellImage.image;
}

- (void)dealloc {
    [cellImage release]; cellImage = nil;
    [cellLabel release]; cellLabel = nil;
    [super dealloc];
}


@end
