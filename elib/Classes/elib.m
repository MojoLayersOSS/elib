//
//  elib.m
//  elib
//
//  Created by Joseph Shenton on 22/4/2023.
//

#import "elib.h"

@implementation ELib

+ (BOOL)doesFileExist:(NSString *)path {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return YES;
    }
    
    return NO;
}

+ (ZSignAsset)buildSigningIdentityFromP12AtPath:(NSString *)p12Path withMobileProvisionPath:(NSString*)mpPath withPassword:(NSString *)pw {
    
    
    if (![self doesFileExist:p12Path]) {
        NSLog(@"[ELib] [PFFR-0001] [❌] Failed to retreive P12 File. Throwing Exception.");
        [NSException raise:@"Unable to find P12 File" format:@"The provided P12 Path is incorrect."];
    }
    
    // Example Input
    // NSString *p12Path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"p12.p12"];
    std::string stdP12File(p12Path.fileSystemRepresentation);
    
    
    if (![self doesFileExist:mpPath]) {
        NSLog(@"[ELib] [PFFR-0002] [❌] Failed to retreive Mobileprovision File. Throwing Exception.");
        [NSException raise:@"Unable to find MP File" format:@"The provided MP Path is incorrect."];
    }
    
    // Example Input
    // NSString *mpPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"provision.mobileprovision"];
    std::string stdMPFile(mpPath.fileSystemRepresentation);
    
    // Example Input
    // NSString *pw = @"Password";
    string stdPW = std::string([pw UTF8String]);
    
    // Create Asset
    
    ZSignAsset signingIdentity;
    if (!signingIdentity.Init(JValue::null, stdP12File, stdMPFile, JValue::null, stdPW)) {
        NSLog(@"[ELib] [PFFR-0004] [❌] Failed to build signing identity. Throwing Exception.");
        [NSException raise:@"Unable to create ZSign Asset." format:@"P12 Path, Mobileprovision Path or Password is incorrect."];
    }
    
    NSLog(@"[ELib] [✅] Successfully built signing identity.");
    
    return signingIdentity;
}

+ (UZKArchive *)extractIPAAtPath:(NSString *)ipaPath {
    return [self extractIPAAtPath:ipaPath withOutputPath:NSTemporaryDirectory()];
}

+ (UZKArchive *)extractIPAAtPath:(NSString *)ipaPath withOutputPath:(NSString *)OD {
    
    if (![self doesFileExist:ipaPath]) {
        NSLog(@"[ELib] [PFFR-0005] [❌] Failed to retreive IPA File. Throwing Exception.");
        [NSException raise:@"Unabled to find IPA File" format:@"The provided IPA Path is incorrect."];
    }
    
    NSError *archiveError = nil;
    NSError *error = nil;
    UZKArchive *archive = [[UZKArchive alloc] initWithPath:ipaPath error:&archiveError];
    
    if (![archive
          extractFilesTo:[OD stringByAppendingString:@"Bundle/"]
          overwrite:NO
          error:&error]) {
        NSLog(@"[ELib] [PFFR-0006] [❌] Failed to extract IPA File. Throwing Exception.");
        [NSException raise:@"Unable to extract IPA File" format:@"The provided IPA File did not extract correctly. This may be a corruption or missing file."];
    }
    
    NSLog(@"[ELib] [✅] Successfully extracted IPA File.");
    
    return archive;
}

+ (NSString *)findAppBundle {
    return [self findAppBundleAtPath:NSTemporaryDirectory()];
}

+ (NSString *)findAppBundleAtPath:(NSString *)path {
    NSError *error = nil;
    NSString *appBundle = @"";
    
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[path stringByAppendingString:@"Bundle/Payload/"] error:&error];
    for (NSString *file in fileList) {
        if (![file.pathExtension isEqualToString:@"app"]) {
            break;
        } else {
            appBundle = [NSString stringWithFormat:@"%@/%@", [NSTemporaryDirectory() stringByAppendingPathComponent:@"Bundle/Payload/"], file];
            
            NSLog(@"[ELib] [✅] Successfully found the .app Bundle.");
            break;
        }
    }
    
    return appBundle;
}

// Finds IPAs In NSTemporaryDirectory();
+ (NSArray *)findIPAs {
    return [self findIPAsAtPath:NSTemporaryDirectory()];
}

// Finds IPAs in a Provided Path
+ (NSArray *)findIPAsAtPath:(NSString *)directoryPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:directoryPath error:&error];
    
    if (error) {
        NSLog(@"Error reading directory: %@", error.localizedDescription);
        return nil;
    }
    
    NSMutableArray *ipas = [NSMutableArray array];
    
    for (NSString *file in directoryContents) {
        NSString *extension = [file pathExtension];
        
        if ([extension isEqualToString:@"ipa"]) {
            NSString *path = [directoryPath stringByAppendingPathComponent:file];
            [ipas addObject:path];
        }
    }
    
    return [ipas copy];
}

+ (ZAppBundle)buildAppBundleAndSignWithSigningIdentity:(ZSignAsset)signingIdentity {

    ZAppBundle bundle;
    bool isCacheEnabled = false;
    
    NSString *appBundle = [self findAppBundle];
    std::string FolderContents(appBundle.fileSystemRepresentation);
    
    if (!bundle.SignFolder(&signingIdentity, FolderContents, "", "", "", "", "", "", isCacheEnabled)) {
        NSLog(@"[ELib] [PFFR-0007] [❌] Failed to sign the contents of the IPA. Throwing Exception.");
        [NSException raise:@"Unable to sign IPA File" format:@"The provided IPA File was not able to be signed correctly. | App Bundle => %@", appBundle];
    }
    
    NSLog(@"[ELib] [✅] Successfully built and signed the App Bundle with Signing Identity.");
    
    return bundle;
}

