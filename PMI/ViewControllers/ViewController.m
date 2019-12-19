//
//  ViewController.m
//  PMI
//
//  Created by pavan kumar on 28/06/15.
//  Copyright (c) 2015 pavan kumar. All rights reserved.
//

#import "ViewController.h"
#import "PrimeMinister.h"
#import "PMCollectionViewCell.h"
#import "ConstantFile.h"

@import GoogleMobileAds;

@interface ViewController ()<GADBannerViewDelegate>
{
    NSMutableDictionary *completePMDict;
    NSMutableArray *primeMinistersArray;
    NSMutableArray *primeMinisterObjects;
    NSMutableArray *primeMinisterKeys;
    NSMutableArray *rectBGImageSets;
}


//Header View -  Navigation bar space variable
@property (weak,nonatomic) IBOutlet UIView *headerView;
@property (strong,nonatomic) IBOutlet UIView *collectionViewBGView;
@property (strong,nonatomic) IBOutlet UIScrollView *ilscrollView;
@property (weak,nonatomic) IBOutlet UIImageView *headerImage;
@property (weak,nonatomic) IBOutlet UILabel *leaderDisignation;

//Collection View bar space variable
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *bgCollectionView;


//Details View Details
@property (nonatomic,strong)  UIImageView *detailsPMImageView;
@property (nonatomic,strong)  UIImageView *detailsPMBGImageView;
@property (nonatomic,strong)  UILabel *detailsPMName;
@property (nonatomic,weak)  UIAlertController *pmAlertViewController;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic)  UIButton *leftArrow;
@property (strong, nonatomic)  UIButton *rightArrow;

@property(strong,nonatomic) UISwipeGestureRecognizer *swipeRight,*swipeLeft;

@property (nonatomic,strong)  UILabel *descriptionLabel;
@property (nonatomic,strong)  UITextView *detailsPMDescription;

@property (nonatomic,strong)  UILabel *politicalParyLabel;
@property (nonatomic,strong)  UILabel *politicalParyLabelValue;

@property (nonatomic,strong)  UILabel *birthLabel;
@property (nonatomic,strong)  UILabel *birthLabelValue;

@property (nonatomic,strong)  UILabel *deathLabel;
@property (nonatomic,strong)  UILabel *deathLabelValue;

@property (nonatomic,strong)  UILabel *awardLabel;
@property (nonatomic,strong)  UILabel *awardLabelValue;

@property (nonatomic,strong)  UILabel *signatureLabel;
@property (nonatomic,strong)  UIImageView *signatureImage;

@property(nonatomic,strong) IBOutlet UIView *bannerBGView;
@property(nonatomic, strong) GADBannerView *bannerView;


@property  NSInteger currentViewCellNumber;
@property BOOL isBackButtonClicked;

@end

int discriptionDiff = 0;
@implementation ViewController

