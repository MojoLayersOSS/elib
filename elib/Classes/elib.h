//
//  elib.h
//  Pods
//
//  Created by Joseph Shenton on 22/4/2023.
//

#ifndef elib_h
#define elib_h

// Import Foundation
#import <Foundation/Foundation.h>

// Import OpenSSL
#import <OpenSSL/OpenSSL.h>

// Import UnzipKit
#import <UnzipKit/UnzipKit.h>

// Import (SS)ZipArchive
#import <SSZipArchive/SSZipArchive.h>

// Include C Libraries
#include <string>
#include <stdio.h>

// Include zCore
#include <zCore/common/common.h>
#include <zCore/common/json.h>
#include <zCore/openssl.h>
#include <zCore/macho.h>
#include <zCore/bundle.h>

@interface ELib : NSObject

+ (ZSignAsset)buildSigningIdentityFromP12AtPath:(NSString *)p12Path withMobileProvisionPath:(NSString*)mpPath withPassword:(NSString *)pw;

+ (UZKArchive *)extractIPAAtPath:(NSString *)ipaPath;
+ (UZKArchive *)extractIPAAtPath:(NSString *)ipaPath withOutputPath:(NSString *)OD;

+ (NSString *)findAppBundle;
+ (NSString *)findAppBundleAtPath:(NSString *)path;

+ (NSArray *)findIPAs;
+ (NSArray *)findIPAsAtPath:(NSString *)directoryPath;

+ (ZAppBundle)buildAppBundleAndSignWithSigningIdentity:(ZSignAsset)signingIdentity;
+ (ZAppBundle)buildAppBundleAndSignWithSigningIdentity:(ZSignAsset)signingIdentity atPath:(NSString*)bundleDirectory;

+ (BOOL)repackageIPAFileWithBundleAtPath:(NSString *)bundlePath andIPAName:(NSString *)ipaName andOutputPath: (NSString *)outputPath;

+ (NSString *)resignIPAFileAtPath:(NSString *)ipaPath withP12AtPath:(NSString *)p12Path andMobileProvisionAtPath:(NSString *)MPPath andPassword:(NSString *)pw;
+ (NSString *)resignIPAFileAtPath:(NSString *)ipaPath withP12AtPath:(NSString *)p12Path andMobileProvisionAtPath:(NSString *)MPPath andPassword:(NSString *)pw  andOutputPath:(NSString *)outputPath;

@end

#endif /* elib_h */
