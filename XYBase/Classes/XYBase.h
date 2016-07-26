//
//  XYBase.h
//  XYBase
//
//  Created by 徐晓烨 on 16/6/16.
//  Copyright © 2016年 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "objc/runtime.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <CommonCrypto/CommonCryptor.h>
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonDigest.h>
//#import "GTMBase64.h"

#define LS(str) NSLocalizedString(str, str)

@interface XYBase : NSObject

@end

#pragma mark XYUtility
@interface XYUtility : NSObject

/**
 Check whether connect to network
 */
+(BOOL)isConnectedToNetwork;

/**
 Check whether a NSString is nil or blank
 */
+(BOOL)isBlank:(NSString*)field;

/**
 Return match string list of given regular expression
 This method will return all matched string part
 The express can be ".*(abc.*).*", string matched in group (abc...) will be saved in return list
 */
+(NSArray*)matchStringListOfString:(NSString*)str matchRegularExpression:(NSString*)regStr;

/**
 Set title in navigation item
 Font and color taken from XYSkinManager
 navigationBarTitleFont and navigationBarTitleColor
 */
+(void)setTitle:(NSString*)title inNavigationItem:(UINavigationItem*)navigationItem;

/**
 Parse date string from source format to target format
 */
+(NSString*)convertDateFormatter:(NSString*)sourceFormatter targetFormatter:(NSString*)targetFormatter dateString:(NSString*)dateString;

/**
 Parse NSDate to NSString object
 */
+(NSString*)dateToString:(NSString*)formatter date:(NSDate*)date;

/**
 Parse NSString object to NSDate
 e.g.
 [Utility stringToDate:@"yyyy-MM-dd'T00:00:00' 'PT'HH'H'mm'M'ss'S'" dateString:dateStr]
 */
+(NSDate*)stringToDate:(NSString*)formatter dateString:(NSString*)dateStr;

//+(NSString*)encrypt:(NSString*)plainText key:(NSString*)key initVect:(NSString*)iv;
//+(NSString*)decrypt:(NSString*)encryptText key:(NSString*)key initVect:(NSString*)iv;

+(void)drawDashedLineOnView:(UIView*) view from:(CGPoint) from to:(CGPoint)to;

+(NSString*)maskPhoneNumber:(NSString*)phoneNumber;

/**
 Check if target string matches regular expression
 */
+(BOOL)isString:(NSString*) str matchRegularExpression:(NSString*)regStr;
@end

#pragma mark XYProcessResult
@interface XYProcessResult : NSObject
/**
 Flag whether process result is success
 */
@property (nonatomic) BOOL success;

/**
 NSString value for process type
 */
@property (nonatomic) NSString* type;

/**
 NSDictionary for parameters
 */
@property (nonatomic,strong) NSDictionary* params;

/**
 NSString for which segue identifier is used
 */
@property (nonatomic,strong) NSString* forwardSegueIdentifer;

/**
 Initalization method
 */
-(id)init;

/**
 Static method to create a success ProcessResult object
 */
+(XYProcessResult*)success;

+(XYProcessResult*)successWithType:(NSString*)type;
/**
 Static method to create a failure ProcessResult object
 */
+(XYProcessResult*)failure;

+(XYProcessResult*)failureWithType:(NSString*)type;

+(XYProcessResult*)failureWithError:(NSString*) error;

+(XYProcessResult*)failureWithType:(NSString*)type andError:(NSString* )error;

@end

/*
 All non-table view controller in this app should inherit this base class
 */
#pragma mark XYBaseVc
@interface XYBaseVc : UIViewController
// The title of alert view
@property (strong, nonatomic) NSString* busyProcessTitle;

// The flag whether alert need to be shown
@property (nonatomic) BOOL showActivityIndicatorView;


-(void)turnOnBusyFlag;
-(void)turnOffBusyFlag;

// Callback for any time consuming task
-(void)performBusyProcess:(XYProcessResult*(^)(void))block;


