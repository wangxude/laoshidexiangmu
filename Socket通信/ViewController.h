//
//  ViewController.h
//  Socket通信
//
//  Created by kys-5 on 16/11/25.
//  Copyright © 2016年 kys-5. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ViewController : UIViewController



@property (weak, nonatomic)  UITextField *sendTextField;
@property (weak, nonatomic)  UIButton *connectBtn;
@property (weak, nonatomic)  UIButton *disconnectBtn;
//@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (void)connectToHost:(id)sender;
- (void)disconnectToHost:(id)sender;
- (void)sendData:(id)sender;
@property (weak, nonatomic)  UITextField *connectWXTextField;

@property (weak, nonatomic)  UITableView *socketTableView;

@end

