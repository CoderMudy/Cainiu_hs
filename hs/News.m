//
//  News.m
//  hs
//
//  Created by RGZ on 15/12/30.
//  Copyright © 2015年 luckin. All rights reserved.
//
/**picFlag;
 //热门新闻：结束时间
 @property (nonatomic,strong)NSString    *hotEndTime;
 //是否热门
 @property (nonatomic,strong)NSString    *hot;
 //是否置顶
 @property (nonatomic,strong)NSString    *top;*/
#import "News.h"

@implementation News

@synthesize title,sectionName,summary,permitComment,bannerUrl,readCount,plateName,createDate,content,subTitle,modifyDate,status,keyword,createStaffName,cmtCount,orderWeight,sourceType,newsID,newsPlateIdList,targetType,outSourceName,section,outSourceUrl,picFlag,hotEndTime,hot,top,readStatus;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:sectionName forKey:@"sectionName"];
    [aCoder encodeObject:summary forKey:@"summary"];
    [aCoder encodeObject:permitComment forKey:@"permitComment"];
    [aCoder encodeObject:bannerUrl forKey:@"bannerUrl"];
    [aCoder encodeObject:readCount forKey:@"readCount"];
    [aCoder encodeObject:plateName forKey:@"plateName"];
    [aCoder encodeObject:createDate forKey:@"createDate"];
    [aCoder encodeObject:content forKey:@"content"];
    [aCoder encodeObject:subTitle forKey:@"subTitle"];
    [aCoder encodeObject:modifyDate forKey:@"modifyDate"];
    [aCoder encodeObject:status forKey:@"status"];
    [aCoder encodeObject:keyword forKey:@"keyword"];
    [aCoder encodeObject:createStaffName forKey:@"createStaffName"];
    [aCoder encodeObject:cmtCount forKey:@"cmtCount"];
    [aCoder encodeObject:orderWeight forKey:@"orderWeight"];
    [aCoder encodeObject:sourceType forKey:@"sourceType"];
    [aCoder encodeObject:newsID forKey:@"newsID"];
    [aCoder encodeObject:newsPlateIdList forKey:@"newsPlateIdList"];
    [aCoder encodeObject:targetType forKey:@"targetType"];
    [aCoder encodeObject:outSourceName forKey:@"outSourceName"];
    [aCoder encodeObject:section forKey:@"section"];
    [aCoder encodeObject:outSourceUrl forKey:@"outSourceUrl"];
    [aCoder encodeObject:readStatus forKey:@"readStatus"];
    [aCoder encodeObject:picFlag forKey:@"picFlag"];
    [aCoder encodeObject:hotEndTime forKey:@"hotEndTime"];
    [aCoder encodeObject:hot forKey:@"hot"];
    [aCoder encodeObject:top forKey:@"top"];

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.title=[aDecoder decodeObjectForKey:@"title"];
        self.sectionName=[aDecoder decodeObjectForKey:@"sectionName"];
        self.summary=[aDecoder decodeObjectForKey:@"summary"];
        self.permitComment=[aDecoder decodeObjectForKey:@"permitComment"];
        self.bannerUrl=[aDecoder decodeObjectForKey:@"bannerUrl"];
        self.readCount=[aDecoder decodeObjectForKey:@"readCount"];
        self.plateName=[aDecoder decodeObjectForKey:@"plateName"];
        self.createDate=[aDecoder decodeObjectForKey:@"createDate"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.subTitle = [aDecoder decodeObjectForKey:@"subTitle"];
        self.modifyDate = [aDecoder decodeObjectForKey:@"modifyDate"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.keyword=[aDecoder decodeObjectForKey:@"keyword"];
        self.createStaffName=[aDecoder decodeObjectForKey:@"createStaffName"];
        self.cmtCount=[aDecoder decodeObjectForKey:@"cmtCount"];
        self.orderWeight=[aDecoder decodeObjectForKey:@"orderWeight"];
        self.sourceType=[aDecoder decodeObjectForKey:@"sourceType"];
        self.newsID=[aDecoder decodeObjectForKey:@"newsID"];
        self.newsPlateIdList=[aDecoder decodeObjectForKey:@"newsPlateIdList"];
        self.targetType=[aDecoder decodeObjectForKey:@"targetType"];
        self.outSourceName = [aDecoder decodeObjectForKey:@"outSourceName"];
        self.section = [aDecoder decodeObjectForKey:@"section"];
        self.outSourceUrl = [aDecoder decodeObjectForKey:@"outSourceUrl"];
        self.readStatus = [aDecoder decodeObjectForKey:@"readStatus"];
        self.picFlag = [aDecoder decodeObjectForKey:@"picFlag"];
        self.hotEndTime = [aDecoder decodeObjectForKey:@"hotEndTime"];
        self.hot = [aDecoder decodeObjectForKey:@"hot"];
        self.top = [aDecoder decodeObjectForKey:@"top"];

    }
    
    return self;
}

@end