-(void)performBusyProcess:(XYProcessResult*(^)(void))block busyFlag:(BOOL)flag completion:(void (^)(XYProcessResult* result))completion;

/*
 Customizing method for correct response returned
 */
-(void)handleCorrectResponse:(XYProcessResult*)result;

/*
 Customizing method for error response returned
 */
-(void)handleErrorResponse:(XYProcessResult*) result;
@end

#pragma mark XYSelectorObject
@interface XYSelectorObject : NSObject
{
@protected
    NSValue* _selectorValue;
    id _target;
}

/**
 Object that passed to selector
 */
@property (nonatomic,strong) id object;

/**
 Initialization method with selector and target
 @param selector Normal iOS selector
 @param target Object where selector will be called on
 */
-(id)initWithSEL:(SEL)selector target:(id)target;

/**
 Execute selector
 */
-(void)performSelector;
@end

/*
 The class is used to represent an item in tabel view cell.
 */
#pragma mark XYBaseTvcItem
@interface XYBaseTvcItem : NSObject
// Table view cell identifier
@property(nonatomic, strong) NSString* identifier;
// Customized view if needed
@property(nonatomic, strong) UIView* view;
// Height of the cell
@property(nonatomic) CGFloat height;
/**
 Logic for button clicked
 */
@property (nonatomic, readonly) XYSelectorObject*  onClickSelector;

/*
 Block for render cell
 */
@property (nonatomic, strong) UITableViewCell* (^tableViewCellForRowAtIndexPath)(UITableView* tableView, UITableViewCell* baseCell, NSIndexPath* indexPath);
-(id)initWithIdentifer:(NSString*)identifier;
-(id)initWithIdentifer:(NSString*)identifier view:(UIView*)view;
-(id)initWithIdentifer:(NSString*)identifier view:(UIView*)view height:(CGFloat) height;
-(void)addTarget:(id)target action:(SEL) selector;
@end

/*
 All table view controller in this app should inherit this base class
 */
#pragma mark XYBaseTableVc
@interface XYBaseTableVc : UITableViewController
{
@protected
    NSArray* sections;
    UIView* _noDataView;
}
// The title of alert view
@property (strong, nonatomic) NSString* busyProcessTitle;
// The flag whether alert need to be shown
@property (nonatomic) BOOL showActivityIndicatorView;
@property (nonatomic) BOOL enableRefresh;
@property(nonatomic, strong) IBOutlet UIView* noDataView;
-(void)setNoDataViewHidden:(BOOL)hidden;
-(void)turnOnBusyFlag;
-(void)turnOffBusyFlag;

// Callback for any time consuming task
-(void)performBusyProcess:(XYProcessResult*(^)(void))block;

-(void)performBusyProcess:(XYProcessResult*(^)(void))block busyFlag:(BOOL)flag completion:(void (^)(XYProcessResult* result))completion;

-(void)refresh:(UIRefreshControl*)refreshControl;
/*
 Customizing method for correct response returned
 */
-(void)handleCorrectResponse:(XYProcessResult*) result;
/*
 Customizing method for error response returned
 */
-(void)handleErrorResponse:(XYProcessResult*) result;

@end

#pragma mark XYBaseNavigationVc
@interface XYBaseNavigationVc : UINavigationController
@end

#pragma mark XYBaseTabBarVc
@interface XYBaseTabBarVc : UITabBarController
@end


#pragma mark XYCoreDataConnector
@interface XYCoreDataConnector : NSObject
{
    NSString* _modelName;
    NSString* _storeName;
}

/**
 Store file name. E.g somefile.sqlite
 Do not include any path in store name
 */
@property (nonatomic,readonly) NSString* storeName;

/**
 The xcdatamodeld name, without extension
 */
@property (nonatomic,readonly) NSString* modelName;

@property (nonatomic, readonly) NSPersistentStoreCoordinator*persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectContext*managedObjectContext;
@property (nonatomic, readonly) NSManagedObjectModel*managedObjectModel;

