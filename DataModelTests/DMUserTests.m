//
//  DMUserTests.m
//  DataModelTests
//
//  Created by Jian on 6/5/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMUser.h"
#import "Keys.h"



@interface DMUserTests : XCTestCase

@end



@implementation DMUserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testDisplayName
{
    NSString *name = @"John";
    DMUser *user = [DMUser parseDictionary: @{kDisplayName: name}];
    
    XCTAssertEqual(user.displayName, name);
}

-(void)testGravatarLink
{
    NSString *link = @"https://www.gravatar.com/avatar/747ffa5da3538e66840ebc0548b8fd58?s=128&d=identicon&r=PG";
    DMUser *user = [DMUser parseDictionary: @{kProfileImage: link}];
    
    XCTAssertEqual(user.gravatarLink, link);
}

-(void)testReputation
{
    NSNumber *num = @999;
    DMUser *user = [DMUser parseDictionary: @{kReputation: num}];
    
    XCTAssertEqual(user.reputation, num.integerValue);
}

-(void)testBadge
{
    DMUser *user = [DMUser parseDictionary: @{}];
    XCTAssertNil(user.badge);
}


@end
