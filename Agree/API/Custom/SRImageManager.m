//
//  SRImageManager.m
//  Agree
//
//  Created by G4ddle on 15/1/22.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "SRImageManager.h"
#import "ProgressHUD.h"
#import "OSSData.h"
#import "TXYUploadManager.h"

@implementation SRImageManager

- (id)initWithDelegate: (id<SRImageManagerDelegate>)delegate {
    self.delegate = delegate;
    return [super init];
}

//等比例缩放图片
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
                                UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
    return scaledImage;
}

//裁剪图片
+ (UIImage *)getSubImage:(UIImage *)image withRect:(CGRect)rect {
    
    image = [self scaleImage:image toScale:image.size.height<image.size.width?rect.size.width/image.size.height:rect.size.height/image.size.width];
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(image.size.width > image.size.height ? (image.size.width - rect.size.width)/2:0, image.size.width < image.size.height ? (image.size.height - rect.size.height)/2:0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

- (NSString *)updateAvatarImageToBucket: (UIImage *)image {
    NSString *imageName = [[NSUUID UUID] UUIDString];
    
    [ProgressHUD show:@"正在上传"];
    OSSBucket *bucket = [[OSSBucket alloc] initWithBucket:@"superrabbit"];
    OSSData *imageData = [[OSSData alloc] initWithBucket:bucket withKey:[NSString stringWithFormat:@"%@.png", imageName]];
    
    NSData *update = UIImageJPEGRepresentation(image, 0.75);
    [imageData setData:update withType:@"image"];
    
    [imageData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
        if (isSuccess) {
            NSLog(@"done");
            [self updateMiniAvatarImageToBucket:image withName:imageName];
        } else {
            NSLog(@"errorInfo_testDataUploadWithProgress:%@", [error userInfo]);
            
        }
    } withProgressCallback:^(float progress) {
        NSLog(@"current get %f", progress);
        if (1.0 == progress) {
            //            [ProgressHUD showSuccess:@"上传成功"];
        }
    }];
    return imageName;
}

//上传缩小的头像图片
- (NSString *)updateMiniAvatarImageToBucket: (UIImage *)image withName: (NSString *)imageName {
    NSString *miniImageName = [[NSString alloc] initWithFormat:@"%@_mini.png",imageName];
    UIImage *miniImage = [SRImageManager getSubImage:image withRect:CGRectMake(0, 0, 90, 90)];
    NSData *update = UIImageJPEGRepresentation(miniImage, 0.2);
    
    OSSBucket *bucket = [[OSSBucket alloc] initWithBucket:@"superrabbit"];
    OSSData *imageData = [[OSSData alloc] initWithBucket:bucket withKey:miniImageName];
    
    [imageData setData:update withType:@"image"];
    [imageData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
        if (isSuccess) {
            [self.delegate imageUpladDone];
            [ProgressHUD showSuccess:@"上传成功"];
        } else {
            [self.delegate imageUpladError];
            NSLog(@"errorInfo_testDataUploadWithProgress:%@", [error userInfo]);
            
        }
    } withProgressCallback:^(float progress) {
        NSLog(@"current get %f", progress);
    }];
    
    
    return nil;
}

- (NSString *)updateImageToBucket: (UIImage *)image {
    NSString *imageName = [[NSUUID UUID] UUIDString];
    
    [ProgressHUD show:@"正在上传"];
    OSSBucket *bucket = [[OSSBucket alloc] initWithBucket:@"superrabbit"];
    OSSData *imageData = [[OSSData alloc] initWithBucket:bucket withKey:[NSString stringWithFormat:@"%@.png", imageName]];
    image = [SRImageManager scaleImage:image toScale:image.size.height>image.size.width?1920/image.size.height:1920/image.size.width];
    
    NSData *update = UIImageJPEGRepresentation(image, 0.2);
    [imageData setData:update withType:@"image"];
    
    [imageData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
        if (isSuccess) {
            NSLog(@"done");
            [self updateMiniImageToBucket:image withName:imageName];
        } else {
            NSLog(@"errorInfo_testDataUploadWithProgress:%@", [error userInfo]);
            
        }
    } withProgressCallback:^(float progress) {
        NSLog(@"current get %f", progress);
        if (1.0 == progress) {
//            [ProgressHUD showSuccess:@"上传成功"];
        }
    }];
    return imageName;
}