/**
 Initialization method
 */
-(id)init;

/**
 Initialization method with model and file name
 @param model Model name
 @param name Store file name
 */
-(id)initWithModelName:(NSString*)model storeName:(NSString*) name;

/**
 @return document directory
 */
-(NSURL*)applicationDocumentsDirectory;

/**
 Method to save context for entities
 */
-(void)saveContext;

/**
 Method to reset data file
 */
-(void)resetPersistentStore;

/**
 Get list of entity by predicater, allow only one parameter
 */
-(NSArray*)getObjectsFromDatabase: (Class) className WithPredicate: (NSString *) predicateString AndParameter: (NSString*) predicateParameter;

/**
 Get single one entity by predicater, with one parameter
 */
-(NSManagedObject*)getSingleObjectFromDatabase: (Class) className WithPredicate: (NSString *) predicateString AndParameter: (NSString *) predicateParameter;

/**
 Get list of entity by predicater with multiply parameters
 */
-(NSArray*)getObjectsFromDatabase: (Class) className WithPredicate: (NSString *) predicateString AndParameterArray: (NSArray *) predicateParameterArr;

/**
 Get single one entity by predicater with multiply parameters
 */
-(NSManagedObject*)getSingleObjectFromDatabase: (Class) className WithPredicate: (NSString *) predicateString AndParameterArray: (NSArray *) predicateParameterArr;

/**
 Get new entity
 */
-(NSManagedObject*)getNewObjectForInsertByClass:(Class)className;
@end

#pragma mark XYCoreDataManager
@interface XYCoreDataManager : NSObject
/**
 Static method to get instance
 */
+(XYCoreDataManager*)instance;

/**
 Create and cache the core data connector
 @param model Model name
 @param name Store file name
 @param alias Alias for the connector
 */
-(void)initCoreDataConnectorWithModel:(NSString*) model storeName:(NSString *)name asAlias:(NSString*)alias;

/**
 Get CoreDataConnector by alias name, always returnning a new instance/context
 */
-(XYCoreDataConnector*)connectorByAlias:(NSString*)alias;

/**
 Get XYCoreDataConnector by alias name
 */
-(XYCoreDataConnector*)connectorByAlias:(NSString*)alias newContext:(BOOL) newContext;

/**
 Remove connector
 */
-(void)removeConnectorByAlias:(NSString*)alias;

/**
 Remove all connectors
 */
-(void)removeAllConnectors;
@end


#pragma mark XYRequest
@interface XYRequest : NSObject
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSDate* requestTime;
@property (nonatomic, strong) NSMutableDictionary* bodyDict;
-(id)init;
@end

#pragma mark XYResponse
@interface XYResponse : NSObject
@property (nonatomic) NSUInteger responseCode;
@property (nonatomic) NSString* responseDesc;
@end

#pragma mark XYHTTPRequestObject
@interface XYHTTPRequestObject : NSObject
@property(nonatomic, strong) NSURL* requestURL;
@property(nonatomic) NSURLRequestCachePolicy policy;
@property(nonatomic) NSTimeInterval timeout;
@property(nonatomic) NSString* httpMethod;
@property(nonatomic) NSDictionary* headers;
@property(nonatomic) NSData* body;
@end

#pragma mark XYHTTPResponseObject
@interface XYHTTPResponseObject : NSObject
@property(nonatomic,strong, readonly) NSData* data;
@property(nonatomic,strong, readonly) NSURLResponse* response;
-(id)initWithData:(NSData*)data urlResponse:(NSURLResponse*)response;
@end

#pragma mark XYConnectionDelegate
@protocol XYConnectionDelegate <NSObject>

-(XYHTTPResponseObject*)sendRequest:(XYHTTPRequestObject*)reqObj;

@end