#pragma mark - View Controller Delegate methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //HeaderView Setup
    [self headerViewSetup];
    [self collectionViewSetup];
    
    self.currentViewCellNumber = 1;
    _isBackButtonClicked = NO;
    _backButton.hidden = YES;
    
    //Setting Banner to view
    self.bannerView = [[GADBannerView alloc]
                       initWithAdSize:kGADAdSizeSmartBannerPortrait];
    [self.bannerBGView addSubview:self.bannerView];
    self.bannerView.adUnitID = @"ca-app-pub-4884000136984470/3575328603";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    self.bannerView.delegate = self;
    
   /*
    //Testing Banner in simulator
     self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/6300978111";
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID,                       // All simulators
                             @"806BA04AEC7E4EDC86054EE7D40BB84A"];
    
    */
    
    primeMinistersArray = [[NSMutableArray alloc]init];
    primeMinisterObjects = [[NSMutableArray alloc]init];
    primeMinisterKeys = [[NSMutableArray alloc]init];
    
    
    //Setting the cell colored radomly
    
    rectBGImageSets = [[NSMutableArray alloc]initWithObjects:@"007524",@"ff7e00",@"33c0cf",@"18a68a",@"f59d00",@"33495f",@"e94b35",@"007524",@"33495f",@"ff7e00",@"f59d00",@"33c0cf",@"007524",@"33495f",@"33c0cf",@"18a68a",@"f59d00",@"e94b35",@"f59d00",@"33495f",@"e94b35", nil];

    
    
    NSString *myListPath = [[NSBundle mainBundle] pathForResource:@"DataModelPlist" ofType:@"plist"];
    completePMDict = [[NSMutableDictionary alloc]initWithContentsOfFile:myListPath];
    
    self.leaderDisignation.text = @"Prime Ministers Of India";
    
    self.leaderDisignation.textAlignment = NSTextAlignmentCenter;

    primeMinistersArray = [completePMDict objectForKey:@"PrimeMinisters"];
    
    
    //creating Prime Minister Keys
    
    for (int i = 0; i < [primeMinistersArray count]; i++)
    {
        NSString *pmAllKeys = [NSString stringWithFormat:@"PM%d",i+1];
        [primeMinisterKeys addObject:pmAllKeys];
    }
    
    
    for (int i = 0; i < [primeMinistersArray count]; i++)
    {
        
        PrimeMinister* pmObject =  [PrimeMinister alloc];
        
        NSMutableArray *pmDetails = [primeMinistersArray valueForKey:[primeMinisterKeys objectAtIndex:i]];
    
        
        pmObject.pmName = [pmDetails objectAtIndex:0];
        pmObject.pmWorkStart = [pmDetails objectAtIndex:8];
        pmObject.pmWorkEnd = [pmDetails objectAtIndex:9];
        pmObject.pmAward = [pmDetails objectAtIndex:4];
        pmObject.pmDescription = [pmDetails objectAtIndex:1];
        pmObject.pmImages = [pmDetails objectAtIndex:5];
        pmObject.pmDOB = [pmDetails objectAtIndex:2];
        pmObject.pmDOD = [pmDetails objectAtIndex:3];
        pmObject.pmSignature = [pmDetails objectAtIndex:7];
        pmObject.pmPoliticalParty = [pmDetails objectAtIndex:6];
        [primeMinisterObjects addObject:pmObject];
                
        //Gesture Recogniser initialization
        
        _swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
        _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        
        
        _swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
        _swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;

        [self.ilscrollView addGestureRecognizer:_swipeLeft];
        
        [self.ilscrollView addGestureRecognizer:_swipeRight];
    };

    self.collectionView.layer.cornerRadius =5.0f;
    self.bgCollectionView.layer.cornerRadius =5.0f;
    self.collectionViewBGView.layer.cornerRadius =5.0f;


    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*******************************************************************************************************************************
 Method Name          : shiftLabelFrameWhenNoDeath
 Number of Parameters : nil
 Return Value         : void
 Description          : Called when there is no death value
 ********************************************************************************************************************************/

