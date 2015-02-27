//
//  MasterViewController.m
//  codepath-twitter
//
//  Created by David Rajan on 2/24/15.
//  Copyright (c) 2015 David Rajan. All rights reserved.
//

#import "MasterViewController.h"
#import <objc/runtime.h>

@interface MasterViewController ()

@property (nonatomic, strong) UIView *masterContentView;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, assign) BOOL menuOpen;

@end

@implementation MasterViewController

typedef NS_ENUM(NSInteger, TWTSideMenuAnimationType) {
    TWTSideMenuAnimationTypeSlideOver, //Default - new view controllers slide over the old view controller.
    TWTSideMenuAnimationTypeFadeIn //New View controllers fade in over the old view controller.
};

CGFloat const scaleFactor = 0.5634;
UIOffset const edgeTranslate = {20.0f, 0.0f};
static NSTimeInterval const animateDuration = 0.2;
static NSTimeInterval const animateDelay = 0.2;
static NSTimeInterval const animateCloseDuration = 0.3;
static NSTimeInterval const animateSwitchDuration = 0.3;
static TWTSideMenuAnimationType const animationType = TWTSideMenuAnimationTypeFadeIn;

CGPoint mainOriginalCenter;
CGPoint menuOriginalCenter;
CGRect mainOriginalBounds;
CGRect menuOriginalBounds;
CGAffineTransform mainOpenTransform;
CGAffineTransform menuClosedTransform;

- (id)initWithMainViewController:(UIViewController *)mainViewController menuViewController:(UIViewController *)menuViewController {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _mainViewController = mainViewController;
        _menuViewController = menuViewController;
        
        [self addViewController:self.menuViewController];
        [self addViewController:self.mainViewController];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:self.mainViewController];
    self.masterContentView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.masterContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.mainViewController.view.frame = self.masterContentView.bounds;
    [self.masterContentView addSubview:self.mainViewController.view];
    [self.view addSubview:self.masterContentView];
    [self.mainViewController didMoveToParentViewController:self];
    
    [self addChildViewController:self.menuViewController];
    [self.view insertSubview:self.menuViewController.view belowSubview:self.masterContentView];
    [self.menuViewController didMoveToParentViewController:self];
    
    [self updateMenuViewWithTransform:[self transformForClosedMenu]];
    
    self.view.userInteractionEnabled = YES;
    self.masterContentView.userInteractionEnabled = YES;
    self.mainViewController.view.userInteractionEnabled = YES;
    self.menuViewController.view.userInteractionEnabled = YES;
    
    mainOpenTransform = [self openTransformForView:self.masterContentView];
    //menuClosedTransform = [self transformForClosedMenu];
    
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [self.view addGestureRecognizer:panGestureRecognizer];
    
    UISwipeGestureRecognizer *panGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSwipe:(id)sender {
    [self toggleMenuAnimated:YES completion:nil];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint point = [recognizer locationInView:self.view];
    CGPoint translate = [recognizer translationInView:self.view];
    CGFloat scaleValue = 1 / scaleFactor;

    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        mainOriginalCenter = self.masterContentView.center;
        menuOriginalCenter = self.menuViewController.view.center;
        mainOriginalBounds = self.masterContentView.bounds;
        menuOriginalBounds = self.menuViewController.view.bounds;
//        mainOriginalTransform = self.masterContentView.transform;
//        menuOriginalTransform = self.menuViewController.view.transform;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        self.masterContentView.center = CGPointMake(mainOriginalCenter.x + point.x, mainOriginalCenter.y);
        self.menuViewController.view.center = CGPointMake(menuOriginalCenter.x + point.x, menuOriginalCenter.y);
//        CGAffineTransform mainTransformTranslate = CGAffineTransformTranslate(mainOriginalTransform, CGRectGetMidX(mainOriginalBounds) + translate.x, mainOriginalBounds.origin.y);
//        self.masterContentView.transform = mainTransformTranslate;//CGAffineTransformScale(mainTransformTranslate, scaleValue * translate.x/edgeTranslate.horizontal, scaleValue * translate.x/edgeTranslate.horizontal);
//        
//        CGAffineTransform menuTransformTranslate = CGAffineTransformTranslate(menuOriginalTransform, CGRectGetMidX(menuOriginalBounds) + translate.x, menuOriginalBounds.origin.y);
//        self.menuViewController.view.transform = menuTransformTranslate;//CGAffineTransformScale(menuTransformTranslate, scaleValue * translate.x/edgeTranslate.horizontal, scaleValue * translate.x/edgeTranslate.horizontal);
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        //[self toggleMenuAnimated:YES completion:nil];
        if (self.menuOpen == YES) {
            self.masterContentView.transform = CGAffineTransformIdentity;
            self.menuViewController.view.transform = [self transformForClosedMenu];
        } else {
            //self.masterContentView.center = CGPointMake(mainOriginalCenter.x + mainOpenTransform.tx, mainOriginalCenter.y + mainOpenTransform.ty);
            self.masterContentView.transform = [self openTransformForView:self.view];
            self.menuViewController.view.transform = CGAffineTransformIdentity;
        }
        self.menuOpen = !self.menuOpen;
    }
}



- (void)updateMenuViewWithTransform:(CGAffineTransform)transform {
    self.menuViewController.view.transform = transform;
    self.menuViewController.view.center = (CGPoint) { CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) };
    self.menuViewController.view.bounds = self.view.bounds;
}

-(CGAffineTransform)transformForClosedMenu {
    CGFloat transformValue = 1.0f / scaleFactor;
    CGAffineTransform transformScale = CGAffineTransformScale(self.menuViewController.view.transform, transformValue, transformValue);
    return CGAffineTransformTranslate(transformScale, -(CGRectGetMidX(self.view.bounds)) - edgeTranslate.horizontal, -edgeTranslate.vertical);
}