#pragma mark XYConnection
@interface XYConnection : NSObject<XYConnectionDelegate,NSURLConnectionDataDelegate>
@property(nonatomic) BOOL enableEncryptionBy3DES;
@property(nonatomic, strong) NSString* key24;
@property(nonatomic, strong) NSString* vector8;
/**
 This is synchronous method
 */
-(XYHTTPResponseObject*)sendRequest:(XYHTTPRequestObject*)reqObj;
@end

#pragma mark XYConnector
@interface XYConnector : NSObject
@property (nonatomic, readonly) NSURL* url;
@property (nonatomic, strong) XYConnection* connection;
/**
 Initialization method
 */
-(id)init;


-(id)initWithConnector:(XYConnector*)connector;

/**
 Init method with URL. URL should be full path
 The mode SALConnectorModeGateway will be set as default
 @param url Full url string. E.g "https://server/services"
 */
-(id)initWithURL:(NSString*)url;

/**
 Init method with URL and flag for connection test
 The mode SALConnectorModeGateway will be set as default
 @param url Full url string. E.g "https://server/services"
 @param connect If YES try connect immediately for service document and metadata
 */
//-(id)initWithURL:(NSString*)url connectNow:(BOOL) connect;

/**
 Refresh connector by url
 @param url Full url string. E.g "https://server/services"
 */
-(void)refreshWithURL:(NSString *)url;

/**
 Connect now to get service document, metadata
 */
-(void)connectNow;
@end

#pragma mark XYConnectorManager
@interface XYConnectorManager : NSObject
/**
 Singleton method to get ConnectorManager
 */
+(XYConnectorManager*)instance;

/**
 Create the Connector
 */
-(void)initConnectorWithURL:(NSString *)url asAlias:(NSString*)alias;

/**
 Refresh gateway by url
 */
-(void)refreshConnectorWithURL:(NSString *)url forAlias:(NSString*)alias;
/**
 Get Connector by alias name
 */
-(XYConnector*)connectorByAlias:(NSString*)alias;

/**
 Get a new Connector by alias name
 */
-(XYConnector*)newConnectorByAlias:(NSString*)alias;

/**
 Add connector
 */
-(void)addConnector:(XYConnector*) connector asAlias:(NSString*) alias;
/**
 Remove connector
 */
-(void)removeConnectorByAlias:(NSString*)alias;

/**
 Remove all connectors
 */
-(void)removeAllConnectors;
@end

#pragma mark XYMessageAgent
@protocol XYMessageAgent <NSObject>
-(void)normalize:(XYRequest*)request to:(XYHTTPRequestObject*) requestObj;
-(void)deNormalize:(XYHTTPResponseObject*)responseObj to:(XYResponse**)response;
@optional
-(XYResponse*)demoResponse;
@end

@interface XYMessageAgent : NSObject<XYMessageAgent>

@end

#pragma mark XYMessageEngineDelegate
typedef enum {
    MessageStageDemo,
    MessageStageDevelopment,
    MessageStageProduction,
} MessageStage;

@protocol XYMessageEngineDelegate<NSObject>

@optional
/**
 If logging is turn on, this method will be called to log request/response information
 */
-(void)log:(NSString*)logString;

@end

/**
 Message configuration for a single message
 */
#pragma mark XYMessageConfig
@interface XYMessageConfig : NSObject
@property (nonatomic, strong) NSString* relativePath;
@property (nonatomic, strong) NSString* httpMethod;

-(id)initWithPath:(NSString*)path method:(NSString*)method;
@end

#pragma mark XYMessageEngine
@protocol XYMessageEngine<NSObject>
-(XYResponse*)send:(XYRequest*)request;
@end

@interface XYMessageEngine : NSObject<XYMessageEngine>
/**
 Indicator which stage message engine is running
 */
@property (nonatomic) MessageStage runningStage;

/**
 Message stage mapping
 */
@property (nonatomic, readonly) NSMutableDictionary* messageStage;

/**
 Message relative url mapping
 Domain is defined by XYConnector, e.g. www.test.com
 Relative url is defined by each message, e.g.
 www.test.com/Login   <-> LoginRequest
 
 */