-(void)shiftLabelFrameWhenNoDeath
{
    self.detailsPMName.numberOfLines = 2;
    _awardLabelValue.numberOfLines = 0;
    _birthLabelValue.numberOfLines = 0;
    _deathLabelValue.numberOfLines = 0;
    _politicalParyLabelValue.numberOfLines = 0;
    _detailsPMDescription.scrollEnabled = NO;
    _detailsPMDescription.editable = NO;
    
    if (_currentViewCellNumber >= 0  || _currentViewCellNumber <= [primeMinisterObjects count] -1)
    {
        CATransition *animation = [CATransition animation];
        [animation setDelegate:self];
        [animation setDuration:1.0f];
        [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
        [animation setType:@"rippleEffect" ];
        [self.ilscrollView.layer addAnimation:animation forKey:NULL];
        [self.detailsPMImageView.layer addAnimation:animation forKey:NULL];
        [self.detailsPMName.layer addAnimation:animation forKey:NULL];

    }
    

    CGSize size=[self.detailsPMDescription sizeThatFits:CGSizeMake(self.collectionView.frame.size.width - DiscriptionsRightPadding, CGFLOAT_MAX)];
    
    self.detailsPMDescription.frame = CGRectMake(self.collectionView.frame.origin.x + DiscriptionsLeftPadding - 5,_descriptionLabel.frame.origin.y + _descriptionLabel.frame.size.height + Description_YCoordinate , self.collectionView.frame.size.width - DiscriptionsRightPadding, size.height);

    
    //For Political Party Label
    _politicalParyLabel.frame = CGRectMake(self.collectionView.frame.origin.x + 10,self.detailsPMDescription.frame.origin.y +  self.detailsPMDescription.frame.size.height + Description_YCoordinate ,self.collectionView.frame.size.width - 20,20);

    CGRect newPartyLblFrame = [_politicalParyLabelValue.text boundingRectWithSize:CGSizeMake(self.collectionView.frame.size.width, MAXFLOAT)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{
                                                                            NSFontAttributeName : _politicalParyLabel.font
                                                                            }
                                                                  context:nil];

    
    //    //For Political Party Value
    _politicalParyLabelValue.frame = CGRectMake(self.collectionView.frame.origin.x + DiscriptionsLeftPadding, _politicalParyLabel.frame.origin.y +  _politicalParyLabel.frame.size.height + Description_YCoordinate  , self.collectionView.frame.size.width - DiscriptionsRightPadding,newPartyLblFrame.size.height);
    
    //For Birth Label
    _birthLabel.frame = CGRectMake(self.collectionView.frame.origin.x + 10, _politicalParyLabelValue.frame.origin.y + _politicalParyLabelValue.frame.size.height + Description_YCoordinate ,self.collectionView.frame.size.width - 20,20);
    [self getCustomFontStyleForALLDetailHeadingValues:_birthLabelValue];

    CGRect newBirthLblFrame = [_birthLabelValue.text boundingRectWithSize:CGSizeMake(self.collectionView.frame.size.width - DiscriptionsRightPadding, MAXFLOAT)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{
                                                                            NSFontAttributeName : _birthLabelValue.font
                                                                            }
                                                                  context:nil];
    


    //For Birth Value
    _birthLabelValue.frame = CGRectMake(self.collectionView.frame.origin.x + DiscriptionsLeftPadding, _birthLabel.frame.origin.y + _birthLabel.frame.size.height +  Description_YCoordinate ,self.collectionView.frame.size.width - DiscriptionsRightPadding,newBirthLblFrame.size.height);
    [self getCustomFontStyleForALLDetailHeadingValues:_awardLabelValue];
    [self getCustomFontStyleForALLDetailHeadingValues:_deathLabelValue];

    CGRect newAwardLblFrame = [_awardLabelValue.text boundingRectWithSize:CGSizeMake(self.collectionView.frame.size.width - DiscriptionsRightPadding, MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{
                                             NSFontAttributeName : _awardLabelValue.font
                                             }
                                   context:nil];
    CGRect newDeathLblFrame = [_deathLabelValue.text boundingRectWithSize:CGSizeMake(self.collectionView.frame.size.width - DiscriptionsRightPadding, MAXFLOAT)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{
                                                                            NSFontAttributeName : _deathLabelValue.font
                                                                            }
                                                                  context:nil];
    

    
    if ([_deathLabelValue.text  isEqual: @""])
    {
        NSLog(@"Prime Minister is still Alive");
        
        
        _deathLabel.hidden = YES;
        //For Award Label
        _awardLabel.frame = CGRectMake(self.collectionView.frame.origin.x + 10,_birthLabelValue.frame.origin.y + _birthLabelValue.frame.size.height + Description_YCoordinate,self.collectionView.frame.size.width - 20,20);
        
        
        //    //For Award Value
        _awardLabelValue.frame = CGRectMake(self.collectionView.frame.origin.x + DiscriptionsLeftPadding,_awardLabel.frame.origin.y + _awardLabel.frame.size.height + Description_YCoordinate,self.collectionView.frame.size.width - DiscriptionsRightPadding,newAwardLblFrame.size.height);
        
           }
    else
    {
        _deathLabel.hidden = NO;

        //For Death Label
        _deathLabel.frame = CGRectMake(self.collectionView.frame.origin.x + 10,_birthLabelValue.frame.origin.y + _birthLabelValue.frame.size.height +Description_YCoordinate,self.collectionView.frame.size.width - 20,20);
        
        
        //    //For Death Value
        _deathLabelValue.frame = CGRectMake(self.collectionView.frame.origin.x + DiscriptionsLeftPadding,_deathLabel.frame.origin.y + _deathLabel.frame.size.height +Description_YCoordinate,self.collectionView.frame.size.width - DiscriptionsRightPadding,newDeathLblFrame.size.height);
        
        
        //For Award Label
        _awardLabel.frame = CGRectMake(self.collectionView.frame.origin.x + 10,_deathLabelValue.frame.origin.y + _deathLabelValue.frame.size.height + Description_YCoordinate,self.collectionView.frame.size.width - 20,20);
        
        
        //    //For Award Value
        _awardLabelValue.frame = CGRectMake(self.collectionView.frame.origin.x + DiscriptionsLeftPadding,_awardLabel.frame.origin.y   + _awardLabel.frame.size.height + Description_YCoordinate,self.collectionView.frame.size.width - DiscriptionsRightPadding,newAwardLblFrame.size.height);
        
    }
    //For PMSign Label
    _signatureLabel.frame = CGRectMake(self.collectionView.frame.origin.x + 10,_awardLabelValue.frame.origin.y + _awardLabelValue.frame.size.height + Description_YCoordinate,self.collectionView.frame.size.width - 20,20);
    
    //    //For PMSign Image
    _signatureImage.frame =  CGRectMake(self.collectionView.frame.origin.x + DiscriptionsLeftPadding,_signatureLabel.frame.origin.y + _signatureLabel.frame.size.height + Description_YCoordinate,200,80);
    if (_signatureImage.image == Nil){
        self.ilscrollView.contentSize = CGSizeMake(self.collectionView.frame.size.width, _awardLabelValue.frame.origin.y + _awardLabelValue.frame.size.height + 20 + (IS_IPAD?80:40));
    }
    else{
        self.ilscrollView.contentSize = CGSizeMake(self.collectionView.frame.size.width, _signatureImage.frame.origin.y + _signatureImage.frame.size.height + 20 + (IS_IPAD?80:40));
  
    }
    
}

#pragma mark - Gesture Recognisers

/*******************************************************************************************************************************
 Method Name          : slideToRightWithGestureRecognizer
 Number of Parameters : nil
 Return Value         : void
 Description          : Called when left swipe detected
 ********************************************************************************************************************************/
-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer
{
    self.ilscrollView.contentOffset = CGPointMake(0,0);
    
    _currentViewCellNumber--;

    if (_currentViewCellNumber > -1)
    {
        if (_currentViewCellNumber == 0)
        {
            _leftArrow.enabled = NO;
            _leftArrow.hidden = YES;

        }
        if (_currentViewCellNumber == [primeMinisterObjects count] -1) {
            _rightArrow.enabled = NO;
            _rightArrow.hidden = YES;

        }
        else{
        _rightArrow.enabled = YES;
            _rightArrow.hidden = NO;

        }
        
        _detailsPMDescription.text = [[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmDescription"];
        
        _birthLabelValue.text = [NSString stringWithFormat:@"%@",[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmDOB"]];
        
        _politicalParyLabelValue.text = [NSString stringWithFormat:@"%@",[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmPoliticalParty"]];

        _deathLabelValue.text = [NSString stringWithFormat:@"%@",[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmDOD"]];
        
        _awardLabelValue.text = [NSString stringWithFormat:@"%@",[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmAward"]];
        
        _signatureImage.image = [UIImage imageNamed:[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmSignature"]];
        
        _detailsPMImageView.image = [UIImage imageNamed:[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmImages"]];
       
        _detailsPMName.text = [NSString stringWithFormat:@"%@",[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmName"]];
        [self shiftLabelFrameWhenNoDeath];

    }else
    {
        _currentViewCellNumber = 0;
        _leftArrow.enabled = NO;
        
    }
    if (_signatureImage.image == Nil)
    {
        NSLog(@"There is no image");
        _signatureImage.hidden = YES;
        _signatureLabel.hidden = YES;
    }else
    {
        _signatureImage.hidden = NO;
        _signatureLabel.hidden = NO;
    }
    
}

/*******************************************************************************************************************************
 Method Name          : slideToLeftWithGestureRecognizer
 Number of Parameters : nil
 Return Value         : void
 Description          : Called when right swipe detected
 ********************************************************************************************************************************/
-(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer
{
    
    self.ilscrollView.contentOffset = CGPointMake(0,0);

    _currentViewCellNumber++;

    if (_currentViewCellNumber < [primeMinisterObjects count])
    {
        if (_currentViewCellNumber >= [primeMinisterObjects count] -1)
        {
            _rightArrow.enabled = NO;
            _rightArrow.hidden = YES;

        }
        _leftArrow.enabled = YES;
        _leftArrow.hidden = NO;


       
        
        _detailsPMDescription.text = [[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmDescription"];
        

        _politicalParyLabelValue.text = [NSString stringWithFormat:@"%@",[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmPoliticalParty"]];
        
        _birthLabelValue.text = [NSString stringWithFormat:@"%@",[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmDOB"]];
        
        
        _deathLabelValue.text = [NSString stringWithFormat:@"%@",[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmDOD"]];
        
        
        _awardLabelValue.text = [NSString stringWithFormat:@"%@",[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmAward"]];
        
        
         _signatureImage.image = [UIImage imageNamed:[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmSignature"]];
        
        
        _detailsPMImageView.image = [UIImage imageNamed:[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmImages"]];
        
        _detailsPMName.text = [NSString stringWithFormat:@"%@",[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmName"]];
       
        if ([_deathLabelValue.text  isEqual: @""])
        {
                    NSLog(@"Prime Minister is still Alive");
        }
        [self shiftLabelFrameWhenNoDeath];

    }else
    {
        _currentViewCellNumber = [primeMinisterObjects count] - 1;
        _rightArrow.enabled = NO;
        _rightArrow.hidden = YES;

    }

    if (_signatureImage.image == Nil)
    {
        NSLog(@"There is no image");
        _signatureImage.hidden = YES;
        _signatureLabel.hidden = YES;
    }else
    {
        _signatureImage.hidden = NO;
        _signatureLabel.hidden = NO;
    }

    
}



#pragma mark - Header and Collection Frame SetUP Methods
/*******************************************************************************************************************************
 Method Name          : headerViewSetup
 Number of Parameters : nil
 Return Value         : void
 Description          : setting the header view objects frames
 ********************************************************************************************************************************/

-(void)headerViewSetup
{
    //Header View
    _headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT);
    
    [_headerView setBackgroundColor: [self colorWithHexString:@"f8f8f8"]];
    
    _headerView.layer.opacity = 50.0f;
    
    
    //Header Image
    _headerImage.image = [UIImage imageNamed:@"Indian-Leaders"];
    
    _headerImage.frame = CGRectMake((self.view.frame.size.width/2) - (self.view.frame.size.width/2), 20, 170, 48);
    
}


/*******************************************************************************************************************************
 Method Name          : collectionViewSetup
 Number of Parameters : nil
 Return Value         : void
 Description          : setting the collection view objects frames
 ********************************************************************************************************************************/
-(void)collectionViewSetup
{
    self.bgCollectionView.frame = CGRectMake(20, 120, self.view.frame.size.width - 40, self.view.frame.size.height - 80);
    self.collectionView.frame = CGRectMake(20, 120, self.view.frame.size.width - 40, self.view.frame.size.height - 80);
}

#pragma - mark  UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //#warning Incomplete method implementation -- Return the number of items in the section
    return [primeMinisterKeys count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString * const reuseIdentifier = @"Cell";

    PMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    // Configure the cell
    
    cell.pmCollectImage.image = [UIImage imageNamed:[[primeMinisterObjects objectAtIndex:indexPath.row] valueForKey:@"pmImages"]];
    
    
    cell.pmCollectName.text = [[primeMinisterObjects objectAtIndex:indexPath.row] valueForKey:@"pmName"];

    
    [self cellImageAnimation:cell.pmRectBGImage];
    

    cell.pmRectBGImage.layer.cornerRadius = 4.0f;
    
    if (IS_IPHONE)
    {
        cell.pmCollectWorkExp.font = [UIFont fontWithName:@"Helvetica Neue" size:9];
        if (IS_STANDARD_IPHONE_6)
        {
            cell.pmCollectWorkExp.font = [UIFont fontWithName:@"Helvetica Neue" size:10];
        }
    }
    if(IS_IPAD)
    {

        cell.pmCollectWorkExp.font = [UIFont fontWithName:@"Helvetica Neue" size:10];
    }
    if (indexPath.row == primeMinisterObjects.count - 1)
    {
        NSString *workExp = [NSString stringWithFormat:@"%@",[[primeMinisterObjects objectAtIndex:indexPath.row] valueForKey:@"pmWorkStart"]];
        cell.pmCollectWorkExp.text = workExp;

    }
    else
    {
        NSString *workExp = [NSString stringWithFormat:@"%@  -  %@",[[primeMinisterObjects objectAtIndex:indexPath.row] valueForKey:@"pmWorkStart"],[[primeMinisterObjects objectAtIndex:indexPath.row] valueForKey:@"pmWorkEnd"]];
        cell.pmCollectWorkExp.text = workExp;
        
    }

    
    cell.pmRectBGImage.backgroundColor = [self colorWithHexString:[rectBGImageSets objectAtIndex:indexPath.row]];
    
    [self colorWithHexString:@"F96214"];


    
    cell.pmFlag.image = [UIImage imageNamed:@"RoundIF"];

    cell.pmNumber.text = [NSString stringWithFormat:@"%ld",(long)(indexPath.row)+1];
    
    return cell;
}


-(void)cellImageAnimation:(UIImageView *)cellImageView
{
    cellImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    cellImageView.layer.shadowOffset = CGSizeMake(0, 1);
    cellImageView.layer.shadowOpacity = 0.5;
    cellImageView.layer.shadowRadius = 1.0;
    cellImageView.clipsToBounds = NO;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    _isBackButtonClicked = NO;
    _backButton.hidden = NO;
    _currentViewCellNumber = indexPath.row;
    
    
    [self hideCollectionViewObjects];
    
    [self allocatingDetailViewObjects];
    
    [self dataLoadingIntoDetailsViewObjects];
    
    _ilscrollView.hidden = NO;
    
    [self showDetailViewFrameSetUP];

     self.leaderDisignation.hidden = YES;
    
        //To get the coordinates of Collection Cell
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect cellRect = attributes.frame;
    NSLog(@"newpointRect :%@", NSStringFromCGRect(cellRect));
    
    int imageX = attributes.frame.origin.x;
    int imageY = attributes.frame.origin.y;
    
    _detailsPMImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageX+5, imageY+1, 79, 79)];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        _detailsPMImageView.frame = CGRectMake(imageX+45, imageY+4, 79, 79);
        
    }
    else
    {
        _detailsPMImageView.frame = CGRectMake((self.detailsPMBGImageView.frame.size.width/2) - 1,self.detailsPMBGImageView.frame.size.width/2,0, 0);
        
    }
    
    
    //Exceptional-->Early Initialization
    _detailsPMImageView.image = [UIImage imageNamed:[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmImages"]];

    [_leftArrow setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    
    [_rightArrow setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    
    [_leftArrow addTarget:self action:@selector(slideToRightWithGestureRecognizer:) forControlEvents:UIControlEventTouchUpInside];
    
    [_rightArrow addTarget:self action:@selector(slideToLeftWithGestureRecognizer:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addingSubviews];
    
    [UIView
     animateWithDuration:1.0
     animations:^{
         self.detailsPMImageView.frame = CGRectMake(self.detailsPMBGImageView.frame.origin.x + 1, self.detailsPMBGImageView.frame.origin.y + 1, self.detailsPMBGImageView.frame.size.width - 2, self.detailsPMBGImageView.frame.size.height - 2);
     }];
}

#pragma mark - Allocation and Loading the objects for Details View

/*******************************************************************************************************************************
 Method Name          : dataLoadingIntoDetailsViewObjects
 Number of Parameters : nil
 Return Value         : void
 Description          : Data Loading happens in this method and this method will be called when collection view cell clicked
 ********************************************************************************************************************************/
-(void)dataLoadingIntoDetailsViewObjects
{
    _detailsPMImageView.image = [UIImage imageNamed:[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmImages"]];
    
    _detailsPMName.text = [NSString stringWithFormat:@"%@",[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmName"]];

    _detailsPMDescription.text = [[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmDescription"];
    
    //Setting Political Party Value
    _politicalParyLabelValue.text = [NSString stringWithFormat:@"%@",[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmPoliticalParty"]];
    
    //Setting Birth Value
    _birthLabelValue.text = [[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmDOB"];;
    
    //Setting Death Value
    _deathLabelValue.text = [[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmDOD"];;
    
    //Setting  Award Value
    _awardLabelValue.text = [[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmAward"];;
    
    //Setting  Signature Image
    _signatureImage.image = [UIImage imageNamed:[[primeMinisterObjects objectAtIndex:_currentViewCellNumber] valueForKey:@"pmSignature"]];
}


/*******************************************************************************************************************************
 Method Name          : allocatingDetailViewObjects
 Number of Parameters : nil
 Return Value         : void
 Description          : Allocation happens in this method and this method will be called when collection view cell clicked
 ********************************************************************************************************************************/
-(void)allocatingDetailViewObjects
{
    _detailsPMImageView = [[UIImageView alloc]init];
    _detailsPMName = [[UILabel alloc]init];
    _detailsPMName.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
    _detailsPMName.textColor = [self colorWithHexString:@"007f00"];

    _detailsPMName.textAlignment = NSTextAlignmentCenter;
    _detailsPMName.font = [UIFont boldSystemFontOfSize:18];
    
    self.detailsPMBGImageView = [[UIImageView alloc]init];

    
    self.leftArrow = [[UIButton alloc]init];
    self.rightArrow = [[UIButton alloc]init];
    
    
    _descriptionLabel = [[UILabel alloc]init];
    _detailsPMDescription = [[UITextView alloc]init];
    _detailsPMDescription.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    _detailsPMDescription.textColor = [self colorWithHexString:@"434343"];

    _detailsPMDescription.backgroundColor = [UIColor clearColor];
    _detailsPMDescription.textAlignment = NSTextAlignmentLeft;
    
    _politicalParyLabel = [[UILabel alloc]init];
    _politicalParyLabelValue = [[UILabel alloc]init];
    _politicalParyLabelValue.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    _politicalParyLabelValue.textColor = [self colorWithHexString:@"434343"];
    _politicalParyLabelValue.backgroundColor = [UIColor clearColor];
    _politicalParyLabelValue.textAlignment = NSTextAlignmentLeft;
    
    _birthLabel = [[UILabel alloc]init];
    _birthLabelValue = [[UILabel alloc]init];
    
    _deathLabel = [[UILabel alloc]init];
    _deathLabelValue = [[UILabel alloc]init];
    
    _awardLabel = [[UILabel alloc]init];
    _awardLabelValue = [[UILabel alloc]init];
    
    _signatureLabel = [[UILabel alloc]init];
    _signatureImage = [[UIImageView alloc]init];
}


/*******************************************************************************************************************************
 Method Name          : showDetailViewFrameSetUP
 Number of Parameters : nil
 Return Value         : void
 Description          : Allocation happens in this method and this method will be called when collection view cell clicked
 ********************************************************************************************************************************/
-(void)showDetailViewFrameSetUP
{
    self.ilscrollView.contentOffset = CGPointMake(0,0);

    self.detailsPMBGImageView.frame = CGRectMake((self.bgCollectionView.frame.size.width/2) - 80,-40, 160, 160);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        self.leftArrow.frame = CGRectMake(self.view.frame.origin.x + 20 , 20, 40, 50);
        self.rightArrow.frame = CGRectMake(self.view.frame.size.width - 120 , 20, 40, 50);
    }
    else
    {
        self.leftArrow.frame = CGRectMake((self.bgCollectionView.frame.size.width/2) - 150, 20, 40, 50);
        
        self.rightArrow.frame = CGRectMake((self.bgCollectionView.frame.size.width/2) + 105, 20, 40, 50);
        
    }
    
    if (_currentViewCellNumber == 0)
    {
        _leftArrow.enabled = NO;
        _leftArrow.hidden = YES;
    }
    
    if (_currentViewCellNumber == [primeMinisterObjects count] -1)
    {
        _rightArrow.enabled = NO;
        _rightArrow.hidden = YES;
        
    }
    self.detailsPMName.frame = CGRectMake(self.collectionView.frame.origin.x ,105, self.collectionView.frame.size.width, 70);
    
    // For About Label
    _descriptionLabel.frame = CGRectMake(self.collectionView.frame.origin.x + 10,Description_YCoordinate,self.collectionView.frame.size.width - 20,20);
    
    self.detailsPMDescription.editable = NO;
    self.detailsPMBGImageView.image = [UIImage imageNamed:@"Big_Avatar"];
    [self shiftLabelFrameWhenNoDeath];
    
    [self getCustomFontStyleForAllDetailHeadings:_descriptionLabel withText:@"About: " withTextAllignment:NSTextAlignmentLeft];
    [self getCustomFontStyleForAllDetailHeadings:_politicalParyLabel withText: @"Political Party: " withTextAllignment:NSTextAlignmentLeft];
    [self getCustomFontStyleForAllDetailHeadings:_birthLabel withText:@"Birth: " withTextAllignment:NSTextAlignmentLeft];
    [self getCustomFontStyleForAllDetailHeadings:_deathLabel withText:@"Death: " withTextAllignment:NSTextAlignmentLeft];
    [self getCustomFontStyleForAllDetailHeadings:_awardLabel withText:@"Award: " withTextAllignment:NSTextAlignmentLeft];
    [self getCustomFontStyleForAllDetailHeadings:_signatureLabel withText:@"Signature: " withTextAllignment:NSTextAlignmentLeft];
    
    
    if (_signatureImage.image == Nil)
    {
        NSLog(@"There is no image");
        _signatureImage.hidden = YES;
        _signatureLabel.hidden = YES;
    }else
    {
        _signatureImage.hidden = NO;
        _signatureLabel.hidden = NO;
    }

}



#pragma mark - Adding and Removing Subview Methods

/*******************************************************************************************************************************
 Method Name          : addingSubviews
 Number of Parameters : nil
 Return Value         : void
 Description          : Method will be called when collection cell clicked. ********************************************************************************************************************************/
-(void)addingSubviews
{
    
    [self.bgCollectionView addSubview:_detailsPMBGImageView];
    [self.bgCollectionView addSubview:_detailsPMName];

    [self.ilscrollView addSubview:_detailsPMDescription];
    [self.bgCollectionView addSubview:_detailsPMImageView];
    [self.bgCollectionView addSubview:_leftArrow];
    [self.bgCollectionView addSubview:_rightArrow];
    [self.ilscrollView addSubview:_descriptionLabel];
    
    [self.ilscrollView addSubview:_birthLabel];
    [self.ilscrollView addSubview:_birthLabelValue];

    [self.ilscrollView addSubview:_politicalParyLabel];
    [self.ilscrollView addSubview:_politicalParyLabelValue];
    
    [self.ilscrollView addSubview:_deathLabel];
    [self.ilscrollView addSubview:_deathLabelValue];

    [self.ilscrollView addSubview:_awardLabel];
    [self.ilscrollView addSubview:_awardLabelValue];

    [self.ilscrollView addSubview:_signatureLabel];
    [self.ilscrollView addSubview:_signatureImage];
}

/*******************************************************************************************************************************
 Method Name          : removingSubviews
 Number of Parameters : nil
 Return Value         : void
 Description          : Method will be called when Back button is called. ********************************************************************************************************************************/
-(void)removingSubviews
{
    
    [_detailsPMBGImageView removeFromSuperview];
    [_detailsPMName removeFromSuperview];
    [_detailsPMDescription removeFromSuperview];
    [_detailsPMImageView removeFromSuperview];
    [_leftArrow removeFromSuperview];
    [_rightArrow removeFromSuperview];
    [_birthLabel removeFromSuperview];
    [_birthLabelValue removeFromSuperview];
    [_politicalParyLabel removeFromSuperview];
    [_politicalParyLabelValue removeFromSuperview];
    [_deathLabel removeFromSuperview];
    [_deathLabelValue removeFromSuperview];
    [_awardLabel removeFromSuperview];
    [_awardLabelValue removeFromSuperview];
    [_signatureLabel removeFromSuperview];
    [_signatureImage removeFromSuperview];

}



#pragma mark - Custom Methods


-(void)getCustomFontStyleForAllDetailHeadings:(UILabel*) label withText:(NSString*)string withTextAllignment:(NSTextAlignment*)alignment
{
    label.text = string;
    
    label.textColor = [self colorWithHexString:@"F96214"];

    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:18];
}

-(void)getCustomFontStyleForALLDetailHeadingValues:(UILabel*)textView
{
    textView.font = [UIFont fontWithName:@"HelveticaNeueInterface-Regular" size:16];
    textView.textColor = [self colorWithHexString:@"434343"];
    
    textView.textAlignment = NSTextAlignmentLeft;
    textView.backgroundColor = [UIColor clearColor];
}



-(void)hideCollectionViewObjects
{
    [UIView beginAnimations: @"cross dissolve" context: NULL];
    [UIView setAnimationDuration: 0.2f];
    _collectionView.alpha = 1.0;
    _collectionView.alpha = 0.0;
    [UIView commitAnimations];
    
}

- (IBAction)backButtonClicked:(id)sender
{
    
    _isBackButtonClicked = YES;

    _backButton.hidden = YES;

    self.leaderDisignation.hidden = NO;

    [self removingSubviews];
    [self clearDetailPMView];
    [self showAnimateView:self.collectionView fromPoint:0.0 toPoint:1.0];
}

-(void)clearDetailPMView
{
    _detailsPMName.text = nil;
    
    _descriptionLabel.text = nil;
    _detailsPMDescription.text = nil;
    
    _detailsPMBGImageView.image = nil;
    _detailsPMImageView.image = nil;
    
    _politicalParyLabel.text = nil;
    _politicalParyLabelValue.text = nil;
    
    _birthLabel.text = nil;
    _birthLabelValue.text = nil;
    
    _deathLabel.text = nil;
    _deathLabelValue.text = nil;
    
    _awardLabel.text = nil;
    _awardLabelValue.text = nil;
    
    _signatureImage.image = nil;
    _signatureLabel.text = nil;
    
    _leftArrow.hidden = YES;
    _rightArrow.hidden = YES;
    _ilscrollView.hidden = YES;

}


-(void)showAnimateView:(UIView *)showingView fromPoint:(NSInteger)from toPoint:(NSInteger)to
{
    [UIView beginAnimations: @"cross dissolve" context: NULL];
    [UIView setAnimationDuration: 0.5f];
    showingView.alpha = from;
    showingView.alpha = to;
    [UIView commitAnimations];

}


-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark - Admobs Methods

/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"adViewDidReceiveAd");
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that a full screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication");
}

@end
