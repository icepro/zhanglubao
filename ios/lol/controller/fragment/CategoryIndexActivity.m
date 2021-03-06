//
//  HomeIndexActivity.m
//  lol
//
//  Created by Rocks on 15/8/24.
//  Copyright (c) 2015年 Zhanglubao.com. All rights reserved.
//

#import "CategoryIndexActivity.h"
#import "MJExtension.h"
#import <SDWebImage/UIImageView+WebCache.h>


#import "UIColor+Util.h"

#import "VideoModel.h"
#import "UserModel.h"
#import "AlbumModel.h"
#import "SlideModel.h"
#import "CategoryIndexResult.h"
#import "VideoCell.h"
#import "HeroCell.h"
#import "UserCell.h"
#import "AlbumCell.h"
#import "BannerCell.h"
#import "HomeIndexResult.h"
#import "TitleView.h"
#import "CSCollectionViewFlowLayout.h"



static NSString * const kHeroCellID = @"HeroCell";
static NSString * const kUserCellID = @"UserCell";
static NSString * const kVideoCellID = @"VideoCell";

static NSString * const kAlbumCellID = @"AlbumCell";
static NSString * const kTitleViewID = @"TitleView";

@interface CategoryIndexActivity ()
@property (nonatomic, strong) NSMutableArray *newvideos;
@property (nonatomic, strong) CategoryIndexResult *homeIndexResult;
@property (nonatomic,copy) NSString                 *url;
@property (nonatomic,assign) int                 page;
@end

@implementation CategoryIndexActivity


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark



- (instancetype)initWithTitleUrl:(NSString *)title url:(NSString *)url
{
    self= [super init];
    
    if (self) {
        self.controllerTitle = title;
        self.url= url;
        CSCollectionViewFlowLayout *flowLayout = [CSCollectionViewFlowLayout new];
        flowLayout.minimumInteritemSpacing=0;
        flowLayout.minimumLineSpacing=2;
        self = [super initWithCollectionViewLayout:flowLayout];
        self.hidesBottomBarWhenPushed = NO;
        self.collectionView.showsVerticalScrollIndicator=NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _page=-1;
    [self.collectionView registerClass:[VideoCell class] forCellWithReuseIdentifier:kVideoCellID];
    [self.collectionView registerClass:[UserCell class] forCellWithReuseIdentifier:kUserCellID];
    [self.collectionView registerClass:[HeroCell class] forCellWithReuseIdentifier:kHeroCellID];
    [self.collectionView registerClass:[AlbumCell class] forCellWithReuseIdentifier:kAlbumCellID];
    [self.collectionView registerClass:[TitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kTitleViewID];
    
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.footer.hidden=YES;
    self.collectionView.header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header;
    });
   
    // 设置了底部inset
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 36, 0);

    [self.collectionView.header beginRefreshing];
}




