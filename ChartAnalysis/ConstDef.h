//
//  ConstDef.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-4.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#ifndef ChartAnalysis_ConstDef_h
#define ChartAnalysis_ConstDef_h



#endif

#define DATA_URL @"http://www.dailyfx.com.hk/inc/process.php"
#define BASE_URL @"http://www.dailyfx.com.hk/"


#define TABLE_SYMBOLS @"symbols"
#define TABLE_CODE @"code"
//#define TABLE_DATA @"data"
//#define TABLE_NEWS @"news"
#define TABLE_DATA @"finance_data"
#define TABLE_NEWS @"finance_news"

#define CHART_CANDLE 0
#define CHART_AREA 1
#define CHART_HISTOGRAM 2
#define CHART_CURVE 3
#define CHART_LINE 4

#define FILE_TYPE_MT4 @"MT4"
#define FILE_TYPE_TS2 @"TS2"

#define FINANCE_NEWS @"news"
#define FINANCE_DATA @"calendar"
#define FINANCE_MEETING @"meeting"

#define DEFAULT_CYCLE 120

#define MAT_NEWS 2
#define MAT_DATA 1
#define MAT_ALL 0

#define DAY_SEC (24*60*60)
#define HOUR12 (12*60*60)

#define NOTIFY_ANALYSIS_CALLBACK @"analysis_callback"
#define NOTIFY_MOVE_CHART_TO @"moveChartTo"
#define NOTIFY_ANALYSIS_LOG @"analysisLog"
#define NOTIFY_DATA_IMPORT_PROGRESS @"funDataProgress"
