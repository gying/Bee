//
//  ContactsDetailTableViewController.m
//  Agree
//
//  Created by G4ddle on 15/3/18.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "ContactsDetailTableViewController.h"
#import <AddressBook/AddressBook.h>

#import "SRNet_Manager.h"
#import "People.h"
#import <SVProgressHUD.h>
#import "MJExtension.h"

#import "AddressBookTableViewCell.h"
#import "SRAccountView.h"


@interface ContactsDetailTableViewController () <SRNetManagerDelegate> {
    NSMutableArray *_contactArray;
    NSMutableArray *_checkPhoneArray;
    SRNet_Manager *_netManager;
    NSMutableArray *_matchUserArray;
    SRAccountView *_accountView;
}

@end

@implementation ContactsDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"relation_update"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _accountView = [[SRAccountView alloc] init];
    [_accountView setHidden:YES];
    [self getAddressBook];
}

- (void)getAddressBook {
    _contactArray = [[NSMutableArray alloc] init];
    _checkPhoneArray = [[NSMutableArray alloc] init];
    
    ABAddressBookRef addressBooks = nil;
    
    addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        
    //获取通讯录权限
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    //通讯录中人数
    CFIndex peopleNum = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < peopleNum; i++) {
        
        People *newPeople = [[People alloc] init];
        
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        //打印名称
//        NSLog(@"NAME: %@\n", nameString);
        [newPeople setName:nameString];
        int bookID = (int)ABRecordGetRecordID(person);
//        NSLog(@"ID: %d\n", bookID);
        [newPeople setPeople_id:bookID];
        ABMultiValueRef abPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int p = 0; p < ABMultiValueGetCount(abPhones); p++) {
            CFStringRef phone = ABMultiValueCopyValueAtIndex(abPhones,p);
            if (nil == newPeople.phoneAry) {
                newPeople.phoneAry = [[NSMutableArray alloc] init];
            }
            NSString *phoneString = (__bridge NSString *)phone;
            phoneString = [phoneString stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            phoneString = [phoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
            phoneString = [phoneString stringByReplacingOccurrencesOfString:@"(" withString:@""];
            phoneString = [phoneString stringByReplacingOccurrencesOfString:@")" withString:@""];
            phoneString = [phoneString stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            
            [newPeople.phoneAry addObject:phoneString];
//            NSLog(@"Phone: %@\n", phone);
            [_checkPhoneArray addObject:phoneString];
        }
        
        [_contactArray addObject:newPeople];
    }
    
    [self matchAddressBook];
}

- (void)matchAddressBook {
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    [_netManager matchPhones:_checkPhoneArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_contactArray) {
        return _contactArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressBookCell" forIndexPath:indexPath];
    if (nil == cell) {
        cell = [[AddressBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddressBookCell"];
    }
    
    [cell initWithPeople:[_contactArray objectAtIndex:indexPath.row]];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    People *adPeople = [_contactArray objectAtIndex:indexPath.row];
    if (adPeople.userInfo.relationship) {
        if ([adPeople.userInfo.relationship isEqualToNumber:@3]) {
            [_accountView show];
            Model_User *sendUser = [[Model_User alloc] init];
            
            sendUser.pk_user = adPeople.userInfo.pk_user;
            sendUser.nickname = adPeople.userInfo.nickname;
            sendUser.avatar_path = adPeople.userInfo.avatar_path;
            [_accountView loadWithUser:sendUser withGroup:nil];
        }
    }
}

- (void)matchAddressBookByUserArray {
    for (Model_User *user in _matchUserArray) {
        BOOL finish = false;
        for (People *adPeople in _contactArray) {
            for (NSString *phoneNum in adPeople.phoneAry) {
                if ([user.phone isEqualToString:phoneNum]) {
                    //匹配成功
                    NSUInteger peopleIndex = [_contactArray indexOfObject:adPeople];
                    adPeople.userInfo = user;
                    [_contactArray insertObject:adPeople atIndex:0];
                    [_contactArray removeObjectAtIndex:(peopleIndex + 1)];
                    
                    finish = TRUE;
                    break;
                }
            }
            if (finish) {
                break;
            }
        }
        
        //如果帐号不匹配,则为单独必聚帐号.
        if (!finish) {
            People *agreePeople = [[People alloc] init];
            agreePeople.userInfo = user;
            [_contactArray insertObject:agreePeople atIndex:0];
        }
    }
    [self.tableView reloadData];
}

- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType {
    switch (interfaceType) {
        case kMatchPhones: {
            if (jsonDic) {
                //找到匹配的项目
                _matchUserArray = (NSMutableArray *)[Model_User objectArrayWithKeyValuesArray:jsonDic];
                [self matchAddressBookByUserArray];
            }
        }
            break;
            
        default:
            break;
    }
    
    [SVProgressHUD dismiss];
}

- (void)interfaceReturnDataError:(int)interfaceType {
    [SVProgressHUD showErrorWithStatus:@"网络错误"];
}
- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
