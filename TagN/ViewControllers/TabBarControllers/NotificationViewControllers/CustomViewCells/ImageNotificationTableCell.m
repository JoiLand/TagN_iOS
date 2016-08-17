//
//  ImageNotificationTableCell.m
//  TagN
//
//  Created by JH Lee on 2/17/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "ImageNotificationTableCell.h"

@implementation ImageNotificationTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewsWithNotiObj:(NotiObj *)objNoti {
    m_objImage = [[GlobalService sharedInstance].user_me getImageObjFromId:objNoti.noti_share_image_id];
    [self.m_imgAvatar setImageWithURL:[NSURL URLWithString:AVATAR_FULL_URL_STRING(objNoti.noti_from_user_avatar_url)]];
    self.m_lblString.text = objNoti.noti_string;
    self.m_lblTime.text = [objNoti.noti_created_at stringWithTimeDifference];
    
    if(m_objImage) {
        [self.m_imgPhoto setImageThumbWithObj:m_objImage
                              withPlaceholder:IMAGE_PLACEHOLDER_URL_STRING];
    } else {
        [self.m_imgPhoto setImage:[UIImage imageNamed:IMAGE_UNKNOWN_URL_STRING]];
    }
}

- (IBAction)onTapImage:(id)sender {
    [self.delegate onTapImage:m_objImage];
}

@end