@property (nonatomic, readonly) NSMutableDictionary* messageConfigMapping;

/**
 Delegate
 */
@property (nonatomic, strong) id<XYMessageEngineDelegate> delegate;

/**
 Singleton instance
 */
+(XYMessageEngine*)instance;

/**
 Set connector for stage
 */
-(void)setConnector:(XYConnector*)connector forStage:(MessageStage)stage;

/**
 Remove connector
 */
-(void)removeConnectorOfStage:(MessageStage)stage;

/**
 Set config for message
 */
-(void)setConfig:(XYMessageConfig*)config forMessage:(Class)messageClass;

-(void)setConfigPath:(NSString*)path method:(NSString*)method forMessage:(Class)messageClass;
/**
 Remove config
 */
-(void)removeConfigOfMessage:(Class)messageClass;
@end

#pragma mark NSString+category
@interface NSString (category)
-(NSString*)md5;
-(NSString*)sha1;
// Uncomment below if GTMBase64.h imported
//-(NSString*)sha1_base64;
//-(NSString*)md5_base64;
//-(NSString*)base64;
-(NSString*)trim;
@end

@interface UIColor (Hex)
+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
@end

#pragma mark UIView controllers
@interface XYUISegmentedControl : UISegmentedControl
@property (nonatomic, strong) UIView* selectedView;
@property (nonatomic, strong) UIView* separateView;
@property (nonatomic, strong) UIColor* selectedFontColor;
@property (nonatomic, strong) UIColor* unSelectedFontColor;
@property (nonatomic, strong) UIFont* selectedTitleFont;
@property (nonatomic, strong) UIFont* unSelectedTitleFont;
-(id)init;
-(id)initWithFrame:(CGRect)frame;
-(id)initWithItems:(NSArray *)items;
-(void)renderView;
@end

typedef enum {
    SortTypeAscending,
    SortTypeDescending,
    SortTypeNone,
} SortType;

@interface XYSortUIButton : UIButton
@property(nonatomic) SortType sortType;
@property(nonatomic, strong) UIImage* ascendingImg;
@property(nonatomic, strong) UIImage* descendingImg;
@property(nonatomic, strong) UIImage* noneSortImg;
-(void)renderView;
@end

typedef enum {
    SelectTypeSelected,
    SelectTypeDeselected
} SelectType;

@interface XYSelectUIButton : UIButton
@property(nonatomic) SelectType selectType;
@property(nonatomic, strong) UIImage* selectedImg;
@property(nonatomic, strong) UIImage* deselectedImg;
-(void)renderView;
@end


@interface XYImageUIButton : UIButton
@property(nonatomic, strong, readonly) UIImageView* buttonImageView;
@property(nonatomic, strong, readonly) UILabel* buttonLabel;
@property(nonatomic) CGSize buttonImageViewSize;
@end


@interface XYStarRatingView : UIView
@property(nonatomic) CGSize imageSize;
@property(nonatomic, strong) UIImage* selectedImage;
@property(nonatomic, strong) UIImage* unSelectedImage;
@property(nonatomic) NSInteger totalNumber;
@property(nonatomic) NSInteger currentNumber;
-(void)renderView;
@end

@interface XYRotatingView : UIView
@property (nonatomic, readonly,getter = isAnimating) BOOL animating;
@property(nonatomic, strong, readonly) UIView* spinningView;
@property(nonatomic) CGFloat rotateDuration;
-(void)startAnimating;
-(void)stopAnimating;
@end

#pragma mark Select options
typedef enum {
    SignTypeInclude,
    SignTypeExclude,
} SignType;


typedef enum {
    OptionTypeEQ,
    OptionTypeNE,
    OptionTypeCS,
    OptionTypeNC,
    OptionTypeGT,
    OptionTypeGE,
    OptionTypeLT,
    OptionTypeLE,
    OptionTypeBT,
} OptionType;

