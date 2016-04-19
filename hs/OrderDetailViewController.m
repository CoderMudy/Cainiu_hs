


//
//  OrderDetailViewController.m
//  hs
//
//  Created by hzl on 15/5/8.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderRecordDataModels.h"
#import "SaleOrderDataModels.h"

@interface OrderDetailViewController ()


@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *statusValue;
@property (weak, nonatomic) IBOutlet UILabel *gainLab;
@property (weak, nonatomic) IBOutlet UILabel *lossLab;
@property (weak, nonatomic) IBOutlet UILabel *orderType;
@property (weak, nonatomic) IBOutlet UILabel *operateAmtLab;
@property (weak, nonatomic) IBOutlet UILabel *stockNameLab;
@property (weak, nonatomic) IBOutlet UILabel *quantityLab;
@property (weak, nonatomic) IBOutlet UILabel *lossFundLab;
@property (weak, nonatomic) IBOutlet UILabel *lossFundMarkLab;

@property (weak, nonatomic) IBOutlet UILabel *orderIdLab;
@property (weak, nonatomic) IBOutlet UILabel *createDataLab;
@property (weak, nonatomic) IBOutlet UILabel *buyDateLab;

@property (weak, nonatomic) IBOutlet UILabel *buyPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLab;
@property (weak, nonatomic) IBOutlet UILabel *finishDataLab;

@end

@implementation OrderDetailViewController

