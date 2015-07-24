//
//  GroupAlbumsCollectionViewController.m
//  Agree
//
//  Created by G4ddle on 15/2/2.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "GroupAlbumsCollectionViewController.h"
#import "SRImageManager.h"
#import "Model_Photo.h"
#import "GroupAlbumsCollectionViewCell.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "SRTool.h"
#import "MJExtension.h"
#import "SRNet_Manager.h"
#import "UIImageView+WebCache.h"
#import "CD_Photo.h"

#import <SVProgressHUD.h>
#import <MJRefresh.h>

@interface GroupAlbumsCollectionViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SRPhotoManagerDelegate> {
    
    UIImagePickerController *_imagePicker;
    UIImage *_pickImage;
    
    NSMutableArray *_imageViewAry;
    NSMutableDictionary *_imageViewDic;
    Model_Photo *_removePhoto;
    NSString *_imagePath;
}

@end

@implementation GroupAlbumsCollectionViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)loadPhotoData {
    
    if (!self.photoAry) {
        self.photoAry = [[NSMutableArray alloc] init];
    }
    //先读取缓存中的图片信息
    self.photoAry = [CD_Photo getPhotoFromCDByGroup:self.group];
    [self.albumsCollectionView reloadData];

    
    Model_Group *sendGroup = [[Model_Group alloc] init];
    [sendGroup setPk_group:self.group.pk_group];
    
    [SRNet_Manager requestNetWithDic:[SRNet_Manager getPhotoByGroupDic:sendGroup]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                if (jsonDic) {
                                    [CD_Photo removePhotoFromCDByGroup:self.group];
                                    self.photoAry = (NSMutableArray *)[Model_Photo objectArrayWithKeyValuesArray:jsonDic];
                                    
                                    for (Model_Photo *photo in self.photoAry) {
                                        [CD_Photo savePhotoToCD:photo];
                                    }
                                    [self.albumsCollectionView reloadData];
                                } else {
                                    
                                }
                                [self.albumsCollectionView.header endRefreshing];
                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                [SVProgressHUD showErrorWithStatus:@"网络错误"];
                            }];
    
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.photoAry) {
        return self.photoAry.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupAlbumsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    
    // Configure the cell
    Model_Photo *newPhoto = [self.photoAry objectAtIndex:indexPath.row];
    if (!_imageViewDic) {
        _imageViewDic = [[NSMutableDictionary alloc] init];
    }
    [cell.cellImageView setContentMode:UIViewContentModeScaleAspectFill];
    [cell setBackgroundColor:[UIColor lightGrayColor]];
    
    //下载图片
    NSURL *imageUrl = [SRImageManager albumThumbnailImageFromOSS:newPhoto.pk_photo];
    [cell.cellImageView sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [SRImageManager originalImageFromOSS:newPhoto.pk_photo]; // 图片路径
        photo.srcImageView = cell.cellImageView; // 来源于哪个UIImageView
        if ([newPhoto.fk_user isEqual:[Model_User loadFromUserDefaults].pk_user] || [self.rootController.group.creater isEqual:[Model_User loadFromUserDefaults].pk_user] ) {
            //如果为群主或者为图片的上传者,则可以设置删除图片代理
            photo.delegate = self;
        }
        //按照数序放入字典
        [_imageViewDic setObject:photo forKey:[NSNumber numberWithInteger:indexPath.row]];
    }];
    


    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float widthFloat = ([[UIScreen mainScreen] bounds].size.width - 3)/4;
    return CGSizeMake(widthFloat, widthFloat);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        // 弹出相册时显示的第一张图片是点击的图片
        browser.currentPhotoIndex = indexPath.row;
        // 设置所有的图片。photos是一个包含所有图片的数组。
        if (!_imageViewAry) {
            //如果图片数组还不存在
            _imageViewAry = [[NSMutableArray alloc] init];
            //对所有的图片进行排序
            for (int i = 0; i < _imageViewDic.count; i++) {
                [_imageViewAry addObject:[_imageViewDic objectForKey:[NSNumber numberWithInt:i]]];
            }
        }
        browser.photos = _imageViewAry;
        [browser show];
}


- (void)pressedTheUploadImageButton {
    //点击图片按钮
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        //判断是否有摄像头
        if(![UIImagePickerController isSourceTypeAvailable:sourceType]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"图片库", nil];
        [sheet showInView:self.rootController.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerControllerSourceType sourceType;
    if (0 == buttonIndex) {
        //直接拍照
        sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (1 == buttonIndex) {
        //使用相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        return;
    }
    _imagePicker.sourceType = sourceType;
    [self.rootController presentViewController:_imagePicker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    _pickImage = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    //    [self uploadImage:_chatPickImage];
    
    //初始化图片发送确认警告框
    UIAlertView *sendImageAlert = [[UIAlertView alloc] initWithTitle:@"确认信息"
                                                             message:@"是否确认发送图片?"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"确认", nil];
    [sendImageAlert show];
}

- (void)sendImage {
    _pickImage = [SRImageManager getSubImage:_pickImage withRect:CGRectMake(0, 0, 1280 , 1280)];
    _imagePath = [NSUUID UUID].UUIDString;
    
    [[SRImageManager initImageOSSData:_pickImage
                             withKey:_imagePath] uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
        if (isSuccess) {
            //图片上传成功
            Model_Photo *newPhoto = [[Model_Photo alloc] init];
            [newPhoto setCreate_time:[NSDate date]];
            [newPhoto setFk_group:self.rootController.group.pk_group];
            [newPhoto setFk_user:[Model_User loadFromUserDefaults].pk_user];
            [newPhoto setPk_photo:_imagePath];
            [newPhoto setStatus:@1];
            
            [self.photoAry insertObject:newPhoto atIndex:0];
            
            [SRNet_Manager requestNetWithDic:[SRNet_Manager addImageToGroupDic:newPhoto]
                                    complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                        [SVProgressHUD showProgress:1.0 status:@"上传图片数据"];
                                        if (jsonDic) {
                                            //清除原先数组中的元素
                                            [_imageViewAry removeAllObjects];
                                            _imageViewAry = nil;
                                            [_imageViewDic removeAllObjects];
                                            _imageViewDic = nil;
                                            [self.albumsCollectionView reloadData];
                                        } else {
                                            
                                        }
                                        [SVProgressHUD showSuccessWithStatus:@"成功"];
                                    } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                        [SVProgressHUD showErrorWithStatus:@"网络错误"];
                                    }];
        } else {
            
        }
        
    } withProgressCallback:^(float progress) {
        [SVProgressHUD showProgress:progress*0.9 status:@"正在上传图片"];
    }];
    
}


- (void)deletePhoto:(NSUInteger)index {
    _removePhoto = [self.photoAry objectAtIndex:index];
    
    [SRNet_Manager requestNetWithDic:[SRNet_Manager removePhotoDic:_removePhoto]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                if (jsonDic) {
                                    [self.photoAry removeObject:_removePhoto];
                                    [_imageViewAry removeAllObjects];
                                    _imageViewAry = nil;
                                    [_imageViewDic removeAllObjects];
                                    _imageViewDic = nil;
                                    [self.albumsCollectionView reloadData];
                                } else {
                                    
                                }
                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                [SVProgressHUD showErrorWithStatus:@"网络错误"];
                            }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex) {
        //取消发送
    } else {
        //确认发送
        [self sendImage];
    }
}

@end
