//
//  JSFaveStarControl.m
//  FavStarControl
//
//  Created by James "Jasarien" Addyman on 17/02/2010.
//  Copyright 2010 JamSoft. All rights reserved.
//  http://jamsoftonline.com
//

#import "JSFavStarControl.h"

#define RATING_MAX 5
#define TOUCH_OFFSET 3.5

@implementation JSFavStarControl

@synthesize rating = _rating;

- (id)initWithLocation:(CGPoint)location dotImage:(UIImage *)dotImage starImage:(UIImage *)starImage spacing:(NSInteger)spacing
{
	if (self = [self initWithFrame:CGRectMake(location.x, location.y, (starImage.size.width * RATING_MAX) + (spacing * RATING_MAX), starImage.size.height)])
	{
		_rating = 0.0;
        _spacing = spacing;
        
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		
		_dot = [dotImage retain];
		_star = [starImage retain];
	}
	
	return self;
}

- (void) setRating:(CGFloat)rating {
    float integral = 0.0;
    float remainder = 0.0;
    remainder = modff(rating, &integral);
    _rating = remainder > 0.5 ? integral + 1 : remainder == 0.0 ? 0.0 : integral + 0.5;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)drawRect:(CGRect)rect
{
	CGPoint currPoint = CGPointZero;
    float width = 0.0;
    
	for (float i = 0.0; i < _rating; i++)
	{
		if (_star)
        {
            width = _rating - i;
            if( width >= 1.0 ) 
                width = 1.0;
            
            CGRect starRect = CGRectMake(0.0, 0.0, _star.size.width * width * _star.scale, _star.size.height * _star.scale);
           
            CGImageRef imageRef = CGImageCreateWithImageInRect(_star.CGImage, starRect);
            UIImage *result = [UIImage imageWithCGImage:imageRef scale:_star.scale orientation:_star.imageOrientation];
            CGImageRelease(imageRef);
            
			[result drawAtPoint:currPoint];
        }
		else
			[@"★" drawAtPoint:currPoint withFont:[UIFont boldSystemFontOfSize:22]];
			
        if( width == 1.0 )
		currPoint.x += _star.size.width + _spacing;
        else {
            currPoint.x += _star.size.width * width;
        }
	}
	
	float remaining = RATING_MAX - _rating;
	
	for (float i = width; i <= remaining; i++)
	{
		if (_dot)
        {
            if(i >= 1.0) {
                width = remaining - i;
                if( width >= 1.0 || width == 0.0 ) 
                    width = 0.0;
            }
            
            CGRect starRect = CGRectMake((_dot.size.width * width * _dot.scale), 0.0, _dot.size.width * _dot.scale, _dot.size.height * _dot.scale);
            
            CGImageRef imageRef = CGImageCreateWithImageInRect(_dot.CGImage, starRect);
            UIImage *result = [UIImage imageWithCGImage:imageRef scale:_dot.scale orientation:_dot.imageOrientation];
            CGImageRelease(imageRef);
            
            [result drawAtPoint:currPoint];
        }
		else
			[@" •" drawAtPoint:currPoint withFont:[UIFont boldSystemFontOfSize:22]];
        
        if( width != 0.0 )
            currPoint.x += _dot.size.width * width + _spacing;
        else
            currPoint.x += _dot.size.width + _spacing;
	}
}


- (void)dealloc
{
	[_dot release];
	[_star release];
	
	_dot = nil,
	_star = nil;
	
    [super dealloc];
}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGFloat width = self.frame.size.width;
	CGRect section = CGRectMake(0, 0, width / RATING_MAX, self.frame.size.height);
	
	CGPoint touchLocation = [touch locationInView:self];
	
	for (int i = 0; i < RATING_MAX; i++)
	{		
		if (touchLocation.x > section.origin.x && touchLocation.x < section.origin.x + section.size.width)
		{ // touch is inside section
                float half = (touchLocation.x+TOUCH_OFFSET)/section.size.width;
			if (_rating != (half))
			{
                float integral = 0.0;
                float remainder = 0.0;
                remainder = modff(half, &integral);
				_rating = remainder > 0.5 ? integral + 1 : integral + 0.5;
                if(_rating > RATING_MAX)
                    _rating = RATING_MAX;

				[self sendActionsForControlEvents:UIControlEventValueChanged];
			}
			
			break;
		}
		
		section.origin.x += section.size.width;
	}
	
	[self setNeedsDisplay];
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGFloat width = self.frame.size.width;
	CGRect section = CGRectMake(0, 0, width / RATING_MAX, self.frame.size.height);
	
	CGPoint touchLocation = [touch locationInView:self];
	
	if (touchLocation.x < 0)
	{
		if (_rating != 0)
		{	
			_rating = 0;
			[self sendActionsForControlEvents:UIControlEventValueChanged];
		}
	}
	else if (touchLocation.x > width)
	{
		if (_rating != 5)
		{
			_rating = 5;
			[self sendActionsForControlEvents:UIControlEventValueChanged];
		}
	}
	else
	{
		for (int i = 0; i < RATING_MAX; i++)
		{
            NSLog(@"i: %d TouchLocation: (x: %.2f) SectionOrigin: (x: %.2f) SectionSize: (width: %.2f)",
                  i, touchLocation.x, section.origin.x,section.size.width);
            
			if (touchLocation.x > section.origin.x && touchLocation.x < section.origin.x + section.size.width)
			{ // touch is inside section
                float half = (touchLocation.x+TOUCH_OFFSET)/section.size.width;
				if (_rating != (half))
				{
                    
                    float integral = 0.0;
                    float remainder = 0.0;
                    remainder = modff(half, &integral);
                    _rating = remainder > 0.5 ? integral + 1 : integral + 0.5;
                    if(_rating > RATING_MAX)
                        _rating = RATING_MAX;
                    
                    NSLog(@"%.2f",_rating);
					[self sendActionsForControlEvents:UIControlEventValueChanged];
				}
				break;
			}
			
			section.origin.x += section.size.width;
		}
	}
	
	[self setNeedsDisplay];
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGFloat width = self.frame.size.width;
	CGRect section = CGRectMake(0, 0, width / RATING_MAX, self.frame.size.height);
	
	CGPoint touchLocation = [touch locationInView:self];
	
	if (touchLocation.x < 0)
	{
		if (_rating != 0)
		{	
			_rating = 0;
			[self sendActionsForControlEvents:UIControlEventValueChanged];
		}
	}
	else if (touchLocation.x > width)
	{
		if (_rating != 5)
		{
			_rating = 5;
			[self sendActionsForControlEvents:UIControlEventValueChanged];
		}
		
	}
	else
	{
		for (int i = 0; i < RATING_MAX; i++)
		{
			if (touchLocation.x > section.origin.x && touchLocation.x < section.origin.x + section.size.width)
			{
                float half = (touchLocation.x+TOUCH_OFFSET)/section.size.width;
				if (_rating != (half))
				{
                    float integral = 0.0;
                    float remainder = 0.0;
                    remainder = modff(half, &integral);
                    _rating = remainder > 0.5 ? integral + 1 : integral + 0.5;
                    if(_rating > RATING_MAX)
                        _rating = RATING_MAX;

					[self sendActionsForControlEvents:UIControlEventValueChanged];
				}
				
				break;
			}
			
			section.origin.x += section.size.width;
		}
	}
	
	[self setNeedsDisplay];
}

@end
