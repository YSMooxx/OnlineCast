//
//  BeamMedia.h
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/21.
//

#import <Foundation/Foundation.h>
#import "ConnectSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeamMedia : NSObject

+ (void)castImageWithDievce:(ConnectableDevice *) device andURl:(NSString *)url;
+ (void)castVideoWithDievce:(ConnectableDevice *) device andURl:(NSString *)url;
+ (NSString *)getImageType:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
