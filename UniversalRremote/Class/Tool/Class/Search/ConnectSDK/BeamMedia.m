//
//  BeamMedia.m
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/21.
//

#import "BeamMedia.h"

@implementation BeamMedia

+ (void)castImageWithDievce:(nonnull ConnectableDevice *)device andURl:(nonnull NSString *)url {
    
    NSURL *mediaURL = [NSURL URLWithString:url]; // credit: Blender Foundation/CC By 3.0
    NSURL *iconURL = [NSURL URLWithString:url]; // credit: sintel-durian.deviantart.com
    NSString *title = @"Sintel Character Design";
    NSString *description = @"Blender Open Movie Project";
    
    NSString *imageType = [BeamMedia getImageType:url];
    
    NSString *mimeType = [@"image/" stringByAppendingString:imageType];
    
    MediaInfo *mediaInfo = [[MediaInfo alloc] initWithURL:mediaURL mimeType:mimeType];
    mediaInfo.title = title;
    mediaInfo.description = description;
    ImageInfo *imageInfo = [[ImageInfo alloc] initWithURL:iconURL type:ImageTypeThumb];
    [mediaInfo addImage:imageInfo];
    
    __block MediaLaunchObject *launchObject;
    
    [device.mediaPlayer displayImageWithMediaInfo:mediaInfo
                                          success:
     ^(MediaLaunchObject *mediaLaunchObject) {
        NSLog(@"display photo success");
        
        // save the object reference to control media playback
        launchObject = mediaLaunchObject;
        
        // enable your media control UI elements here
    }
                                          failure:
     ^(NSError *error) {
        NSLog(@"display photo failure: %@", error.localizedDescription);
    }];
    
}

+ (NSString *)getImageType:(NSString *)url {
    
    NSString *extension = [url pathExtension];

    if ([extension isEqualToString:@"jpg"] || [extension isEqualToString:@"jpeg"] || [extension isEqualToString:@"JEPG"] || [extension isEqualToString:@"JPG"]) {
        return  @"jpeg";
    } else if ([extension isEqualToString:@"png"] || [extension isEqualToString:@"PNG"]) {
        return  @"png";
    } else {
        return  @"jpeg";
    }
}

+ (void)castVideoWithDievce:(ConnectableDevice *)device andURl:(NSString *)url {
    
    NSURL *mediaURL = [NSURL URLWithString:url]; // credit: Blender Foundation/CC By 3.0
    NSURL *iconURL = [NSURL URLWithString:@"http://ldyt.online/FLogo.jpg"]; // credit: sintel-durian.deviantart.com
    NSString *title = @"Sintel Trailer";
    NSString *description = @"Blender Open Movie Project";
    NSString *mimeType = @"video/mp4"; // audio/* for audio files

    MediaInfo *mediaInfo = [[MediaInfo alloc] initWithURL:mediaURL mimeType:mimeType];
    mediaInfo.title = title;
    mediaInfo.description = description;
    ImageInfo *imageInfo = [[ImageInfo alloc] initWithURL:iconURL type:ImageTypeThumb];
    [mediaInfo addImage:imageInfo];

    if ([device hasCapability:kMediaPlayerSubtitleWebVTT]) {
        NSURL *subtitlesURL = [NSURL URLWithString:@"http://ec2-54-201-108-205.us-west-2.compute.amazonaws.com/samples/media/sintel_en.vtt"];
        SubtitleInfo *subtitleInfo = [SubtitleInfo infoWithURL:subtitlesURL
                                                      andBlock:^(SubtitleInfoBuilder *builder) {
                                                          builder.mimeType = @"text/vtt";
                                                          builder.language = @"English";
                                                          builder.label = @"English Subtitles";
                                                      }];
        mediaInfo.subtitleInfo = subtitleInfo;
    }

    __block MediaLaunchObject *launchObject;

    [device.mediaPlayer playMediaWithMediaInfo:mediaInfo
                                         shouldLoop:NO
                                            success:
     ^(MediaLaunchObject *mediaLaunchObject) {
         NSLog(@"play video success");

         // save the object reference to control media playback
         launchObject = mediaLaunchObject;

         // enable your media control UI elements here
     }
                                            failure:
     ^(NSError *error) {
         NSLog(@"play video failure: %@", error.localizedDescription);
     }];
}

@end
