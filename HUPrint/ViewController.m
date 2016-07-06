//
//  ViewController.m
//  HUPrint
//
//  Created by huweiya on 16/4/22.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIPrintInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //浏览pdf
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PDF使用指南.pdf" ofType:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    
    
    
    
    NSURL *pdfUrl = [NSURL URLWithString:path];
    
    
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:pdfUrl];
    
    _myWebView.scalesPageToFit = YES;
    
    [_myWebView loadRequest:request];
    
    
    
}



- (IBAction)btnAction:(UIButton *)sender {
    
    //打印功能
    
    
//    [self hehe:nil];
        [self printActionsbutton:sender];
    
    
    
}



- (void)printInteractionControllerDidFinishJob:(UIPrintInteractionController *)printInteractionController{
    
    NSLog(@"%@",printInteractionController.printInfo.jobName);
    
    
}

- (void)printInteractionControllerWillStartJob:(UIPrintInteractionController *)printInteractionController{
    
}



- (void)printInteractionControllerWillPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController{
    
}


- (void)printInteractionControllerDidDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController
{
    
}


// 打印
-(void)printActionsbutton:(id)sender{
    //获取要打印的图片
    UIImage * printImage = [UIImage imageNamed:@"fire.png"];
    //剪切原图（824 * 2235）  这里需要说明下 因为A4 纸的72像素的 大小是（595，824） 为了打印出A4 纸 之类把原图转化成A4 的宽度，高度可适当调高 以适应页面内容的需求 ，调这个很简单地，打开你目前截取的图片，点击工具，然后点击调整大小，把宽度设置成595 就可以了，看高度是多少 除以 824 就是 几页 ，不用再解释了吧。。。ios打印功能实现（ScrollerView打印）
    
    
    UIImage * scanImage = [self scaleToSize:printImage size:CGSizeMake(595, 1660)];
    
    UIImage *jietuImage = [self imageFromImage:scanImage inRect:CGRectMake(0, 0, 595, 880)];
    
    UIPrintInteractionController *printC = [UIPrintInteractionController sharedPrintController];//显示出打印的用户界面。
    
    
    
    printC.delegate = self;
    
    if (!printC) {
        NSLog(@"打印机不存在");
        
    }
    

    printC.showsNumberOfCopies = YES;
    printC.showsPageRange = YES;
    
    
    NSData *imgDate = UIImagePNGRepresentation(jietuImage);
    
    NSData *data = [NSData dataWithData:imgDate];
    
    

    NSString *pdf = [[NSBundle mainBundle] pathForResource:@"PDF使用指南.pdf" ofType:nil];
    
    NSData *pdfData = [NSData dataWithContentsOfFile:pdf];

    
//        NSArray *arr = @[data,data];//打印多张图片
    
    
    if (printC && [UIPrintInteractionController canPrintData:pdfData]) {
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];//准备打印信息以预设值初始化的对象。
        printInfo.outputType = UIPrintInfoOutputGeneral;//设置输出类型。
        printC.showsPageRange = YES;//显示的页面范围
        
        printInfo.jobName = @"my.job";
        
        printC.printInfo = printInfo;
        
        //设置打印源文件
        printC.printingItem = pdfData;//single NSData, NSURL, UIImage, ALAsset
            
        
        
        // 等待完成
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            
            if (!completed && error) {
                NSLog(@"可能无法完成，因为印刷错误: %@", error);
            }
            
            
            
            if (completed) {
                NSLog(@"完成了");
            }else{
                NSLog(@"出错了");

            }
            
            
            
            
            
            
            
            
            
        };
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:sender];//调用方法的时候，要注意参数的类型－下面presentFromBarButtonItem:的参数类型是 UIBarButtonItem..如果你是在系统的UIToolbar or UINavigationItem上放的一个打印button，就不需要转换了。
            
            
            [printC presentFromBarButtonItem:item animated:YES completionHandler:completionHandler];//在ipad上弹出打印那个页面
        } else {
            
            
            [printC presentAnimated:YES completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
                
                
                
            }];
            
//            [printC presentAnimated:YES completionHandler:completionHandler];//在iPhone上弹出打印那个页面
        }
   
    }
}

