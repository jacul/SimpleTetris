//
//  SimpleTetrisTests.m
//  SimpleTetrisTests
//
//  Created by zxd on 14-8-19.
//  Copyright (c) 2014年 jacul. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STBrickNode.h"

@interface BrickTests : XCTestCase

@end

@implementation BrickTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testCreateLBrick{
    STBrickNode* brick = [STBrickNode createLBrick];
    XCTAssertEqualObjects(brick.description, @"\n0000\n0100\n0100\n0110\n", @"Create L");
}

-(void)testCreateDBrick{
    STBrickNode* brick = [STBrickNode createDBrick];
    XCTAssertEqualObjects(brick.description, @"\n0000\n0110\n0110\n0000\n", @"Create D");
}

-(void)testCreateSBrick{
    STBrickNode* brick = [STBrickNode createSBrick];
    XCTAssertEqualObjects(brick.description, @"\n0000\n0100\n0110\n0010\n", @"Create S");
}

-(void)testCreateTBrick{
    STBrickNode* brick = [STBrickNode createTBrick];
    XCTAssertEqualObjects(brick.description, @"\n0000\n1110\n0100\n0000\n", @"Create T");
}

-(void)testCreateIBrick{
    STBrickNode* brick = [STBrickNode createIBrick];
    XCTAssertEqualObjects(brick.description, @"\n0010\n0010\n0010\n0010\n", @"Create I");
}

-(void)testRotateRight{
    STBrickNode* brick = [STBrickNode createLBrick];
    [brick rotateRight];
    XCTAssertEqualObjects(brick.description, @"\n0000\n1110\n1000\n0000\n", @"Right rorate");
}

-(void)testRotateLeft{
    STBrickNode* brick = [STBrickNode createTBrick];
    [brick rotateLeft];
    XCTAssertEqualObjects(brick.description, @"\n0000\n0100\n0110\n0100\n", @"Left rotate");
}

@end
