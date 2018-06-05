//
//  DMBadgeTests.m
//  DataModelTests
//
//  Created by Jian on 6/5/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMBadge.h"
#import "Keys.h"



@interface DMBadgeTests : XCTestCase

@end



@implementation DMBadgeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testGold
{
    NSNumber *num = @9999;
    DMBadge *badge = [DMBadge parseDictionary: @{kGold: num}];
    
    XCTAssertEqual(badge.numOfGolds, num.integerValue);
}

-(void)testSilver
{
    NSNumber *num = @9999;
    DMBadge *badge = [DMBadge parseDictionary: @{kSilver: num}];
    
    XCTAssertEqual(badge.numOfSilvers, num.integerValue);
}

-(void)testBronze
{
    NSNumber *num = @9999;
    DMBadge *badge = [DMBadge parseDictionary: @{kBronze: num}];
    
    XCTAssertEqual(badge.numOfBronzes, num.integerValue);
}

-(void)testScore
{
    NSNumber *num = @9999;
    DMBadge *badge = [DMBadge parseDictionary: @{kGold: num,
                                                 kSilver: num,
                                                 kBronze: num}];
    
    float score = num.integerValue * 0.5 + num.integerValue * 0.3 + num.integerValue * 0.2;
    XCTAssertEqual(badge.score, score);
}


@end
