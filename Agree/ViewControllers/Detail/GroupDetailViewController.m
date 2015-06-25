//
//  GroupDetailViewController.m
//  SRAgree
//
//  Created by G4ddle on 14/12/16.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "Model_Chat.h"
#import <SVProgressHUD.h>
#import "GroupChatTableViewController.h"
#import "GroupPartyTableViewController.h"
#import "ChooseLoctaionViewController.h"
#import "GroupSettingViewController.h"
#import "PartyDetailViewController.h"
#import "GroupAlbumsCollectionViewController.h"
#import "SRNet_Manager.h"
#import "MJExtension.h"
#import "AppDelegate.h"
#import "GroupAlbumsCollectionViewCell.h"
#import "GroupChatTableViewCell.h"
#import "MJPhotoBrowser.h"
#import <EaseMob.h>
#import <MJRefresh.h>

#import "SRKeyboard.h"

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]



@interface GroupDetailViewController () <UITabBarDelegate,UIScrollViewDelegate> {
    GroupChatTableViewController *_chatDelegate;
    GroupPartyTableViewController *_partyDelegate;
    GroupAlbumsCollectionViewController *_albumsDelegate;
    
    SRKeyboard *_srKeyboard;
    
    NSDictionary *norDic;
    NSDictionary *selDic;
    
    GroupChatTableViewCell *cell;
    
    EMConversation *_conversation;
    
 

}

@end

@implementation GroupDetailViewController


- (void)viewDidLayoutSubviews {
    NSLog(@"%f", self.chatTableView.contentSize.height);
    [_chatDelegate.closelable setFrame:CGRectMake(0, self.chatTableView.contentSize.height + self.navigationController.navigationBar.frame.size.height-30, self.view.frame.size.width, 50)];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.groupTabBar setSelectedItem:self.groupTalk];
  
    [self.navigationItem setTitle:self.group.name];
    [self.selectLineWidth setConstant:[[UIScreen mainScreen] bounds].size.width/3];
    
    norDic = [NSDictionary dictionaryWithObjectsAndKeys:
              [UIColor grayColor],
              NSForegroundColorAttributeName,
              [UIFont fontWithName:@"STHeitiSC-Light" size:12.0f],
              NSFontAttributeName,
              nil];
    
    selDic = [NSDictionary dictionaryWithObjectsAndKeys:
              self.view.tintColor,
              NSForegroundColorAttributeName,
              [UIFont fontWithName:@"STHeitiSC-Light" size:12.0f],
              NSFontAttributeName,
              nil];
    
    [self.groupTalk setTitleTextAttributes:norDic
                                  forState:UIControlStateNormal];
    
    [self.groupTalk setTitleTextAttributes:selDic
                                  forState:UIControlStateSelected];
    
    [self.groupSchedule setTitleTextAttributes:norDic
                                      forState:UIControlStateNormal];
    
    [self.groupSchedule setTitleTextAttributes:selDic
                                      forState:UIControlStateSelected];
    
    [self.groupPhotos setTitleTextAttributes:norDic
                                    forState:UIControlStateNormal];
    
    [self.groupPhotos setTitleTextAttributes:selDic
                                    forState:UIControlStateSelected];
    
    
    self.accountView = [[SRAccountView alloc] init];
    [self.accountView setRootController:self];
    
    //设置聊天表单代理
    
    
    _chatDelegate = [[GroupChatTableViewController alloc] init];

    _chatDelegate.group = self.group;
    _chatDelegate.chatTableView = self.chatTableView;
    [self.chatTableView setDelegate:_chatDelegate];
    [self.chatTableView setDataSource:_chatDelegate];
    [_chatDelegate setRootController:self];

    [_chatDelegate loadChatData];
//    [self subChatArray];
    
    

    
    
    self.view.backgroundColor =[UIColor groupTableViewBackgroundColor];
    
    _albumsDelegate = [[GroupAlbumsCollectionViewController alloc] init];
    _albumsDelegate.albumsCollectionView = self.albumsCollectionView;
    _albumsDelegate.group = self.group;
    
    self.albumsCollectionView.delegate = _albumsDelegate;
    self.albumsCollectionView.dataSource = _albumsDelegate;
    
    _albumsDelegate.albumsCollectionView.alwaysBounceVertical = YES;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.albumsCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:_albumsDelegate refreshingAction:@selector(loadPhotoData)];
    
    _albumsDelegate.rootController = self;
    
    [self setkeyBoard];
}



