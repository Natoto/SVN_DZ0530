//
//  B4_MoreOperationViewController.m
//  DZ
//
//  Created by Nonato on 14-9-4.
//
//

#import "B4_MoreOperationViewController.h"
#import "bee.h"
@interface B4_MoreOperationViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation B4_MoreOperationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UISwipeGestureRecognizer *tapgest =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:tapgest];
    
//    UITapGestureRecognizer *tapgest2 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
//    [self.webview addGestureRecognizer:tapgest2];
//    [self.navigationController.navigationBar setHidden:YES];
    // Do any additional setup after loading the view.
}

-(void)viewTap:(UISwipeGestureRecognizer *)gestureRcg
{
    if ( gestureRcg.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self popViewController];
    }
}

-(void)popViewController
{    
    [[UIApplication  sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:NO];
 
}
-(void)dealloc
{
    
}

-(UIWebView *)webview
{
    if (!_webview) {
        _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), self.view.frame.size.height)];
        _webview.contentMode = UIViewContentModeCenter;
//        showGestureRecognizers(_webview, YES);
        [self.view addSubview:_webview];
    }
    return _webview;
}

-(void)singleTapRecognized:(UIGestureRecognizer *)gesture
{
   BeeLog(@"singleTapRecognized .........");
}

-(void)setContentstring:(NSString *)contentstring
{
    _contentstring = contentstring;
    if (self.webview) {
        self.webview.delegate = self;
        NSString *webcontent=[self htmlstr:_contentstring];
        [self.webview loadHTMLString:webcontent baseURL:nil];
    }
}

-(NSString *)javascript
{
    NSString *js=@"<script type=\"text/javascript\">\
    document.getElementById(\"div1\").addEventListener(\"click\", gestureend, false);\
    function gestureend(e) {\
    var url=\"bodyclick:\"+e;\
    document.location = url;\
    }\
    </script>";
    return js;
}
-(NSString *)htmlstr:(NSString *)message
{
    NSString *htmstr=[NSString stringWithFormat:@"<html><head>\
                      <style type=\"text/css\">\
                      body,html{\
                      padding:0;\
                      margin:0;\
                      text-align:center;\
                      vertical-align:middle;\
                      height:100%%;\
                      overflow:hidden;\
                      }\
                      #wrap {\
                      display:table;\
                      width:%.2fpx;\
                      height:480px;\
                      _position:relative;\
                      position:absolute; top:50%%; left:50%%; margin-left:-45%%;margin-right:-45%%; margin-top:-50%%;\
                      overflow:hidden;\
                      }\
                      #subwrap {\
                      vertical-align:middle;\
                      display:table-cell;\
                      _position:absolute;\
                      _top:50%%;\
                      }\
                      #content {\
                      _position:relative;\
                      _top:-50%%;\
                      }\
                      </style>\
                      </head>\
                      <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>\
                      <body><div id=\"div1\">\
                      <div id=\"wrap\">\
                      <div id=\"subwrap\">\
                      <div id=\"content\"><font  size=\"5\">%@</font>\
                      </div></div></div></div>%@\
                      </body>\
                      </html>",CGRectGetWidth([UIScreen mainScreen].bounds)*0.9,message,[self javascript]];
    return htmstr;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] >= 1) {
        if ([(NSString *)[components objectAtIndex:0] isEqualToString:@"bodyclick"]) {
            //响应事件
            [self popViewController];
            return NO;
        }
        return YES;
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