/**
 This class represents a selection which has sign, option, low value and high value
 */
@interface XYSelectOption : NSObject <NSCoding>

/**
 Sign field. E.g. I or E
 */
@property (nonatomic) SignType sign;

/**
 Option field. E.g BT or EQ
 */
@property (nonatomic) OptionType option;

/**
 Low value
 */
@property (nonatomic,strong) NSString* lowValue;

/**
 High value
 */
@property (nonatomic,strong) NSString* highValue;

/**
 Initialization method with sign,option,low value and high value
 @param sign Sign to set
 @param option Option to set
 @param lowValue Low value to set
 @param highValue High value to set
 */
-(id)initWithSign:(SignType)sign option:(OptionType) option lowValue:(NSString*)lowValue highValue:(NSString*)highValue;

/**
 isEqual method is overriden in order to compare 2 selection
 XYSelectOption object is equal only when sign,option,low value and high value are all eqal
 */
-(BOOL)isEqual:(id)object;

/**
 hash method is overriden in order to compare 2 XYSelectOption objects
 */
-(NSUInteger)hash;
@end

/**
 This class represents a single field selection options
 E.g.
 Name     I   EQ  Tom
 I   EQ  Jerry
 ...
 Or
 Birthday  I   EQ  2000.1.1
 I   BT  2002.2.2   2004.4.4
 I   LE  1990.1.1
 ...
 */
@interface XYFieldSelectOption : NSObject <NSCoding>
{
    NSMutableSet* _selectOptions;
}
/**
 Field name
 */
@property (nonatomic,strong) NSString* property;

/**
 NSSet of XYSelectOption object
 */
@property (nonatomic,strong) NSSet* selectOptions;

/**
 Initialization method
 */
-(id)init;

/**
 Initialization method with property and initial selection
 */
-(id)initWithProperty:(NSString*) property andSelectOption:(XYSelectOption*)option;

/**
 Initialization method with property and initial sign, option, low value, high value
 */
-(id)initWithProperty:(NSString*) property andSelectOptionSign:(SignType)sign option:(OptionType) option lowValue:(NSString*)lowValue highValue:(NSString*)highValue;

/**
 Initialization method with property and selection set
 The set should contain XYSelectOption instance
 */
-(id)initWithProperty:(NSString*) property andSelectOptionSet:(NSSet*)options;

/**
 Add selection object
 @param so Selection option to add
 */
-(void)addSelectOption:(XYSelectOption*)so;

/**
 Add selection object
 */
-(void)addSelectOptionSign:(SignType)sign option:(OptionType) option lowValue:(NSString*)lowValue highValue:(NSString*)highValue;

/**
 Set single selection object
 @param so Selection option to set
 */
-(void)setSingleSelectOption:(XYSelectOption*)so;

/**
 Remove selection object
 @param so Selection option to remove
 */
-(void)removeSelectOption:(XYSelectOption*)so;

/**
 Remove all selection object
 */
-(void)clearSelectOption;

/**
 Return in dictionary
 Format as follows:
 {
  "field": "<property name>",
  "options": [
    {
       "sign":"I",
       "option":"eq",
       "low": "<low value>",
       "high": "<high value>"
    },
    {...},...
  ]
 }
 Notice, multiple entries in options means "or"
 */
-(NSDictionary*)dictionaryRepresentation;
@end


@interface XYSearchBuilder : NSObject
@property (nonatomic, strong) NSArray* orderBy;
@property (nonatomic) SortType sortType;
-(void)addFieldSelectOption:(XYFieldSelectOption*)so;

/**
 Return in dictionary 
 Format as follows:
 {
   "and" : [
     {
       "field": "<property name>",
        "options": [
        {
        "sign":"I",
        "option":"eq",
        "low": "<low value>",
        "high": "<high value>"
        },
        {...},...
        ]
      },{...},...
   ]
 }
 */
-(NSDictionary*)dictionaryRepresentation;
@end