- (void)didReceiveMemoryWarning {
    
}

- (void)setkeyBoard {
    //初始化键盘
    _srKeyboard = [[SRKeyboard alloc] init];
    [_srKeyboard textViewShowView:self customKeyboardDelegate:_chatDelegate withMoveView:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate setChatDelegate:self];
    
    if (self.partyLoadingAgain) {
        [_partyDelegate loadPartyData];
        self.partyLoadingAgain = FALSE;
    }
}

- (void)receiveParty {
    [_partyDelegate loadPartyData];
}

- (void)viewDidDisappear:(BOOL)animated {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate setChatDelegate:nil];
}

- (void)showImageAtIndexPath:(int)indexPath withImageArray: (NSMutableArray *)imageViewArray {
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    // 弹出相册时显示的第一张图片是点击的图片
    browser.currentPhotoIndex = indexPath - 1;
    // 设置所有的图片。photos是一个包含所有图片的数组。
    
    browser.photos = imageViewArray;
    [browser show];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    [self.groupScrollView setContentOffset:CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) * (item.tag - 1), 0) animated:YES];
    if (1 == item.tag) {
        //点击聊天选项
        [self.selectConLeft setConstant:0];
    } else if (2 == item.tag) {
        //点击日程选项
        [self.selectConLeft setConstant:[[UIScreen mainScreen] bounds].size.width/3];


    } else {
        //点击相册选项
        [self.selectConLeft setConstant:[[UIScreen mainScreen] bounds].size.width/3 * 2];
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//#pragma mark -- 下拉加载数据
//    
//    float contentoffsetY = _chatDelegate.chatTableView.contentOffset.y;
//    
//    //判断如果下拉超过限定 就加载数据
//    if ((-110  >= (contentoffsetY))&&!(_chatDelegate.mchatArray.count == _chatDelegate.chatArray.count) ){
//        NSLog(@"下拉如果超过-110realoadata");
//        _chatDelegate.page++;
//        NSLog(@"%d",_chatDelegate.page);
//        [_chatDelegate subChatArray];
//        [_chatTableView reloadData];
//        NSLog(@"%F",contentoffsetY);
//        
//        
//    }
//    //默认一次10个 这是最后一次加载大于0小于10的个数
//    else if( _chatDelegate.chatArray.count - _chatDelegate.mchatArray.count > 0 && _chatDelegate.chatArray.count - _chatDelegate.mchatArray.count < 10  ){
//        _chatDelegate.mchatArray = _chatDelegate.chatArray;
//        
//        [_chatTableView reloadData];
//        
//    }else if( _chatDelegate.mchatArray.count == _chatDelegate.chatArray.count )
//    {
//        NSLog(@"数组已经加载结束 停止加载");
//    }
//    
//    NSLog(@"%d",_chatDelegate.mchatArray.count);
//    NSLog(@"%d",_chatDelegate.chatArray.count);
//    
//    
//}

//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (0.0 == scrollView.contentOffset.x) {
        
        [self.selectConLeft setConstant:0];
        
        //群聊界面
        [self.groupTabBar setSelectedItem:self.groupTalk];
        [_srKeyboard.mBackView setHidden:NO];
        [self setkeyBoard];
    } else if (CGRectGetWidth([UIScreen mainScreen].bounds) == scrollView.contentOffset.x) {
        
        [self.selectConLeft setConstant:[[UIScreen mainScreen] bounds].size.width/3];
        
        //日程界面
        [self.groupTabBar setSelectedItem:self.groupSchedule];
        [_srKeyboard.mBackView setHidden:YES];
        _srKeyboard = nil;
        if (!_partyDelegate) {
            //设置日程表单代理
            _partyDelegate = [[GroupPartyTableViewController alloc] init];
            _partyDelegate.partyTableView = self.partyTableView;
            _partyDelegate.group = self.group;
            _partyDelegate.delegate = self;
            [self.partyTableView setDelegate:_partyDelegate];
            [self.partyTableView setDataSource:_partyDelegate];
            
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
            self.partyTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:_partyDelegate refreshingAction:@selector(loadPartyData)];
            [_partyDelegate loadPartyData];
            //            [self.partyTableView reloadData];
        }
    } else if (CGRectGetWidth([UIScreen mainScreen].bounds) * 2 == scrollView.contentOffset.x) {
        //相册界面
        
        [self.selectConLeft setConstant:[[UIScreen mainScreen] bounds].size.width/3 * 2];
        
        [self.groupTabBar setSelectedItem:self.groupPhotos];
        [_srKeyboard.mBackView setHidden:YES];
        _srKeyboard = nil;
        if (!_albumsDelegate.albumsLoadingDone) {
            [_albumsDelegate loadPhotoData];
            _albumsDelegate.albumsLoadingDone = TRUE;
        }
    }
    else {
        
    }

}

