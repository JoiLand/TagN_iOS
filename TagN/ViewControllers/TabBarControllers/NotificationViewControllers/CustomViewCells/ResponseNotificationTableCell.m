//
//  ResponseNotificationTableCell.m
//  TagN
//
//  Created by JH Lee on 2/12/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "ResponseNotificationTableCell.h"

@implementation ResponseNotificationTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewsWithNotiObj:(NotiObj *)objNoti {
    m_share_id = objNoti.noti_share_id;
    [self.m_imgAvatar setImageWithURL:[NSURL URLWithString:AVATAR_FULL_URL_STRING(objNoti.noti_from_user_avatar_url)]];
    self.m_lblString.text = objNoti.noti_string;   
    self.m_lblTime.text = [objNoti.noti_created_at stringWithTimeDifference];
}

@end
