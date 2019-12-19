//
//  PrimeMinisterCollectionCellCollectionViewCell.h
//  PMI
//
//  Created by pavan kumar on 29/06/15.
//  Copyright © 2015 pavan kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *pmRectBGImage;
@property (strong, nonatomic) IBOutlet UIImageView *pmCollectImage;
@property (strong, nonatomic) IBOutlet UILabel *pmCollectName;
@property (strong, nonatomic) IBOutlet UILabel *pmCollectWorkExp;
@property (strong, nonatomic) IBOutlet UIImageView *pmFlag;
@property (strong, nonatomic) IBOutlet UILabel *pmNumber;
@property (strong, nonatomic) IBOutlet UIImageView *pmEmblum;

@end