- (IBAction)tapCreateNewPhotoButton:(id)sender {
    [_albumsDelegate pressedTheUploadImageButton];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.scrollViewWidth.constant = CGRectGetWidth([UIScreen mainScreen].bounds) * 3;
    self.view1Width.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.view2Width.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.view3Width.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
}
- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)longTapCell {
    
     cell = (GroupChatTableViewCell *)_chatDelegate.longTapCell;
    
    [cell becomeFirstResponder];
    if (![self canBecomeFirstResponder]) {
        NSLog(@"become f");
    }
        UIMenuItem *itCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(handleCopyCell:)];
        UIMenuItem *itReSend = [[UIMenuItem alloc] initWithTitle:@"再次发送" action:@selector(handleResendCell:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:itCopy,itReSend, nil]];
    

        EModel_Chat *chat = [_chatDelegate.chatArray objectAtIndex:[[self.chatTableView indexPathForCell:cell] row]];
        
        
        id<IEMMessageBody> msgBody = chat.message.messageBodies.firstObject;
    
        switch (msgBody.messageBodyType) {
            case eMessageBodyType_Text: {
                //文本
                if (chat.sendFromSelf) {
                    //自己发言
                    [menu setTargetRect:CGRectMake(cell.chatMessageBackground_self.frame.origin.x, cell.frame.origin.y + 30, cell.messageBackgroundButton_self.frame.size.width, cell.messageBackgroundButton_self.frame.size.height) inView:self.chatTableView];
                    
                } else {
                    //他人发的信息
                    [menu setTargetRect:CGRectMake(cell.chatMessageBackground.frame.origin.x, cell.frame.origin.y + 30, cell.messageBackgroundButton.frame.size.width, cell.messageBackgroundButton.frame.size.height) inView:self.chatTableView];
                }
            }
                break;
            case eMessageBodyType_Image: {
                //图片
                if (chat.sendFromSelf) {
                    
                    
                } else {
                    //他人发的图片
                    
                }
            }
            default:
                break;
        }
        
    [menu setMenuVisible:YES animated:YES];
    
    NSLog(@"小组复制");
}

- (void)handleCopyCell:(id)sender
{
    NSLog(@"复制");
    

    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    if (cell.chatMessageTextLabel_self) {
        pboard.string = cell.chatMessageTextLabel_self.text;
    }else if
        (cell.chatMessageTextLabel)
    {
        pboard.string = cell.chatMessageTextLabel.text;
    }
    
    //复制出的内容
    NSLog(@"%@",cell.chatMessageTextLabel_self.text);
    
    NSLog(@"%@",cell.chatMessageTextLabel.text);
    
    
}

- (void)handleResendCell:(id)sender {
    NSLog(@"handle resend cell");
}


- (BOOL)canBecomeFirstResponder{
    return YES;
}

//上拉关闭当前页
- (void)popController {
    [self.navigationController popViewControllerAnimated:YES];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //进入小组详情
    if ([@"AddNewParty"  isEqual: segue.identifier]) {
        //读取小组详情数据并赋值小组数据
        ChooseLoctaionViewController *controller = (ChooseLoctaionViewController *)segue.destinationViewController;
        controller.chooseGroup = self.group;
        controller.isGroupParty = TRUE;
    } else if ([@"GroupSetting" isEqual:segue.identifier]) {
        //进入小组设置
        GroupSettingViewController *controller = (GroupSettingViewController *)segue.destinationViewController;
        controller.group = self.group;
    } else if ([@"PartyDetail" isEqual:segue.identifier]) {
        PartyDetailViewController *controller = (PartyDetailViewController *)segue.destinationViewController;
        controller.delegate = _partyDelegate;
        controller.party = self.chooseParty;
    } else {
    
    }
}




@end
