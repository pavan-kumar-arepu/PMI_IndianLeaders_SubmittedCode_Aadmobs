//
//  PrimeMinister.h
//  PMI
//
//  Created by pavan kumar on 29/06/15.
//  Copyright © 2015 pavan kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrimeMinister : NSObject

@property (strong, nonatomic) NSString *pmName;
@property (strong, nonatomic) NSString *pmDOB;
@property (strong, nonatomic) NSString *pmDOD;
@property (strong, nonatomic) NSString *pmPoliticalParty;
@property (strong, nonatomic) NSString *pmAward;
@property (strong, nonatomic) NSString *pmImages;
@property (strong, nonatomic) NSString *pmSignature;
@property (strong, nonatomic) NSString *pmDescription;
@property (strong, nonatomic) NSString *pmSideImage;
@property (strong, nonatomic) NSString *pmWorkStart;
@property (strong, nonatomic) NSString *pmWorkEnd;


-(void)initialize;

@end