- (CGAffineTransform)openTransformForView:(UIView *)view
{
    CGFloat transformSize = scaleFactor;
    CGAffineTransform transformTranslate = CGAffineTransformTranslate(view.transform, CGRectGetMidX(view.bounds) + edgeTranslate.horizontal, edgeTranslate.vertical);
    return CGAffineTransformScale(transformTranslate, transformSize, transformSize);
}

- (void)openMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    if (self.menuOpen) {
        return;
    }

    self.menuOpen = YES;
    self.menuViewController.view.transform = [self transformForClosedMenu];
    
    [UIView animateWithDuration:animateDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.menuViewController.view.transform = CGAffineTransformIdentity;
                         self.masterContentView.transform = [self openTransformForView:self.masterContentView];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self addOverlayButtonToMainViewController];
                         }
                     }
     ];
}

- (void)closeMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    if (!self.menuOpen) {
        return;
    }
    
    self.menuOpen = NO;
    
    [self removeOverlayButtonFromMainViewController];
    
    
    [UIView animateWithDuration:animateDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.menuViewController.view.transform = [self transformForClosedMenu];
                         self.masterContentView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         self.menuViewController.view.transform = CGAffineTransformIdentity;
                     }
     ];
}

- (void)toggleMenuAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    if (self.menuOpen) {
        [self closeMenuAnimated:animated completion:completion];
    } else {
        [self openMenuAnimated:animated completion:completion];
    }
}

- (void)addOverlayButtonToMainViewController {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.opaque = NO;
    button.frame = self.masterContentView.frame;
    
    [button addTarget:self action:@selector(closeButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(closeButtonTouchedDown) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(closeButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    
    [self.view addSubview:button];
    self.closeButton = button;
}

- (void)removeOverlayButtonFromMainViewController {
    [self.closeButton removeFromSuperview];
}

- (void)closeButtonTouchUpInside {
    [self closeMenuAnimated:YES completion:nil];
}

- (void)closeButtonTouchedDown {
    self.closeButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
}

- (void)closeButtonTouchUpOutside {
    self.closeButton.backgroundColor = [UIColor clearColor];
}

- (void)setMainViewController:(UIViewController *)mainViewController animated:(BOOL)animated closeMenu:(BOOL)closeMenu {
    UIViewController *outgoingViewController = self.mainViewController;
    UIViewController *incomingViewController = mainViewController;
    
    UIView *overlayView = [[UIView alloc] initWithFrame:outgoingViewController.view.frame];
    overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    [self.masterContentView addSubview:overlayView];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @0.0f;
    animation.duration = animateDuration;
    [overlayView.layer addAnimation:animation forKey:@"opacity"];
    
    NSTimeInterval changeTimeInterval = animateSwitchDuration;
    NSTimeInterval delayInterval = animateDelay;
    if (!self.menuOpen) {
        changeTimeInterval = animateCloseDuration;
        delayInterval = 0.0;
    }
    
//    [self addShadowToViewController:incomingViewController];
    [self addViewController:incomingViewController];
    [self.masterContentView addSubview:incomingViewController.view];
    
    incomingViewController.view.frame = self.masterContentView.bounds;
    
    //Create default animation curve.
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut;
    switch (animationType) {
        case TWTSideMenuAnimationTypeSlideOver: {
            CGFloat outgoingStartX = CGRectGetMaxX(outgoingViewController.view.frame);
            
            incomingViewController.view.transform = CGAffineTransformTranslate(incomingViewController.view.transform, outgoingStartX, 0.0f);
            break;
        }
        case TWTSideMenuAnimationTypeFadeIn:
            incomingViewController.view.alpha = 0.6f;
            options = UIViewAnimationOptionCurveEaseOut;
            break;
    }
    
    
    void (^swapChangeBlock)(void) = ^{
        switch (animationType) {
            case TWTSideMenuAnimationTypeSlideOver:
                incomingViewController.view.transform = CGAffineTransformIdentity;
                break;
            case TWTSideMenuAnimationTypeFadeIn:
                incomingViewController.view.alpha = 1.0f;
            default:
                break;
        }
    };
    
    void (^finishedChangeBlock)(BOOL finished) = ^(BOOL finished) {
        [incomingViewController didMoveToParentViewController:self];
        
        [outgoingViewController removeFromParentViewController];
        [outgoingViewController.view removeFromSuperview];
        [outgoingViewController didMoveToParentViewController:nil];
        [overlayView removeFromSuperview];
        [self.closeButton removeFromSuperview];
        self.menuOpen = NO;
    };
    
    if (animated) {
        if (closeMenu) {
            [self closeMenuAnimated:animated completion:nil];
        }
        
        [UIView animateWithDuration:changeTimeInterval
                              delay:delayInterval
                            options:options
                         animations:swapChangeBlock
                         completion:finishedChangeBlock];
    } else {
        swapChangeBlock();
        finishedChangeBlock(YES);
    }
    
    self.mainViewController = mainViewController;
    self.mainViewController.masterViewController = self;
}

- (void)addViewController:(UIViewController *)viewController {
    viewController.masterViewController = self;
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
}


@end

@implementation UIViewController (MasterViewController)

- (void)setMasterViewController:(MasterViewController *)masterViewController {
    objc_setAssociatedObject(self, @selector(masterViewController), masterViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (MasterViewController *)masterViewController {
    MasterViewController *masterViewController = objc_getAssociatedObject(self, @selector(masterViewController));
    if (!masterViewController) {
        masterViewController = self.parentViewController.masterViewController;
    }
    return masterViewController;
}


@end
