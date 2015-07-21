//
//  SRImageManager.m
//  Agree
//
//  Created by G4ddle on 15/1/22.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "SRImageManager.h"
#import "TXYUploadManager.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"

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



- (BOOL)updateImageToTXY: (UIImage *)image {
//    __block NSString *fieldID;
    
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
//         NSLog(@"upload return=%d",photoResp.retCode);
//         NSLog(@"field ID = %@", photoResp.photoURL);
         [self.delegate imageUploadDoneWithFieldID:photoResp.photoFileId];
     } progress:^(int64_t totalSize, int64_t sendSize, NSDictionary *context) {

         [self.delegate imageUploading:(float)sendSize/(float)totalSize];

//         float stfloat = sendSize/totalSize;
////         [SVProgressHUD showProgress:stfloat status:@"上传中" maskType:SVProgressHUDMaskTypeBlack];
//         [SVProgressHUD showProgress:stfloat maskType:SVProgressHUDMaskTypeGradient];

     }
               stateChange:^(TXYUploadTaskState state, NSDictionary *context) {
                   switch (state) {
                       case TXYUploadTaskStateWait:
                           //任务等待中

                           break;
                       case TXYUploadTaskStateConnecting:
                           //任务连接中
                           break;
                       case TXYUploadTaskStateFail: {
                           //任务失败
                           [self.delegate imageUpladError];
                       }
                           break;
                       case TXYUploadTaskStateSuccess: {
                           //任务成功
                           
                       }
                           break;
                       default:
                           break;
                   }
               }
     ];

    return TRUE;
}



//原图
+ (NSURL *)originalImageFromTXYFieldID: (NSString *)fieldID {
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://201139.image.myqcloud.com/201139/0/%@/original", fieldID];
    return [NSURL URLWithString:urlString];
}

//小组封面
+ (NSURL *)groupFrontCoverImageFromTXYFieldID: (NSString *)fieldID {
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://201139.image.myqcloud.com/201139/0/%@/groupFrontCover", fieldID];
    return [NSURL URLWithString:urlString];
}

//相册缩略图
+ (NSURL *)albumThumbnailImageFromTXYFieldID: (NSString *)fieldID {
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://201139.image.myqcloud.com/201139/0/%@/albumThumbnail", fieldID];
    return [NSURL URLWithString:urlString];
}

//头像
+ (NSURL *)avatarImageFromTXYFieldID: (NSString *)fieldID {
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://201139.image.myqcloud.com/201139/0/%@/avatar", fieldID];
    return [NSURL URLWithString:urlString];
}

//头像小图
+ (NSURL *)miniAvatarImageFromTXYFieldID: (NSString *)fieldID {
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://201139.image.myqcloud.com/201139/0/%@/miniAvatar", fieldID];
    return [NSURL URLWithString:urlString];
}

//原图
+ (NSURL *)originalImageFromOSS: (NSString *)imagePath {
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://picstyle.beagree.com/%@",imagePath];
    return [NSURL URLWithString:urlString];
}

//头像
+ (NSURL *)avatarImageFromOSS: (NSString *)imagePath {
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://picstyle.beagree.com/%@@!%@",imagePath, kAvatar];
    return [NSURL URLWithString:urlString];
}

//头像小图
+ (NSURL *)miniAvatarImageFromOSS: (NSString *)imagePath {
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://picstyle.beagree.com/%@@!%@",imagePath, kMiniAvatar];
    return [NSURL URLWithString:urlString];
}

//相册缩略图
+ (NSURL *)albumThumbnailImageFromOSS: (NSString *)imagePath {
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://picstyle.beagree.com/%@@!%@",imagePath, kAlbumThumbnail];
    return [NSURL URLWithString:urlString];
}

//小组封面图
+ (NSURL *)groupFrontCoverImageImageFromOSS: (NSString *)imagePath {
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://picstyle.beagree.com/%@@!%@",imagePath, kGroupFrontCover];
    return [NSURL URLWithString:urlString];
}



+ (OSSData *)initImageOSSData: (UIImage *)uploadImage withKey: (NSString *)keyString {
    OSSBucket *myBucket = [self initBucket];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    OSSData *uploadData = [delegate.ossService getOSSDataWithBucket:myBucket key:keyString];

    [uploadData enableUploadCheckMd5sum:YES]; // 开启上传md5校验
    [uploadData setData:UIImageJPEGRepresentation(uploadImage, 0.8) withType:@"jpg"];
    return uploadData;
}

//初始化OSSBucket
+ (OSSBucket *)initBucket {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    OSSBucket *ossBucket = [delegate.ossService getBucket:@"agree"];
    
    [ossBucket setAcl:PRIVATE]; // 指明该Bucket的访问权限
    [ossBucket setOssHostId:@"image.beagree.com"]; // 指明该Bucket所在数据中心的域名或已经绑定Bucket的CNAME域名
    [ossBucket setCdnAccelerateHostId:@"imagecdn.beagree.com"]; // 设置指向CDN加速域名的CNAME域名

//    [ossBucket setOssHostId:@"picstyle.beagree.com"]; // 指明该Bucket所在数据中心的域名或已经绑定Bucket的CNAME域名
//    [ossBucket setCdnAccelerateHostId:@"picstyle.beagree.com.w.kunlunAr.com"]; // 设置指向CDN加速域名的CNAME域名
    return ossBucket;
}



@end