#pragma mark <UICollectionViewDataSource>


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
 
    if (_homeIndexResult) {
        return 7;
    }
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    if (_homeIndexResult) {
        
        switch (section) {
            case 0:
                return [_homeIndexResult.heros count];
                break;
            case 1:
                return [_homeIndexResult.comms count];
                break;
            case 2:
                return [_homeIndexResult.masters count];
                break;
            case 3:
                return [_homeIndexResult.pros count];
                break;
            case 4:
                return [_homeIndexResult.teams count];
                break;
            case 5:
                return [_homeIndexResult.matches count];
                break;
            case 6:
                return [_homeIndexResult.albums count];
                break;
                
            default:
                return 0;
                break;
        }
    }else{
        return 0;
    }
}
//返回Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (indexPath.section==0) {
        HeroCell   *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHeroCellID forIndexPath:indexPath];
        HeroModel *hero=[_homeIndexResult.heros objectAtIndex:indexPath.row];
        [cell setHero:hero];
        return cell;
    }
    
    if (indexPath.section==1) {
        UserCell   *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUserCellID forIndexPath:indexPath];
        UserModel *user=[_homeIndexResult.comms objectAtIndex:indexPath.row];
        [cell setUser:user];
        return cell;
    }
    
    if (indexPath.section==2) {
        UserCell   *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUserCellID forIndexPath:indexPath];
        UserModel *user=[_homeIndexResult.masters objectAtIndex:indexPath.row];
        [cell setUser:user];
        return cell;
    }
    if (indexPath.section==3) {
        UserCell   *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUserCellID forIndexPath:indexPath];
        UserModel *user=[_homeIndexResult.pros objectAtIndex:indexPath.row];
        [cell setUser:user];
        return cell;
    }
    if (indexPath.section==4) {
        UserCell   *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUserCellID forIndexPath:indexPath];
        UserModel *user=[_homeIndexResult.teams objectAtIndex:indexPath.row];
        [cell setUser:user];
        return cell;
    }
    
    
    if (indexPath.section==5) {
        UserCell   *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUserCellID forIndexPath:indexPath];
        UserModel *user=[_homeIndexResult.matches objectAtIndex:indexPath.row];
        [cell setUser:user];
        return cell;
    }
    
    if (indexPath.section==6) {
        AlbumCell   *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAlbumCellID forIndexPath:indexPath];
        AlbumModel *album=[_homeIndexResult.albums objectAtIndex:indexPath.row];
        [cell setAlbum:album];
        return cell;
    }
     
    
    return nil;
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    return UIEdgeInsetsMake(6, 6, 6, 6);
    
}

//返回item的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section!=6) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        return CGSizeMake(screenWidth/4.0f-8.0f, 114);
    }
    if(indexPath.section==6)
    {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        return CGSizeMake(screenWidth/3.0f-8.0f, (screenWidth/3.0f)*1.508);
    }
    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenWidth/4.0f-8.0f, 114);
}

//返回HeaderView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
     return CGSizeMake(screenWidth, 40);
}

//返回每个分区的headerView
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        TitleView *titleView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kTitleViewID forIndexPath:indexPath];
        NSString *title;
        NSString *moreTitle;
      
        
        switch (indexPath.section) {
            case 0:
                title=NSLocalizedString(@"content_category_index_hero", nil);
                moreTitle=NSLocalizedString(@"content_category_index_hero_more", nil);
                break;
            case 1:
                title=NSLocalizedString(@"content_category_index_comm_user", nil);
                moreTitle=NSLocalizedString(@"content_category_index_comm_user_more", nil);
                break;
            case 2:
                title=NSLocalizedString(@"content_category_index_master_user", nil);
                moreTitle=NSLocalizedString(@"content_category_index_master_user_more", nil);
                break;
            case 3:
                title=NSLocalizedString(@"content_category_index_pro_user", nil);
                moreTitle=NSLocalizedString(@"content_category_index_pro_user_more", nil);
                break;
            case 4:
                title=NSLocalizedString(@"content_category_index_match_user", nil);
                moreTitle=NSLocalizedString(@"content_category_index_match_user_more", nil);
                break;
            case 5:
                title=NSLocalizedString(@"content_category_index_match_user", nil);
                moreTitle=NSLocalizedString(@"content_category_index_match_user_more", nil);
                break;
            case 6:
                title=NSLocalizedString(@"content_category_index_team_user", nil);
                moreTitle=NSLocalizedString(@"content_category_index_team_user_more", nil);
                break;
         
            default:
                break;
        }
        [titleView setTitleText:title];
        [titleView setMoreText:moreTitle];
        return titleView;
    }
    return nil;
    
}




#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 更新数据

- (void)refresh
{
    [_newvideos removeAllObjects];
    _page=-1;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:_url parameters:@{} success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        _homeIndexResult=[CategoryIndexResult objectWithKeyValues:responseObject];
        [self.collectionView.header endRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        NSLog(@"%@", [NSThread currentThread]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.collectionView.header endRefreshing];
    }];
}




@end

