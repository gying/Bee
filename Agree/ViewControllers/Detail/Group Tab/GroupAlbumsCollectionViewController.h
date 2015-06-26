//
//  GroupAlbumsCollectionViewController.h
//  Agree
//
//  Created by G4ddle on 15/2/2.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupDetailViewController.h"

#import "TXYDownloader.h"

@interface GroupAlbumsCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *albumsCollectionView;
@property (nonatomic, strong)GroupDetailViewController *rootController;
@property (nonatomic, strong)NSMutableArray *photoAry;
@property (nonatomic, strong)Model_Group *group;

@property BOOL albumsLoadingDone;

//- (void)loadImageData;
- (void)pressedTheUploadImageButton;

-(void)loadPhotoData;

@end
