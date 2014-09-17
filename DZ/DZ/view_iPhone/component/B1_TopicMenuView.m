//
//  B1_TopicMenuView.m
//  DZ
//
//  Created by nonato on 14-9-17.
//
//

#import "B1_TopicMenuView.h"
#import "UIImage+Tint.h"

@implementation B1_TopicMenuView
@synthesize items;
DEF_SINGLETON(B3_PostMenuView)

DEF_NOTIFICATION(onlyReadBuildingOwner)
DEF_NOTIFICATION(allRead)
DEF_NOTIFICATION(reply)
DEF_NOTIFICATION(share)
DEF_NOTIFICATION(collect)
DEF_NOTIFICATION(delcollection)
DEF_NOTIFICATION(daoxu)

#define BTNTXTCOLOR [UIColor whiteColor]
#define BACKGROUNDVIEWCOLOR HEX_RGBA(0x3f3f3f, 0.95)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor =[UIColor clearColor]; //[UIColor colorWithRed:241./255 green:241/255. blue:241/255 alpha:1];//WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        UIImageView *triangle=[[UIImageView alloc] initWithImage:[UIImage bundleImageNamed:@"jiantou"]];
        triangle.image = [triangle.image imageWithTintColor:BACKGROUNDVIEWCOLOR];
        triangle.frame = CGRectMake(200+102-20, 64.0f-15.0f, 20, 20);
        triangle.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:triangle];
        [self addSubview:self.backGroundView];
        
    }
    return self;
}

-(IBAction)BTNACTIONS:(id)sender
{
    UIButton *tapedBtn=(UIButton *)sender;
    for (int index=0; index<5; index++) {
        UIButton *button=(UIButton *)[_backGroundView viewWithTag:index + ITEMSSTARTTAG];
        if (button.tag==tapedBtn.tag)
        {
        } else {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    [self sendSelfUISignal:tapedBtn];
    [self tappedCancel];
}

-(void)sendSelfUISignal:(UIButton *)button
{
    
}

-(void)reloadButton:(NSString * )key title:(NSString *)title
{
    int index =[[items valueForKey:key] integerValue];
    UIButton *button = (UIButton *)[_backGroundView viewWithTag:ITEMSSTARTTAG + index];
    [button setTitle:title forState:UIControlStateNormal];
}

-(void)setItems:(NSDictionary *)aitems
{
    items = aitems;
    NSArray *array = items.allKeys;
    float HEIGHT=35;
    float WIDTH=self.backGroundView.frame.size.width;
    for (int index=0; index< array.count; index++)
    {
        NSString *key =[array objectAtIndex:index];
        NSString * value=[items objectForKey:key];
        UIButton *button=(UIButton *) [self.backGroundView viewWithTag:ITEMSSTARTTAG + value.integerValue];
        if (!button) {
            button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0, HEIGHT * index + 5, WIDTH , HEIGHT);
            button.tag= ITEMSSTARTTAG + value.integerValue;
            [_backGroundView addSubview:button];
        }
        [button addTarget:self action:@selector(BTNACTIONS:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:BTNTXTCOLOR forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:key forState:UIControlStateNormal];
    }
    [self reSizeBackgroundView:items];
}

-(UIView *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(200, 64.0f , 102, 150)];
        _backGroundView.backgroundColor= BACKGROUNDVIEWCOLOR;
        [self reSizeBackgroundView:items];
    }
    return _backGroundView;
}

-(void)reSizeBackgroundView:(NSDictionary *)dic
{
     [self.backGroundView setFrame:CGRectMake(200, 64.0f - bee.ui.config.heightOfStatusBar, 102, (items.count+1) * 30)];
}

-(void)show
{
    [self reSizeBackgroundView:items];
    self.alpha = 1;
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(200, CGRectGetMinY(self.backGroundView.frame), CGRectGetWidth(self.backGroundView.frame), 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


@end
