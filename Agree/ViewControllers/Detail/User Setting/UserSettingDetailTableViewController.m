//
//  UserSettingDetailTableViewController.m
//  Agree
//
//  Created by Agree on 15/8/12.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "UserSettingDetailTableViewController.h"
#import "UserSettingDetailTableViewCell.h"
#import "UserViewController.h"
#import "FeedbackTableViewCell.h"

@interface UserSettingDetailTableViewController (){
     NSArray *_sexArray;
    UserViewController * userViewVC;
}

@end

@implementation UserSettingDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  

    
    if (kChooseSex == self.inputType) {
        //如果进入方法是选择性别
        //则初始化一个性别数组
        _sexArray = @[@"男", @"女", @"其他"];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (kFeedback == self.inputType) {
        return 100;
    }
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (self.inputType) {
        case 1: {
            //选择性别
            return _sexArray.count;
        }
            break;
        case 2: {
            //更改昵称
            return 1;
        }
        case 3: {
            //绑定手机号码
            return 1;
        }
        case kFeedback: {
            //反馈信息
            return 1;
        }

            break;

            break;
        default: {
            return 0;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (kChooseSex == self.inputType) {
        NSArray *array = [tableView visibleCells];
        for (UITableViewCell *cell in array) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (kFeedback == self.inputType) {
        static NSString *cellIdentifier = @"FeedbackCell";
        FeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        if (nil == cell) {
            cell = [[FeedbackTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell.feedbackTextView becomeFirstResponder];
        
        return cell;
        
    } else {
        static NSString *cellIdentifier = @"InputTableCell";
        UserSettingDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        if (nil == cell) {
            cell = [[UserSettingDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        switch (self.inputType) {
            case kChooseSex: {
                //选择性别
                [cell.inputTextField setEnabled:NO];
                [cell.inputTextField setHidden:YES];
                [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
                [cell.textLabel setText:[_sexArray objectAtIndex:indexPath.row]];
            }
                break;
            case kNickName: {
                //更改昵称
                [cell.inputTextField setPlaceholder:@"昵称"];
                [cell.inputTextField becomeFirstResponder];
            }
                break;
                
            case kBandPhone: {
                //绑定手机号码
                [cell.inputTextField setPlaceholder:@"手机号码"];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
                [cell.inputTextField becomeFirstResponder];
            }
                break;
            default: {
                return cell;
            }
                break;
        }
        
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (self.inputType) {
        case 1: {
            //选择性别
            return @"请选择你的性别";
        }
            break;
        case 2: {
            //更改昵称
            return @"请输入你想要更改的姓名";
        }
        case 3: {
            //更改昵称
            return @"请输入你的手机号码";
        }
        case kFeedback: {
            //回馈内容
            return @"请输入你的想要反馈的问题以及对我们的建议";
        }


            break;
        default: {
            return nil;
        }
            break;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    //更改的规则说明
    
    switch (self.inputType) {
        case 1: {
            //选择性别
            return nil;
        }
            break;
        case 2: {
            //更改昵称
            return @"用户姓名长度不能小于小于2个字符,\n最多只能包含14个字符,可以使用英文字母,\n数字或者中文构成,但是不能使用特殊的字符,\n如:'/\[]:;|=,+#*?<>'等,\n也不能使用包含有空格";
        }
        case 3: {
            //绑定手机号码
            return @"小提示:\n手机号码为11位纯数字,\n不需要在号码前面加上0或者+86";
        }
        case kFeedback: {
            //绑定手机号码
            return @"小提示:\n我们将会十分重视你的意见.";
        }


            break;
        default: {
            return nil;
        }
            break;
    }
    
}



























- (IBAction)tapBackButton:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}


//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if (kBandPhone == self.inputType) {
        return YES;
    }
    else if (kNickName == self.inputType){
        NSLog(@"保存名字的实现");
        
        return NO;
    }
    else if (kChooseSex == self.inputType){
        NSLog(@"保存性别的实现");
        
        return NO;
    }
    else if (kFeedback == self.inputType){
        NSLog(@"保存反馈的实现");
        
        return NO;
    }
    return NO;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