+ (ZAppBundle)buildAppBundleAndSignWithSigningIdentity:(ZSignAsset)signingIdentity atPath:(NSString*)bundleDirectory {

    ZAppBundle bundle;
    bool isCacheEnabled = false;
    
    NSString *appBundle = [self findAppBundleAtPath:bundleDirectory];
    std::string FolderContents(appBundle.fileSystemRepresentation);
    
    if (!bundle.SignFolder(&signingIdentity, FolderContents, "", "", "", "", "", "", isCacheEnabled)) {
        NSLog(@"[ELib] [PFFR-0007] [❌] Failed to sign the contents of the IPA. Throwing Exception.");
        [NSException raise:@"Unable to sign IPA File" format:@"The provided IPA File was not able to be signed correctly. | App Bundle => %@", appBundle];
    }
    
    NSLog(@"[ELib] [✅] Successfully built and signed the App Bundle with Signing Identity.");
    
    return bundle;
}


// Example
// [ELib repackageIPAFileWithBundleAtPath:@"" andIPAName:@"Spotify" andOutputPath:@""];
+ (BOOL)repackageIPAFileWithBundleAtPath:(NSString *)bundlePath andIPAName:(NSString *)ipaName andOutputPath: (NSString *)outputPath {
    
    if ([bundlePath isEqualToString:@""]) {
        bundlePath = NSTemporaryDirectory();
    }
    
    if ([outputPath isEqualToString:@""]) {
        outputPath = NSTemporaryDirectory();
    }
    
    NSString *ipaOutputPath = [outputPath stringByAppendingString:[ipaName stringByAppendingString:@".ipa"]];
    NSString *bundleDirectory = [bundlePath stringByAppendingString:@"Bundle/"];
    
    if (![SSZipArchive createZipFileAtPath:ipaOutputPath withContentsOfDirectory:bundleDirectory]) {
        NSLog(@"[ELib] [PFFR-0008] [❌] Failed to compress the contents of the IPA. Throwing Exception.");
        [NSException raise:@"Unable to compress IPA contents" format:@"The IPA contents were not able to be compressed correctly."];
        return NO;
    }
    
    if (![self doesFileExist:ipaOutputPath]) {
        NSLog(@"[ELib] [PFFR-0009] [❌] Failed to find the newly created IPA File. Throwing Exception.");
        [NSException raise:@"Unable to find new IPA File" format:@"The new IPA File was not able to be found."];
        return NO;
    }
    
    
    return YES;
}

// Uses NSTemporaryDirectory()
+ (NSString *)resignIPAFileAtPath:(NSString *)ipaPath withP12AtPath:(NSString *)p12Path andMobileProvisionAtPath:(NSString *)MPPath andPassword:(NSString *)pw {
    
    NSString *ipaName = [ipaPath lastPathComponent];
    
    // Build Signing Identity
    ZSignAsset signingIdentity = [self buildSigningIdentityFromP12AtPath:p12Path withMobileProvisionPath:MPPath withPassword:pw];
    
    // Extract IPA File
    [self extractIPAAtPath:ipaPath];
    
    [self buildAppBundleAndSignWithSigningIdentity:signingIdentity];
    
    [self repackageIPAFileWithBundleAtPath:@"" andIPAName:ipaName andOutputPath:@""];
    
    if (![self doesFileExist:[NSTemporaryDirectory() stringByAppendingString:[ipaName stringByAppendingString:@".ipa"]]]) {
        NSLog(@"[ELib] [PFFR-0009] [❌] Failed to find the newly created IPA File. Throwing Exception.");
        [NSException raise:@"Unable to find new IPA File" format:@"The new IPA File was not able to be found."];
        return @"Failed";
    }
    
    NSLog(@"[ELib] [✅] Successfully IPA with P12 and Mobileprovision and is stored in the TMP Directory for this App.");
    
    return [NSTemporaryDirectory() stringByAppendingString:[ipaName stringByAppendingString:@".ipa"]];
}

+ (NSString *)resignIPAFileAtPath:(NSString *)ipaPath withP12AtPath:(NSString *)p12Path andMobileProvisionAtPath:(NSString *)MPPath andPassword:(NSString *)pw  andOutputPath:(NSString *)outputPath {
    
    NSString *ipaName = [ipaPath lastPathComponent];
    
    // Build Signing Identity
    ZSignAsset signingIdentity = [self buildSigningIdentityFromP12AtPath:p12Path withMobileProvisionPath:MPPath withPassword:pw];
    
    // Extract IPA File
    [self extractIPAAtPath:ipaPath withOutputPath:outputPath];
    
    [self buildAppBundleAndSignWithSigningIdentity:signingIdentity];
    
    [self repackageIPAFileWithBundleAtPath:outputPath andIPAName:ipaName andOutputPath:outputPath];
    
    if (![self doesFileExist:[outputPath stringByAppendingString:[ipaName stringByAppendingString:@".ipa"]]]) {
        NSLog(@"[ELib] [PFFR-0009] [❌] Failed to find the newly created IPA File. Throwing Exception.");
        [NSException raise:@"Unable to find new IPA File" format:@"The new IPA File was not able to be found."];
        return @"Failed";
    }
    
    NSLog(@"[ELib] [✅] Successfully IPA with P12 and Mobileprovision and is stored in the provided output directory.");
    
    return [outputPath stringByAppendingString:[ipaName stringByAppendingString:@".ipa"]];
}
// Uses Provided Path

@end

