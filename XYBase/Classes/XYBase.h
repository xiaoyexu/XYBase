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

@interface XYBase : NSObject

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

+(XYProcessResult*)failureWithType:(NSString*)type andError:(NSString*)error;

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

/*
 Customizing method for correct response returned
 */
-(void)handleCorrectResponse:(XYProcessResult*) result;

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
 The class represent a option item, contains image view, option name and text
 */
#pragma mark XYOptionTvcItem
@interface XYOptionTvcItem : XYBaseTvcItem
@property(nonatomic, strong) NSString* imgName;
@property(nonatomic, strong) NSString* optionName;
@property(nonatomic, strong) NSString* optionText;
@end


/*
 All table view controller in this app should inherit this base class
 */
#pragma mark XYBaseTableVc
@interface XYBaseTableVc : UITableViewController
{
@protected
    NSArray* sections;
}
// The title of alert view
@property (strong, nonatomic) NSString* busyProcessTitle;
// The flag whether alert need to be shown
@property (nonatomic) BOOL showActivityIndicatorView;
@property (nonatomic) BOOL enableRefresh;

-(void)turnOnBusyFlag;
-(void)turnOffBusyFlag;

// Callback for any time consuming task
-(void)performBusyProcess:(XYProcessResult*(^)(void))block;
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