- (NSString *)updateGroupCoverToBucket: (UIImage *)image {
    NSString *imageName = [[NSUUID UUID] UUIDString];
    
    [ProgressHUD show:@"正在上传"];
    OSSBucket *bucket = [[OSSBucket alloc] initWithBucket:@"superrabbit"];
    OSSData *imageData = [[OSSData alloc] initWithBucket:bucket withKey:[NSString stringWithFormat:@"%@.png", imageName]];
    image = [SRImageManager scaleImage:image toScale:image.size.height>image.size.width?1920/image.size.height:1920/image.size.width];
    image = [SRImageManager getSubImage:image withRect:CGRectMake(0, 0, 300, 300)];
    NSData *update = UIImageJPEGRepresentation(image, 0.7);
    [imageData setData:update withType:@"image"];
    
    [imageData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
        if (isSuccess) {
//            NSLog(@"done");
//            [self updateMiniImageToBucket:image withName:imageName];
            [self.delegate imageUpladDone];
            [ProgressHUD showSuccess:@"上传成功"];
        } else {
            [self.delegate imageUpladError];
            NSLog(@"errorInfo_testDataUploadWithProgress:%@", [error userInfo]);
            
        }
    } withProgressCallback:^(float progress) {
        NSLog(@"current get %f", progress);
        if (1.0 == progress) {
            //            [ProgressHUD showSuccess:@"上传成功"];
        }
    }];
    return imageName;
}

- (NSString *)updateMiniImageToBucket: (UIImage *)image withName: (NSString *)imageName {
    
    
    NSString *miniImageName = [[NSString alloc] initWithFormat:@"%@_mini.png",imageName];
    UIImage *miniImage = [SRImageManager getSubImage:image withRect:CGRectMake(0, 0, 300, 300)];

    NSData *update = UIImageJPEGRepresentation(miniImage, 0.2);
    
    OSSBucket *bucket = [[OSSBucket alloc] initWithBucket:@"superrabbit"];
    OSSData *imageData = [[OSSData alloc] initWithBucket:bucket withKey:miniImageName];
    
    [imageData setData:update withType:@"image"];
    [imageData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
        if (isSuccess) {
            [self.delegate imageUpladDone];
            [ProgressHUD showSuccess:@"上传成功"];
        } else {
            [self.delegate imageUpladError];
            NSLog(@"errorInfo_testDataUploadWithProgress:%@", [error userInfo]);
            
        }
    } withProgressCallback:^(float progress) {
        NSLog(@"current get %f", progress);
    }];

    return nil;
}

- (void)delImage:(NSString *)imageName {
    NSString *miniImageName = [[NSString alloc] initWithFormat:@"%@_mini.png",imageName];
    
    OSSBucket *bucket = [[OSSBucket alloc] initWithBucket:@"superrabbit"];
    OSSData *imageData = [[OSSData alloc] initWithBucket:bucket withKey:[NSString stringWithFormat:@"%@.png", imageName]];
    
    OSSData *miniImageData = [[OSSData alloc] initWithBucket:bucket withKey:miniImageName];
    
    [imageData deleteWithDeleteCallback:^(BOOL isSuccess, NSError *error) {
        if (isSuccess) {
//            NSLog(@"there is no error");
            [miniImageData deleteWithDeleteCallback:^(BOOL isSuccess, NSError *error) {
                if (isSuccess) {
                    [self.delegate imageDelDone];
                } else {
                    NSLog(@"errorInfo_testDataDeleteInBackGround:%@", [error userInfo]);
                    [self.delegate imageDelError];
                }
            }];
        } else {
            NSLog(@"errorInfo_testDataDeleteInBackGround:%@", [error userInfo]);
            [self.delegate imageDelError];
        }
    }];
}

- (BOOL)updateImageToTXY: (UIImage *)image {
    __block NSString *fieldID;
    
    //JEPG格式
    NSData *imagedata = UIImageJPEGRepresentation(image, 0.8);
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:@"temp.jepg"];
    [imagedata writeToFile:savedImagePath atomically:YES];
    
    //    NSString *savedImagePath = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    TXYPhotoUploadTask *photoTask = [[TXYPhotoUploadTask alloc] initWithPath:savedImagePath];
    
    TXYUploadManager *uploadManager = [[TXYUploadManager alloc] initWithPersistenceId:@"supperRabbit"];
    [uploadManager upload:photoTask
                     sign:nil
                 complete:^(TXYTaskRsp *resp, NSDictionary *context)
     {
         TXYPhotoUploadTaskRsp *photoResp = (TXYPhotoUploadTaskRsp *)resp;
         NSLog(@"upload return=%d",photoResp.retCode);
         NSLog(@"field ID = %@", photoResp.photoURL);
         fieldID = photoResp.photoFileId;
         [self.delegate imageUploadDoneWithFieldID:photoResp.photoFileId];
     } progress:^(int64_t totalSize, int64_t sendSize, NSDictionary *context) { }
               stateChange:^(TXYUploadTaskState state, NSDictionary *context) {
                   switch (state) {
                       case TXYUploadTaskStateWait:
                           //任务等待中
                           break;
                       case TXYUploadTaskStateConnecting:
                           //任务连接中
                           break;
                       case TXYUploadTaskStateFail:
                           //任务失败
                           break;
                       case TXYUploadTaskStateSuccess:
                           //任务成功
                           break;
                       default:
                           break;
                   }
               }
     ];
    
    return TRUE;
}

+ (NSString *)originalImageFromTXYFieldID: (NSString *)fieldID {
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://201139.image.myqcloud.com/201139/0/%@/original", fieldID];
    return urlString; 
}


@end

