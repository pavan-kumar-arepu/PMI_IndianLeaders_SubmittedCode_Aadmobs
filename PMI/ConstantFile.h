//
//  ConstantFile.h
//  PMI
//
//  Created by Pavankumar Arepu on 05/07/15.
//  Copyright © 2015 pavan kumar. All rights reserved.
//

#ifndef ConstantFile_h
#define ConstantFile_h

#endif /* ConstantFile_h */

#define HEADER_HEIGHT 60
#define HEADERIMAGE_WIDTH 240
#define HEADERIMAGE_HEIGHT 40


#define Description_YCoordinate 15
#define NumberOfCharPerLineIniPad2 80
#define NumberOfCharPerLineIniPhone6 43
#define NumberOfCharPerLineIniPhone5S 30

#define DiscriptionsRightPadding 40
#define DiscriptionsLeftPadding 30

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height == 568.0) && ((IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale) || !IS_OS_8_OR_LATER))
#define IS_STANDARD_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)

#define IS_ZOOMED_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale > [UIScreen mainScreen].scale)
#define IS_STANDARD_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_ZOOMED_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale < [UIScreen mainScreen].scale)

/******************************************* */
