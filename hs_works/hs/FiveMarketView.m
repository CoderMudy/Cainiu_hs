//
//  FiveMarketView.m
//  hs
//
//  Created by Xse on 15/11/27.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "FiveMarketView.h"
#import "FiveMarketCell.h"
#import "HJCAjustNumButton.h"
#import "FiveMarketModel.h"

@interface FiveMarketView()
{
    FiveMarketCell *lastCell;
    UIButton *priceBtn;
    
    NSMutableArray *saleArray;
    NSMutableArray *buyArray;
    
    NSInteger firstNum;
    NSInteger firstBtnNum;
}

@end

@implementation FiveMarketView

@synthesize fiveMakreTime;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        [self initTableView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeFiveTime:) name:@"closeFiveTime" object:nil];
        
    }
    
    return self;
}

- (void)initTableView
{
    saleArray = [[NSMutableArray alloc]init];
    buyArray  = [[NSMutableArray alloc]init];
    firstNum = 1;
    firstBtnNum = 1;
    
    [self initView];
    [self reloadFiveData];
    
    fiveMakreTime = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(Timeraction) userInfo:nil repeats:YES];
}

- (void)Timeraction
{
//    saleArray = [[NSMutableArray alloc]init];
    [self reloadFiveData];
}

- (void)initView
{
    
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.frame   = CGRectMake(0, 0, self.frame.size.width, 25*ScreenWidth/320*10 + 20 + 15*ScreenWidth/320 + 40 + 30*ScreenWidth/320 + 10);
    whiteView.layer.cornerRadius = 8;
    whiteView.layer.masksToBounds = YES;
    [self addSubview:whiteView];
    
    _saleTableView = [[UITableView alloc]init];
    _saleTableView.scrollEnabled = NO;
    _saleTableView.frame = CGRectMake(0, 10, whiteView.frame.size.width, 25*ScreenWidth/320*5);
    _saleTableView.delegate = self;
//    _saleTableView.backgroundColor = [UIColor greenColor];
    _saleTableView.dataSource = self;
    _saleTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [whiteView addSubview:_saleTableView];
    
    UIView *viewRedLine = [[UIView alloc]init];
    viewRedLine.tag = 33333;
    viewRedLine.backgroundColor = [UIColor redColor];
    viewRedLine.frame = CGRectMake(28*ScreenWidth/320,CGRectGetMaxY(_saleTableView.frame), self.frame.size.width - 26*ScreenWidth/320*2, 0.5);
    [whiteView addSubview:viewRedLine];
    
    UIView *viewGreenLine = [[UIView alloc]init];
    viewGreenLine.backgroundColor = [UIColor colorWithRed:51/255.0 green:177/255.0 blue:51/255.0 alpha:1];
    viewGreenLine.frame = CGRectMake(28*ScreenWidth/320,CGRectGetMaxY(viewRedLine.frame) + 20, self.frame.size.width - 26*ScreenWidth/320*2, 0.5);
    [whiteView addSubview:viewGreenLine];
    
    if (_buyState == 0)
    {
        viewGreenLine.hidden = YES;
        viewRedLine.hidden = NO;
    }else
    {
        viewGreenLine.hidden = NO;
        viewRedLine.hidden = YES;
    }

    _buyTableView = [[UITableView alloc]init];
    _buyTableView.scrollEnabled = NO;
//    _buyTableView.backgroundColor = [UIColor redColor];
    _buyTableView.frame = CGRectMake(0, CGRectGetMaxY(viewGreenLine.frame), whiteView.frame.size.width, 25*ScreenWidth/320*5);
    _buyTableView.delegate = self;
    _buyTableView.dataSource = self;
    _buyTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [whiteView addSubview:_buyTableView];
    
    UILabel *labelText = [[UILabel alloc]init];
    labelText.text = @"点击五档价格可直接选定";
    labelText.font = [UIFont systemFontOfSize:10.0];
    labelText.textColor = [UIColor colorWithRed:118/255.0 green:123/255.0 blue:117/255.0 alpha:1];
    labelText.frame     = CGRectMake(0, CGRectGetMaxY(_buyTableView.frame) + 15*ScreenWidth/320, self.frame.size.width, 20);
    labelText.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:labelText];
    
    priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    priceBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [priceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [priceBtn setTitle:@"34.87" forState:UIControlStateNormal];
    priceBtn.backgroundColor = [UIColor colorWithRed:232/255.0 green:233/255.0 blue:232/255.0 alpha:1];
    priceBtn.frame = CGRectMake(30, CGRectGetMaxY(labelText.frame), self.frame.size.width - 30*2, 30*ScreenWidth/320);
    priceBtn.layer.cornerRadius = 5;
    priceBtn.layer.masksToBounds = YES;
    priceBtn.layer.borderColor = K_COLOR_CUSTEM(188, 188, 188, 1).CGColor;
    priceBtn.layer.borderWidth = 1;

    [whiteView addSubview:priceBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.tag = 777;
    [sureBtn setTitle:@"返回" forState:UIControlStateNormal];
    sureBtn.backgroundColor = Color_red_pink;
    [sureBtn addTarget:self action:@selector(clickFiveAction:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.frame = CGRectMake(0, CGRectGetMaxY(whiteView.frame), _saleTableView.frame.size.width/2, 40);
    [self addSubview:sureBtn];
    
    UIView *viewLine = [[UIView alloc]init];
    viewLine.frame   = CGRectMake(CGRectGetMaxX(sureBtn.frame), CGRectGetMinY(sureBtn.frame), 0.5, sureBtn.frame.size.height);
    viewLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:viewLine];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setTitle:_btnTitle forState:UIControlStateNormal];
    buyBtn.tag = 888;
    buyBtn.backgroundColor = Color_red_pink;
    [buyBtn addTarget:self action:@selector(clickFiveAction:) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.frame = CGRectMake(CGRectGetMaxX(viewLine.frame), CGRectGetMinY(sureBtn.frame), sureBtn.frame.size.width, sureBtn.frame.size.height);
    [self addSubview:buyBtn];

}

//关闭定时器
- (void)closeFiveTime:(NSNotification*)no
{
    if ([no.object isEqualToString:@"start"])
    {
        [fiveMakreTime setFireDate:[NSDate distantPast]];
    }else
    {
        [fiveMakreTime setFireDate:[NSDate distantFuture]];
    }
}

- (void)reloadFiveData
{
    NSDictionary * dic = @{@"futuresType":_instrumentType};
    
    [NetRequest postRequestWithNSDictionary:dic url:K_Cash_FiveIndexList successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            [saleArray removeAllObjects];
            NSDictionary *dataDic = dictionary[@"data"];
            
            if (dataDic.count > 0)
            {
                for (NSInteger i = 0; i< 5; i++)
                {
                    NSString *askPrice;
                    NSString *askVolume;
                    NSString *askNum;
                    
                    NSString *buyPrice;
                    NSString *buyVolume;
                    NSString *buyNum;
                    
                    if ([_isShowAskOrBid isEqualToString:@"2"])
                    {
                        askPrice      = [NSString stringWithFormat:@"bidPrice%ld",i + 1];
                        askVolume     = [NSString stringWithFormat:@"bidVolume%ld",i + 1];
                        askNum        = [NSString stringWithFormat:@"卖价%ld",5 - i];
                        
                        buyPrice      = [NSString stringWithFormat:@"askPrice%ld",i + 1];
                        buyVolume     = [NSString stringWithFormat:@"askPrice%ld",i + 1];
                        buyNum        = [NSString stringWithFormat:@"买价%ld",i + 1];
                        
                    }else
                    {
                        askPrice      = [NSString stringWithFormat:@"askPrice%ld",5-i];
                        askVolume     = [NSString stringWithFormat:@"askVolume%ld",5 -i];
                        askNum        = [NSString stringWithFormat:@"卖价%ld",5-i];
                        
                        buyPrice      = [NSString stringWithFormat:@"bidPrice%ld",i + 1];
                        buyVolume     = [NSString stringWithFormat:@"bidVolume%ld",i + 1];
                        buyNum        = [NSString stringWithFormat:@"买价%ld",i + 1];
                        
                    }
                    
                    NSMutableDictionary *saleDic   = [[NSMutableDictionary alloc]init];
                    [saleDic setValue:[NSString stringWithFormat:@"%.2f",[dataDic[askPrice] floatValue]] forKey:@"salePrice"];
                    [saleDic setValue:[NSString stringWithFormat:@"%d",[dataDic[askVolume] intValue]] forKey:@"saleVolume"];
                    [saleDic setValue:askNum forKey:@"saleNum"];
                    
                    NSMutableDictionary *buyDic = [[NSMutableDictionary alloc]init];
                    [buyDic setValue:[NSString stringWithFormat:@"%.2f",[dataDic[buyPrice] floatValue]] forKey:@"buyPrice"];
                    [buyDic setValue:[NSString stringWithFormat:@"%d",[dataDic[buyVolume] intValue]] forKey:@"buyVolume"];
                    [buyDic setValue:buyNum forKey:@"buyNum"];
                    
                    FiveMarketModel *model = [[FiveMarketModel alloc]initWithBookseaDic:saleDic buyDic:buyDic];
                    [saleArray addObject:model];
                    
                }
            }
            
        }else
        {
            [[UIEngine sharedInstance] showAlertWithTitle:dictionary[@"msg"] ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
        }
        
        self.backgroundColor = Color_red_pink;
        
        if (firstBtnNum == 1)
        {
             FiveMarketModel *models = nil;
            if (_buyState == 0)
            {
                models = saleArray[4];
                [priceBtn setTitle:[NSString stringWithFormat:@"%@",models.salePrice] forState:UIControlStateNormal];
            }else
            {
                models = saleArray[0];
                [priceBtn setTitle:[NSString stringWithFormat:@"%@",models.buyPrice] forState:UIControlStateNormal];
            }
            firstBtnNum = 2;
        }
        
        [_saleTableView reloadData];
        [_buyTableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
        [_saleTableView reloadData];
        [_buyTableView reloadData];
        self.backgroundColor = Color_red_pink;
    }];

}

#pragma mark - 点击买入/返回
- (void)clickFiveAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 777:
        {
            self.clickBack();
            [fiveMakreTime setFireDate:[NSDate distantFuture]];
            
            [self removeFromSuperview];
        }
            break;
        case 888:
        {
            NSString *priceStr = [priceBtn titleForState:UIControlStateNormal];
            self.clickBuy(priceStr);
            [fiveMakreTime setFireDate:[NSDate distantFuture]];
            [self removeFromSuperview];
        }
            break;
            
        default:
            break;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (saleArray.count>0) {
        return 1;
    }else{
        return 0;
    }
}

#pragma mark - tableView Delegate
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _saleTableView)
    {
        return saleArray.count;
    }else
    {
        return saleArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _saleTableView)
    {
        static NSString *simpleIdentify = @"SimpleIdentify";
        
        FiveMarketCell *cell = (FiveMarketCell *)[tableView dequeueReusableCellWithIdentifier:simpleIdentify];
        if (!cell) {
            cell = [[FiveMarketCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentify];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.priceLab.textColor = [UIColor redColor];

        [cell fillSaleWithData:saleArray[indexPath.row] buyDic:nil];
        
        if (indexPath.row == 4)
        {
            if (_buyState == 0)
            {
                cell.titleLab.textColor = [UIColor colorWithRed:238/255.0 green:43/255.0 blue:33/255.0 alpha:1];
                cell.numLab.textColor   = [UIColor colorWithRed:238/255.0 green:43/255.0 blue:33/255.0 alpha:1];
            }else
            {
                cell.titleLab.textColor = [UIColor colorWithRed:118/255.0 green:123/255.0 blue:117/255.0 alpha:1];
                cell.numLab.textColor   = [UIColor colorWithRed:118/255.0 green:123/255.0 blue:117/255.0 alpha:1];
            }
        }
        return cell;
        
    }else
    {
        static NSString *simpleIdentify = @"SimpleIdentify";
        
        FiveMarketCell *cell = (FiveMarketCell *)[tableView dequeueReusableCellWithIdentifier:simpleIdentify];
        if (!cell) {
            cell = [[FiveMarketCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentify];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;//设置自定义单元格不能点击
        cell.priceLab.textColor = [UIColor colorWithRed:51/255.0 green:177/255.0 blue:51/255.0 alpha:1];
        if (indexPath.row == 0)
        {
            if (_buyState == 0)
            {
                cell.titleLab.textColor = [UIColor colorWithRed:118/255.0 green:123/255.0 blue:117/255.0 alpha:1];
                cell.numLab.textColor   = [UIColor colorWithRed:118/255.0 green:123/255.0 blue:117/255.0 alpha:1];
                
            }else
            {
                cell.titleLab.textColor = [UIColor colorWithRed:51/255.0 green:177/255.0 blue:51/255.0 alpha:1];
                cell.numLab.textColor   = [UIColor colorWithRed:51/255.0 green:177/255.0 blue:51/255.0 alpha:1];
            }
        }

//        [cell fillBuyWithData:buyArray[indexPath.row]];
       
        [cell fillSaleWithData:nil buyDic:saleArray[indexPath.row]];
        
        
        return cell;
    }

//    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 25*ScreenWidth/320;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    FiveMarketCell *cell = (FiveMarketCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [priceBtn setTitle:cell.priceLab.text forState:UIControlStateNormal];
    
//    UIView *viewLine = [cell viewWithTag:33333];
//    if (lastCell)
//    {
//        lastCell.titleLab.textColor = [UIColor lightGrayColor];
//    }
//
//    lastCell = cell;
//    
//    if (indexPath.section == 0)
//    {
//        viewLine.backgroundColor = [UIColor redColor];
//        cell.titleLab.textColor = [UIColor redColor];
//    }else
//    {
//        viewLine.backgroundColor = [UIColor greenColor];
//        cell.titleLab.textColor = [UIColor greenColor];
//    }
}

- (void)dealloc
{
    NSLog(@"ceshi");
}

@end
