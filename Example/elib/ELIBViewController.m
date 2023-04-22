//
//  ELIBViewController.m
//  elib
//
//  Created by joesecureroo on 04/20/2023.
//  Copyright (c) 2023 joesecureroo. All rights reserved.
//

#import "ELIBViewController.h"

@interface ELIBViewController ()

@end

@implementation ELIBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *p12File = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"p12.p12"];
    NSString *provisionFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"provision.mobileprovision"];
    NSString *password = @"AppleP12.com";
    
    NSString *ipaFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ipa.ipa"];
    
    NSString *signedIPAPath = [ELib resignIPAFileAtPath:ipaFile withP12AtPath:p12File andMobileProvisionAtPath:provisionFile andPassword:password];
    
    NSLog(@"IPA Signed and is Located at %@", signedIPAPath);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
