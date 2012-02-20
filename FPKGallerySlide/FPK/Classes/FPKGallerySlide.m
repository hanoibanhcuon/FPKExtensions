//
//  FastPdfKit Extension
//

#import "FPKGallerySlide.h"
#import "UIImagesScrollView.h"
#import <FastPdfKit/MFDocumentManager.h>

@implementation FPKGallerySlide

#pragma mark -
#pragma mark Initialization

// NSLog(@"FPKGallerySlide - ");

-(UIView *)initWithParams:(NSDictionary *)params andFrame:(CGRect)frame from:(FPKOverlayManager *)manager{
    if (self = [super init]) 
    {        
        [self setFrame:frame];
        _rect = frame;
        
        if ([[params objectForKey:@"load"] boolValue]){
            CGRect origin = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
            int loop;
            if ([[params objectForKey:@"params"] objectForKey:@"loop"]){
                loop = [[[params objectForKey:@"params"] objectForKey:@"loop"] intValue];
            } else {
                // Defaulting to 0
                loop = 0;
            }
            
            NSString * resource;
            if([manager isMemberOfClass:NSClassFromString(@"FPKOverlayManager")]){
                resource = [[[manager documentViewController] document] resourceFolder];
            } else {
                resource = [manager performSelector:@selector(resourcePath)];
            }
                
            NSArray * images = [[[params objectForKey:@"params"] objectForKey:@"images"] componentsSeparatedByString:@","];
            
            if ([images count] > 0){
                NSMutableArray * uiImages = [[NSMutableArray alloc] init];
                
                for(NSString *image in images){
                    UIImage *imageI = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",resource , image]];
                    NSLog(@"%@", [NSString stringWithFormat:@"%@/%@",resource , image]);
                    if (imageI) {
                        [uiImages addObject:imageI];
                    } else {
                        NSLog(@"FPKGallerySlide - Image named %@ not found at the path you specified.", image);
                    }
                }
                
                pagingViewController = (id *)[[UIImagesScrollView alloc] initWithFrame:origin 
                                                                                         andArrayImg:uiImages
                                                                                             andLoop:loop
                                                            ];
                [uiImages release];
                
                [self addSubview:(UIImagesScrollView *)pagingViewController];
                [(UIImagesScrollView *)pagingViewController release];
            } else {
                NSLog(@"FPKGallerySlide - Parameter images not found or empty, check the uri, it should be in the form: ");
                NSLog(@"FPKGallerySlide - galleryslide://?images=img1.png,img2.png,img3.png");
            }
        }
    }
    return self;  
}

- (void)willRemoveOverlayView:(FPKOverlayManager *)manager{
    [(UIImagesScrollView *)pagingViewController invalidateTimer];
}

+ (NSArray *)acceptedPrefixes{
    return [NSArray arrayWithObjects:@"galleryslide", nil];
}

+ (BOOL)respondsToPrefix:(NSString *)prefix{
    if([prefix isEqualToString:@"galleryslide"])
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