-(void )updateUI
{
    
    OrderRecordBaseClass * newOrderModel ;
    SaleOrderBaseClass * saleOrderModel;
    if ([_source isEqualToString:@"newOrder"]) {
        
        
        
        
        saleOrderModel = [SaleOrderBaseClass modelObjectWithDictionary:_dic];
        
        if (saleOrderModel.lossProfit>0) {
            self.gainLab.text       = [NSString stringWithFormat:@"%.2f",saleOrderModel.lossProfit];
            self.statusValue.textColor = K_COLOR_CUSTEM(250, 67, 0, 1);
            self.lossLab.textColor  = K_COLOR_CUSTEM(8, 186, 66, 1);
            
            
        }else{
            self.statusValue.textColor = K_COLOR_CUSTEM(8, 186, 66, 1);
            
            self.gainLab.text       = @"0.00";
            self.lossLab.text       = [NSString stringWithFormat:@"%.2f",saleOrderModel.lossProfit];
            self.gainLab.textColor                 = K_COLOR_CUSTEM(8, 186, 66, 1);
        }
        
        self.operateAmtLab.textColor =  self.statusValue.textColor;
        self.lossFundLab.textColor  =  self.statusValue.textColor;
        float width = [Helper calculateTheHightOfText: self.lossFundLab.text height:13 font:[UIFont systemFontOfSize:13]];
        self.lossFundLab.frame = CGRectMake(94, 263, width, 21);
        self.lossFundMarkLab.frame = CGRectMake(self.lossFundLab.frame.origin.x+self.lossFundLab.frame.size.width, self.lossFundLab.frame.origin.y, 100, 21);
        NSString * lossFundMarkLabText;
        if (saleOrderModel.buyType==0) {
            lossFundMarkLabText = [NSString stringWithFormat:@"(含手续费%.2f元)",saleOrderModel.counterFee];
            
        }else{
            
            lossFundMarkLabText = [NSString stringWithFormat:@"(含手续费%.2f积分)",saleOrderModel.counterFee];
            
            
        }
        self.lossFundMarkLab.text = lossFundMarkLabText;
        
        self.orderType.text     = saleOrderModel.buyType==0?@"现金买入":@"积分买入";
        self.operateAmtLab.text = [NSString stringWithFormat:@"%.2f",saleOrderModel.amt ];
        self.stockNameLab.text  = saleOrderModel.stockCom;
        self.quantityLab.text   = [NSString stringWithFormat:@"%.2f",saleOrderModel.quantity ];
        self.lossFundLab.text   = [NSString stringWithFormat:@"%.2f",saleOrderModel.lossAmt];
        self.orderIdLab.text    = [NSString stringWithFormat:@"%.0f",saleOrderModel.orderId];
        self.createDataLab.text = saleOrderModel.createDate;
        self.buyDateLab.text = saleOrderModel.createDate;
        self.buyPriceLab.text   = [NSString stringWithFormat:@"%.2f",saleOrderModel.buyPrice];
        self.salePriceLab.text  = [NSString stringWithFormat:@"%.2f",saleOrderModel.salePrice];
        self.finishDataLab.text = saleOrderModel.finishDate;
        
        self.statusValue.text = [NSString stringWithFormat:@"%.2f",saleOrderModel.lossProfit];
        
        
        
        
        
        
        
        
    }else if([_source isEqualToString:@"orderDetail"]){
        
//订单详情从持仓股票详情界面进入
//        
//        self.gainLab.text = @"暂无";
//        self.lossLab.text = @"暂无";
//        self.finishDataLab.text = @"暂无";
//        
//        self.statusValue.text = _curCashProfit;
//        
//        if (_curCashProfit.floatValue>=0) {
//            
//            self.statusValue.textColor = K_COLOR_CUSTEM(250, 67, 0, 1);
//           
//        }else{
//            
//            self.statusValue.textColor = K_COLOR_CUSTEM(8, 186, 66, 1);
//        }
//        self.operateAmtLab.textColor =  self.statusValue.textColor;
//        self.lossFundLab.textColor  =  self.statusValue.textColor;
//        
//        self.orderType.text     = _posiBolist.fundType==0?@"现金买入":@"积分买入";
//        self.operateAmtLab.text = [NSString stringWithFormat:@"%.2f",_posiBolist.operateAmt ];
//        self.stockNameLab.text  = _posiBolist.stockName;
//        self.quantityLab.text   = [NSString stringWithFormat:@"%@",_posiBolist.factBuyCount ];
//        self.lossFundLab.text   = [NSString stringWithFormat:@"%.2f",_posiBolist.lossFund];
//        
//        float width = [Helper calculateTheHightOfText: self.lossFundLab.text height:13 font:[UIFont systemFontOfSize:13]];
//        self.lossFundLab.frame = CGRectMake(94, 263, width, 21);
//        self.lossFundMarkLab.frame = CGRectMake(self.lossFundLab.frame.origin.x+self.lossFundLab.frame.size.width, self.lossFundLab.frame.origin.y, 100, 21);
//        NSString * lossFundMarkLabText;
//        if (_posiBolist.buyType==0) {
//            lossFundMarkLabText = [NSString stringWithFormat:@"(含手续费%.2f元)",_posiBolist.counterFee];
//            
//        }else{
//            
//            lossFundMarkLabText = [NSString stringWithFormat:@"(含手续费%.2f积分)",_posiBolist.counterFee];
//            
//            
//        }
//        self.lossFundMarkLab.text = lossFundMarkLabText;
//        self.orderIdLab.text    = [NSString stringWithFormat:@"%.0f",_posiBolist.orderId];
//        self.createDataLab.text = _posiBolist.createDate;
//        self.buyDateLab.text  = _posiBolist.createDate;
//        self.buyPriceLab.text   = [NSString stringWithFormat:@"%.2f",_posiBolist.buyPrice];
//        self.salePriceLab.text  = @"暂无";
//        
//        
//        
        
        
        
        
    }else//持有中
    {
        newOrderModel = [OrderRecordBaseClass modelObjectWithDictionary:_dic];
        NSString * statusValueText = [NSString stringWithFormat:@"%@元",_curCashProfit];
        
        self.statusValue.text = statusValueText;
        if (_isSale) {
            
            
            
            if (_curCashProfit.floatValue<0) {
                
                
                self.gainLab.text       = @"0.00";
                self.lossLab.text = self.statusValue.text;
                self.statusValue.textColor = K_COLOR_CUSTEM(8, 186, 66, 1);
                self.lossLab.textColor  =K_COLOR_CUSTEM(8, 186, 66, 1);
            }else{
                self.gainLab.text       = self.statusValue.text;
                self.statusValue.textColor = K_COLOR_CUSTEM(250, 67, 0, 1);
                
                self.gainLab.textColor  =  K_COLOR_CUSTEM(250, 67, 0, 1);
                self.lossLab.text       = @"0.00";
                
            }
            self.finishDataLab.text = newOrderModel.finishDate;
            self.salePriceLab.text  = newOrderModel.salePrice;
            
        }else{
            
            self.gainLab.text = @"暂无";
            self.gainLab.textColor = self.lossLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
            self.lossLab.text = @"暂无";
            self.finishDataLab.text = @"暂无";
            
            
        }
        self.gainLab.textColor  = K_COLOR_CUSTEM(250, 67, 0, 1);
        self.lossLab.textColor  = K_COLOR_CUSTEM(8, 186, 66, 1);
        self.operateAmtLab.textColor = self.gainLab.textColor;
        self.lossFundLab.textColor  = self.gainLab.textColor;
        NSString * str = [NSString stringWithFormat:@"%@",newOrderModel.buyType];
        self.orderType.text     = [str isEqualToString:@"0"]?@"现金买入":@"积分买入";
        self.operateAmtLab.text = newOrderModel.operateAmt;
        self.stockNameLab.text  = newOrderModel.stockName;
        self.quantityLab.text   = newOrderModel.quantity;
        self.lossFundLab.text   = newOrderModel.lossFund;
        
        float width = [Helper calculateTheHightOfText: self.lossFundLab.text height:13 font:[UIFont systemFontOfSize:13]];
        self.lossFundLab.frame = CGRectMake(94, 263, width, 21);
        self.lossFundMarkLab.frame = CGRectMake(self.lossFundLab.frame.origin.x+self.lossFundLab.frame.size.width, self.lossFundLab.frame.origin.y, 100, 21);
        NSString * lossFundMarkLabText;
        if ([newOrderModel.buyType isEqualToString:@"0"]) {
            lossFundMarkLabText = [NSString stringWithFormat:@"(含手续费%@元)",newOrderModel.counterFee];
            
        }else{
            
            lossFundMarkLabText = [NSString stringWithFormat:@"(含手续费%@积分)",newOrderModel.counterFee];
            
            
        }
        self.lossFundMarkLab.text = lossFundMarkLabText;
        self.orderIdLab.text    = [NSString stringWithFormat:@"%d",[newOrderModel.orderId intValue]];
        self.createDataLab.text = newOrderModel.createDate;
        self.buyDateLab.text = newOrderModel.createDate;
        self.buyPriceLab.text   = newOrderModel.buyPrice;
        self.salePriceLab.text  = @"暂无";
        
        //        float * value = (newOrderModel.curPrice.floatValue - newOrderModel.buyCount.floatValue)* newOrderModel.quantity.floatValue;
        //        self.statusValue.text = statusValueText;
        
        
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateUI];
    [self setTitle:@"交易记录"];
    if ([_source isEqualToString:@"record"]||[_source isEqualToString:@"orderDetail"]) {
        
        
        [self setNavLeftBut:NSPushMode];
        
    }else{
        [self setNavLeftBut:NSPushRootMode];
        
    }
    self.view.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
    
    self.title = @"订单详情";
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"股票行情"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick  beginLogPageView:@"股票行情"];
    
    self.rdv_tabBarController.tabBarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
