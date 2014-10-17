//
//  B1_TopicMenuView.m
//  DZ
//
//  Created by nonato on 14-9-17.
//
//

#import "B1_TopicMenuView.h"
#import "UIImage+Tint.h"
#import "DZ_SystemSetting.h"
@implementation B1_TopicMenuView
@synthesize items;
DEF_SINGLETON(B1_TopicMenuView)
DEF_NOTIFICATION(selectitem)

#define BTNSELECTTXTCOLOR   [DZ_SystemSetting sharedInstance].navigationBarColor
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
    
    for (int index=0; index< self.items.allKeys.count; index++) {
        NSString * key = [self.items.allKeys objectAtIndex:index];
        NSString * value = [self.items valueForKey:key];
        UIButton *button=(UIButton *)[_backGroundView viewWithTag:value.integerValue + ITEMSSTARTTAG];
        [button setTitleColor:BTNTXTCOLOR forState:UIControlStateNormal];
    }
    [tapedBtn setTitleColor:BTNSELECTTXTCOLOR forState:UIControlStateNormal];
    [self sendSelfUISignal:tapedBtn];
    [self tappedCancel];
}

-(void)sendSelfUISignal:(UIButton *)button
{
    NSNumber *index=[NSNumber numberWithInteger:(button.tag - ITEMSSTARTTAG)];
    [self postNotification:self.selectitem withObject:index];
}

-(void)reloadButton:(NSString * )key title:(NSString *)title
{
    int index =[[items valueForKey:key] intValue];
    UIButton *button = (UIButton *)[_backGroundView viewWithTag:ITEMSSTARTTAG + index];
    [button setTitle:title forState:UIControlStateNormal];
}
-(void)dealloc
{
    
}

-(NSArray *)sortarray:(NSArray *)array
{
    NSString *COMPAREKEY = @"全部";
    NSMutableArray * mtbary = [NSMutableArray arrayWithArray:array];
    
    for (int index = 0; index < array.count; index ++ ) {
        NSString * key = [array objectAtIndex:index];
        if ([key isEqualToString: COMPAREKEY]) {
            if (index!=0) {
                [mtbary exchangeObjectAtIndex:index withObjectAtIndex:0];
            }
            break;
        }
    }
    return mtbary;
}
-(void)setItems:(NSDictionary *)aitems
{
    items = aitems;
    NSArray *array = items.allKeys;
    array = [self sortarray:array];
    
    float HEIGHT=35;
    float WIDTH=self.backGroundView.frame.size.width;
    for (int index=0; index< array.count; index++)
    {
        NSString *key =[array objectAtIndex:index];
        NSString * value=[NSString stringWithFormat:@"%@",[items objectForKey:key]];
        UIButton *button=(UIButton *) [self.backGroundView viewWithTag:ITEMSSTARTTAG + value.integerValue];
        if (!button) {
            button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0, HEIGHT * index + 5, WIDTH , HEIGHT);
            button.tag= ITEMSSTARTTAG + value.integerValue;
            [button setTitleColor:BTNTXTCOLOR forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [_backGroundView addSubview:button];
        }
        [button addTarget:self action:@selector(BTNACTIONS:) forControlEvents:UIControlEventTouchUpInside];

        [button setTitle:key forState:UIControlStateNormal];
    }
    [self reSizeBackgroundView:items];
}

-(UIView *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIScrollView alloc] initWithFrame:CGRectMake(200, 64.0f , 102, 150)];
        _backGroundView.backgroundColor= BACKGROUNDVIEWCOLOR;
        [self reSizeBackgroundView:items];
    }
    return _backGroundView;
}

-(void)reSizeBackgroundView:(NSDictionary *)dic
{
    int MAXCOUNT = 6;
    if (dic.count < MAXCOUNT) {
     [self.backGroundView setFrame:CGRectMake(200, 64.0f - bee.ui.config.heightOfStatusBar, 102, (items.count+1) * 30)];
    }
    else
    {
        [self.backGroundView setContentSize:CGSizeMake(102, (items.count+1) * 30)];
        [self.backGroundView setFrame:CGRectMake(200, 64.0f - bee.ui.config.heightOfStatusBar, 102, (MAXCOUNT +1) * 30)];
    }
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
             self.alpha = 0;
            [self removeFromSuperview];
        }
    }];
}


@end
