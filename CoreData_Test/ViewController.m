//
//  ViewController.m
//  CoreData_Test
//
//  Created by 张大亮 on 16/1/25.
//  Copyright © 2016年 张大亮. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Student.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *DataArr;
//声明一个APPDelegate对象属性，来调用类中的属性
@property(nonatomic,strong)AppDelegate *myAPPDelegate;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _DataArr=[[NSMutableArray alloc]init];
    //单例
    self.myAPPDelegate=[UIApplication sharedApplication].delegate;
    
    //查询数据
    //1.创建一个NSFetchRequst对象，并设置查询实体的名字。
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"Student"];
    //2.设置排序
    //2.1创建排序描述对象,key代表对哪一个属性进行排序， ascending代表是否升序
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc]initWithKey:@"age" ascending:YES];
    //给NSFetchRequst设置排序描述
    request.sortDescriptors=@[descriptor];
    
    //执行查询请求
    NSError *error=nil;
    
    //查询的所有结果
    NSArray *result=[self.myAPPDelegate.managedObjectContext executeFetchRequest:request error:&error];
    //给数据源数组添加数据
    [self.DataArr addObjectsFromArray:result];
}
- (IBAction)addModel:(id)sender {
    //插入数据
    //创建实体描述对象
    NSEntityDescription *description=[NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.myAPPDelegate.managedObjectContext];
    //1.先创建一个模型对象
    Student *stu=[[Student alloc]initWithEntity:description insertIntoManagedObjectContext:self.myAPPDelegate.managedObjectContext];
    stu.name=@"FlyBig";
    int age=arc4random() %1000+1;
    stu.age=[NSNumber numberWithInt:age];
    
    //插入数据源数组中
    NSMutableArray *arr=[NSMutableArray arrayWithArray:_DataArr];
    [_DataArr removeAllObjects];
    [_DataArr addObject:stu];
    [_DataArr addObjectsFromArray:arr];
    
    //插入UI
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    
    //对数据管理器中的更改进行永久存储
    [self.myAPPDelegate saveContext];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _DataArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Student *stu=[_DataArr objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@-----%@",stu.name,stu.age];
    return cell;
    
}
//允许tableview可以编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//tableview编辑的方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //删除数据源
        Student *stu=[self.DataArr objectAtIndex:indexPath.row];
        [self.DataArr removeObject:stu];
        //        删除数据管理器中的数据  也就是coreData中的数据
        [self.myAPPDelegate.managedObjectContext  deleteObject:stu];
        //        将进行的更改进行永久保存.
        [self.myAPPDelegate saveContext];
        
        
        //删除单元格
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    }
}
//点击cell来实现内容的修改
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    1.先找到模型对象
    Student *stu=self.DataArr[indexPath.row];
    stu.name=@"daliang";
    //刷新单元行
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationBottom)];
    //通过saveContext方法对数据进行永久保存
    [self.myAPPDelegate saveContext];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
