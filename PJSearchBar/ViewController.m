//
//  ViewController.m
//  PJSearchBar
//
//  Created by 孙培杰 on 16/11/3.
//  Copyright © 2016年 sunpeijie. All rights reserved.
//

#import "ViewController.h"
#import "PJSearchBar.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,PJSearchBarDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;  //数据源
@property (nonatomic, strong) PJSearchBar *searchBar;      //搜索框
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, retain) NSMutableArray *resultArr;   //搜索结果
@property (nonatomic, assign) BOOL isSearch;               //判断是否在搜索
@property (nonatomic, strong) NSString *firstInputString;  //搜索第一个输入字母

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    [self addDataSource];
}


- (void)initSubviews{
    _searchBar = [[PJSearchBar alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 40) placeholder:@"搜索"];
    _searchBar.delegate = self;
    _searchBar.barTintColor = [UIColor redColor];
    [self.view addSubview:_searchBar];
    
    _searchText = @"";
    [self.view addSubview:self.tableView];
}

- (void)addDataSource{
    //添加数据源
    NSArray *dataArray = @[@[@"AA",@"AB",@"AC",@"AD",@"AE"],@[@"BA",@"BB",@"BC",@"BD",@"BE"],@[@"CA",@"CB",@"CC",@"CD",@"CE"],@[@"DA",@"DB",@"DC",@"DD",@"DE"],@[@"EA",@"EB",@"EC",@"ED",@"EE"],@[@"FA",@"FB",@"FC",@"FD",@"FE"],@[@"GA",@"GB",@"GC",@"GD",@"GE"],@[@"HA",@"HB",@"HC",@"HD",@"HE"],@[@"IA",@"IB",@"IC",@"ID",@"IE"],@[@"JA",@"JB",@"JC",@"JD",@"JE"],@[@"KA",@"KB",@"KC",@"KD",@"KE"]];
    [self.dataSource addObjectsFromArray:dataArray];
    [self.tableView reloadData];
}
#pragma mark TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isSearch) {
        return 1 ;
    }else{
        return self.dataSource.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSearch) {
        return self.resultArr.count ;
    }else{
        return [self.dataSource[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"oneCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (self.isSearch) {
        cell.textLabel.text = self.resultArr[indexPath.row];
    }else{
        cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    }
    return cell;
}

#pragma mark TableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //设置头标题

        NSArray *array = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K"];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        label.backgroundColor = [UIColor colorWithRed:255.f/255.f green:127.f/255.f blue:80.f/255.f alpha:1.0];
    
        if (_isSearch) {
            label.text = self.firstInputString;
        }else{
            label.text = array[section];
        }
        return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
/**
    添加右侧索引
 */
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (_isSearch) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [array addObject:self.firstInputString];
        return array;
    }else{
        return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        _searchText = @"";
        self.isSearch = NO;
        [self.tableView reloadData];
    }
    NSLog(@" --- %@",searchText);
    [_resultArr removeAllObjects];
    
    if (searchText.length == 1) {
        self.firstInputString = searchText;
    }
    for (NSArray *searchArray in self.dataSource) {
        for (NSString *searchStr in searchArray) {
            if ([searchStr rangeOfString:searchText].location != NSNotFound) {
                [self.resultArr addObject:searchStr];
            }
        }
    }
    if (_resultArr.count) {
        self.isSearch = YES;
        [self.tableView reloadData];
    }
}


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.isSearch = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    self.isSearch = NO;
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark LazyLoading
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, self.view.bounds.size.width, self.view.bounds.size.height - 104) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (NSMutableArray *)resultArr{
    if (!_resultArr) {
        _resultArr = [[NSMutableArray alloc]init];
    }
    return _resultArr;
}

@end
