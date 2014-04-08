//
//  QuizViewController.m
//  Quiz
//
//  Created by レー フックダイ on 4/6/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "QuizViewController.h"
#import "Problem.h"

@interface QuizViewController ()

@end

@implementation QuizViewController {
    NSMutableArray *problemSet;
    int totalProblems;
    int currentProblem;
    int correctAnswers;
    IBOutlet UITextView *problemText;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // クイズ問題を読み込み
    [self loadProblemSet];
    
    // クイズ問題をランダムに並び変え
    [self shuffleProblemSet];
    
    // 提示問題数を10問とする
    totalProblems = 10;
    
    // 現在の問題番号を正答数を0にする
    currentProblem = 0;
    correctAnswers = 0;
    
    // problemSetの最初の要素の問題文をクイズ画面にセット
    problemText.text = [[problemSet objectAtIndex:currentProblem] getQ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadProblemSet {
    
    // ファイルの読み込み
    NSString *path = [[NSBundle mainBundle] pathForResource:@"quiz" ofType:@"csv"];
    NSError *error = nil;
    int enc = NSUTF8StringEncoding;
    NSString *text = [NSString stringWithContentsOfFile:path encoding:enc error:&error];
    
    // 行ごとに分割し、配列「lines」に格納
    NSArray *lines = [text componentsSeparatedByString:@"\n"];
    
    // 問題を格納する可変配列problemSetを初期化
    problemSet = [[NSMutableArray alloc] init];
    
    // 問題の数だけ繰り返し
    for (int i = 0; i < [lines count]; i++) {
        // 問題をカンマで区切って、要素を配列「items」に格納
        NSArray *items = [[lines objectAtIndex:i] componentsSeparatedByString:@","];
        
        // Problemクラスのインスタンスを生成・初期化し、問題文と答えを格納
        Problem *p = [Problem initProblem];
        NSString *q = [items objectAtIndex:0];
        int a = [[items objectAtIndex:1] intValue];
        [p setQ:q withA:a];
        
        // 新たに生成したProblemクラスのインスタスをproblemSetに追加
        [problemSet addObject:p];
    }
}

- (void)shuffleProblemSet {
    // problemSetに格納された全問題の数を習得
    int totalQuestions = (int)[problemSet count];
    
    // Fisher-Yates algorithm用のcounterを習得
    int i = totalQuestions;
    
    // Fisher-Yates algorithmによって配列の要素をシャッフル
    while (i>0) {
        srand((unsigned int)time(0));
        int j = rand()%i;
        [problemSet exchangeObjectAtIndex:(i-1) withObjectAtIndex:j];
        i--;
    }
}

- (void)nextProblem {
    currentProblem++;
    
    if (currentProblem < totalProblems)
        problemText.text = [[problemSet objectAtIndex:currentProblem] getQ];
    else
        [self performSegueWithIdentifier:@"toResultView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // 正答率を算出
    int percentage = (correctAnswers * 100 / totalProblems);
    if ([[segue identifier] isEqualToString:@"toResultView"]) {
        ResultViewController *rvc = (ResultViewController*)[segue destinationViewController];
        rvc.correctPercentage = percentage;
    }
}

// 「◯」ボタンが押された場合
- (IBAction)answerIsTrue:(id)sender {
    if ([[problemSet objectAtIndex:currentProblem] getA] == 0) {
        correctAnswers++;
    }
    [self nextProblem];
}

// 「×」ボタンが押された場合
- (IBAction)answerIsFalse:(id)sender {
    if ([[problemSet objectAtIndex:currentProblem] getA] == 1) {
        correctAnswers++;
    }
    [self nextProblem];
}


@end




