// 打印  这里解释下，由于要分页打印，我暂时 没找到合适的方法  就用了两个Button  设置了两个点击事件，jietuImage2 这个的Y坐标 设置到 上面的高度，然后就可以打印第二页了，没办法，项目赶紧，坑坑坑，有找到分页打印的帮忙留下代码，非常感谢
-(void)printActionsbutton2:(id)sender{
    
    //获取要打印的图片
    UIImage * printImage = [UIImage imageNamed:@"屏幕快照 2016-04-22 上午11.44.39"];
    //剪切原图（824 * 2235）  （789 960）
    UIImage * scanImage = [self scaleToSize:printImage size:CGSizeMake(595, 1660)];
    UIImage *jietuImage2 = [self imageFromImage:scanImage inRect:CGRectMake(0, 880, 595, 824)];
    UIPrintInteractionController *printC = [UIPrintInteractionController sharedPrintController];//显示出打印的用户界面。
    printC.delegate = self;
    
    if (!printC) {
        NSLog(@"打印机不存在");
        
    }
    
    printC.showsNumberOfCopies = YES;
    printC.showsPageRange = YES;
    NSData *imgDate = UIImagePNGRepresentation(jietuImage2);
    NSData *data = [NSData dataWithData:imgDate];
    if (printC && [UIPrintInteractionController canPrintData:data]) {
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];//准备打印信息以预设值初始化的对象。
        printInfo.outputType = UIPrintInfoOutputGeneral;//设置输出类型。
        printC.showsPageRange = YES;//显示的页面范围
        
        //printInfo.jobName = @"my.job";
        printC.printInfo = printInfo;
        printC.printingItem = data;//single NSData, NSURL, UIImage, ALAsset
        
        // 等待完成
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"可能无法完成，因为印刷错误: %@", error);
            }
        };
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:sender];//调用方法的时候，要注意参数的类型－下面presentFromBarButtonItem:的参数类型是 UIBarButtonItem..如果你是在系统的UIToolbar or UINavigationItem上放的一个打印button，就不需要转换了。
            [printC presentFromBarButtonItem:item animated:YES completionHandler:completionHandler];//在ipad上弹出打印那个页面
        } else {
            [printC presentAnimated:YES completionHandler:completionHandler];//在iPhone上弹出打印那个页面
        }
    }
}


//______ 暂时无用   paperList据说是分页的，但是没找到具体信息，回头再找
- (UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)printInteractionController choosePaper:(NSArray *)paperList {
    //设置纸张大小
    CGSize paperSize = CGSizeMake(595, 880);
    return [UIPrintPaper bestPaperForPageSize:paperSize withPapersFromArray:paperList];
}

//绘制原图 这个就是将原图改变为A4 纸宽度的图片
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(20,20,size.width,size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

//截取原图  截取部分 打印的图片就是从这里来
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;

}



-(void)hehe:(id)sender{
    
    UIPrintInteractionController *printC = [UIPrintInteractionController sharedPrintController];//显示出打印的用户界面。
    printC.delegate = self;
    
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];//准备打印信息以预设值初始化的对象。
    printInfo.outputType = UIPrintInfoOutputGeneral;//设置输出类型。
    printC.showsPageRange = YES;//显示的页面范围
    
    //    打印网
    
    printC.printFormatter = [_myWebView viewPrintFormatter];//布局打印视图绘制的内容。
    
    
    UIViewPrintFormatter *form = [[UIViewPrintFormatter alloc] init];
    
    form.maximumContentHeight = 40;
    
    
    [_myWebView drawRect:CGRectMake(0, 0, 300, 300) forViewPrintFormatter:form];
    
    
    /*
     //    打印文本
     UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc]
     initWithText:@"ここの　ういえい　子に　うぃっl willingseal  20655322　　你好么？ ＃@¥％……&＊"];
     textFormatter.startPage = 0;
     textFormatter.contentInsets = UIEdgeInsetsMake(200, 300, 0, 72.0); // 插入内容页的边缘 1 inch margins
     textFormatter.maximumContentWidth = 16 * 72.0;//最大范围的宽
     printC.printFormatter = textFormatter;
     */
    
    
    //    等待完成
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"可能无法完成，因为印刷错误: %@", error);
        }
    };
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:sender];//调用方法的时候，要注意参数的类型－下面presentFromBarButtonItem:的参数类型是 UIBarButtonItem..如果你是在系统的UIToolbar or UINavigationItem上放的一个打印button，就不需要转换了。
        [printC presentFromBarButtonItem:item animated:YES completionHandler:completionHandler];//在ipad上弹出打印那个页面
        
        //        [printC presentFromRect:CGRectMake(500, 500, 100, 200) inView:self.webView animated:YES completionHandler:completionHandler];//第二种方法
        
        
    } else {
        [printC presentAnimated:YES completionHandler:completionHandler];//在iPhone上弹出打印那个页面
    }
    
    
}




@end
