//
//  FastPdfKit Extension
//

#import "FPKMessage.h"

@implementation FPKMessage

#pragma mark -
#pragma mark Initialization

-(UIView *)initWithParams:(NSDictionary *)params andFrame:(CGRect)frame from:(FPKOverlayManager *)manager{
    if (self = [super init]) 
    {        
        [self setFrame:frame];
        _rect = frame;
        
        if (![[params objectForKey:@"load"] boolValue]){
            DDSocialDialog *blankDialog = [[DDSocialDialog alloc] initWithFrame:CGRectMake(0., 0., [[[params objectForKey:@"params"] objectForKey:@"w"] floatValue], [[[params objectForKey:@"params"] objectForKey:@"h"] floatValue]) andOriginalFrame:frame theme:DDSocialDialogThemeTwitter];
            
            blankDialog.dialogDelegate = self;
            if([[params objectForKey:@"params"] objectForKey:@"title"]){
                blankDialog.titleLabel.text = [[params objectForKey:@"params"] objectForKey:@"title"];
            } else {
                NSLog(@"FPKMessage - Parameter title not found, check the uri, it should be in the form: ");
                NSLog(@"FPKMessage - message://?title=The Title");
            }
            
            UITextView *message;
            if([[params objectForKey:@"params"] objectForKey:@"w"] && [[params objectForKey:@"params"] objectForKey:@"h"]){
                message = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, [[[params objectForKey:@"params"] objectForKey:@"w"] floatValue]-42.0, [[[params objectForKey:@"params"] objectForKey:@"h"] floatValue] - 71.0)];
            } else {
                NSLog(@"FPKMessage - Parameter w and/or h not found, check the uri, it should be in the form: ");
                NSLog(@"FPKMessage - message://?w=400.0&h=300.0");
            }

            if([[params objectForKey:@"params"] objectForKey:@"message"]){
                message.text = [[params objectForKey:@"params"] objectForKey:@"message"];
            } else {
                NSLog(@"FPKMessage - Parameter message not found, check the uri, it should be in the form: ");
                NSLog(@"FPKMessage - message://?message=The message");
            }

            message.font = [UIFont systemFontOfSize:16];
            [blankDialog.contentView addSubview:message];
            [message release];
            [blankDialog show];
            [blankDialog release];
        } else {
            CGRect origin = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
            UIView* view = [[UIView alloc] initWithFrame:origin]; 
            UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fpkmessage-info.png"]];   
            [image setFrame:CGRectMake(view.frame.size.width/2.0-image.frame.size.width/2.0, view.frame.size.height/2.0-image.frame.size.height/2.0, image.frame.size.width, image.frame.size.height)];
            [view addSubview:image];
            [view setAutoresizesSubviews:YES];
            [image release];
            [self addSubview:view];
            [view release];
        }
    }
    return self;  
}

- (void)socialDialogDidCancel:(DDSocialDialog *)socialDialog{
    // Social dialog dismissed
}

+ (NSArray *)acceptedPrefixes{
    return [NSArray arrayWithObjects:@"message", nil];
}

+ (BOOL)respondsToPrefix:(NSString *)prefix{
    if([prefix isEqualToString:@"message"])
        return YES;
    else 
        return NO;
}

- (CGRect)rect{
    return _rect;
}

- (void)setRect:(CGRect)aRect{
    [self setFrame:aRect];
    _rect = aRect;
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc 
{
    [super dealloc];
}

@end