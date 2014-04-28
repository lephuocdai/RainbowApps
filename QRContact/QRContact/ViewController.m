//
//  ViewController.m
//  QRContact
//
//  Created by レー フックダイ on 4/27/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    IBOutlet UIImageView *barcodeImageView;
    IBOutlet UITextView *barcodeResults;
    NSString *barcodeString;
    Contact *contactInfo;
    ZBarReaderViewController *reader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarnin {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBAction
- (IBAction)scan:(id)sender {
    reader = [ZBarReaderViewController new];
    reader.readerDelegate = (id)self;
    reader.readerView.zoom = 1.0;
    [self presentViewController:reader animated:YES completion:nil];
}

- (IBAction)addContact:(id)sender {
    if (contactInfo == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"barcodeを読み込んでください"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    // 電話帳を開く
    NSLog(@"%@", [self description]);
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(iPhoneAddressBook, ^(bool granted, CFErrorRef error) {
            if (granted)
                [self registContact:iPhoneAddressBook];
        });
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
        [self registContact:iPhoneAddressBook];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    barcodeImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    id <NSFastEnumeration> symbols = [info objectForKey:ZBarReaderControllerResults];
    for (ZBarSymbol *symbol in symbols) {
        barcodeString = symbol.data;
        break;
    }
    [reader dismissViewControllerAnimated:YES completion:nil];
    [self determineType];
}

- (void)determineType {
    // Docomoの正規表現
    NSString *patternDocomo = @"^(MECARD:N:)";
    NSRegularExpression *regexDocomo = [NSRegularExpression regularExpressionWithPattern:patternDocomo options:0 error:nil];
    NSTextCheckingResult *matchDocomo = [regexDocomo firstMatchInString:barcodeString options:0 range:NSMakeRange(0, barcodeString.length)];
    // AU,Softbankの正規表現
    NSString *patternAUSB = @"^(MEMORY:)";
    NSRegularExpression *regexAUSB = [NSRegularExpression regularExpressionWithPattern:patternAUSB options:0 error:nil];
    NSTextCheckingResult *matchAUSB = [regexAUSB firstMatchInString:barcodeString options:0 range:NSMakeRange(0, barcodeString.length)];
    if (matchDocomo.numberOfRanges == 0 && matchAUSB.numberOfRanges == 0)
        barcodeResults.text = @"連絡先では無いバーコードが読み込まれました。";
    else if (matchDocomo.numberOfRanges > 0 && matchAUSB.numberOfRanges == 0)
        contactInfo = [self parseDocomo];
    else if (matchDocomo.numberOfRanges == 0 && matchAUSB.numberOfRanges > 0)
        contactInfo = [self parseAUSB];
    [self updateText];
}

- (Contact*)parseDocomo {
    // Initialize contact instance
    Contact *contact = [[Contact alloc] init];
    contact.emails = [[NSMutableArray alloc] init];
    contact.phones = [[NSMutableArray alloc] init];
    // 「;」で項目ごとに分割
    NSArray *codeElements = [barcodeString componentsSeparatedByString:@";"];
    // それぞれの項目ごとに分割
    NSString *patternName = @"MECARD:N:(.*?)$";
    NSString *patternYomi = @"SOUND:(.*?)$";
    NSString *patternEmail = @"EMAIL:(.*?)$";
    NSString *patternPhone = @"TEL:(.*?)$";
    NSRegularExpression *regexName = [NSRegularExpression regularExpressionWithPattern:patternName options:0 error:nil];
    NSRegularExpression *regexYomi = [NSRegularExpression regularExpressionWithPattern:patternYomi options:0 error:nil];
    NSRegularExpression *regexEmail = [NSRegularExpression regularExpressionWithPattern:patternEmail options:0 error:nil];
    NSRegularExpression *regexPhone = [NSRegularExpression regularExpressionWithPattern:patternPhone options:0 error:nil];
    
    // Iterate over elements
    for (NSString *element in codeElements) {
        // Get name
        NSTextCheckingResult *match = [regexName firstMatchInString:element options:0 range:NSMakeRange(0, element.length)];
        if (match.numberOfRanges > 0) {
            NSString *name = [element substringWithRange:[match rangeAtIndex:1]];
            NSArray *names = [name componentsSeparatedByString:@","];
            contact.lastname = names[0];
            contact.firstname = names[1];
        }
        // Get yomi
        match = [regexYomi firstMatchInString:element options:0 range:NSMakeRange(0, element.length)];
        if (match.numberOfRanges > 0) {
            NSString *yomi = [element substringWithRange:[match rangeAtIndex:1]];
            NSArray *yomis = [yomi componentsSeparatedByString:@","];
            contact.lastyomi = yomis[0];
            contact.firstyomi = yomis[1];
        }
        // Get email
        match = [regexEmail firstMatchInString:element options:0 range:NSMakeRange(0, element.length)];
        if (match.numberOfRanges > 0) {
            [contact.emails addObject:[element substringWithRange:[match rangeAtIndex:1]]];
        }
        // Get phone
        match = [regexPhone firstMatchInString:element options:0 range:NSMakeRange(0, element.length)];
        if (match.numberOfRanges > 0) {
            [contact.phones addObject:[element substringWithRange:[match rangeAtIndex:1]]];
        }
    }
    return contact;
}

- (Contact*)parseAUSB {
    // Initialize contact instance
    Contact *contact = [[Contact alloc] init];
    contact.emails = [[NSMutableArray alloc] init];
    contact.phones = [[NSMutableArray alloc] init];
    // 「;」で項目ごとに分割
    NSArray *codeElements = [barcodeString componentsSeparatedByString:@"\n"];
    // それぞれの項目ごとに分割
    NSString *patternName = @"NAME1:(.*?)$";
    NSString *patternYomi = @"NAME2:(.*?)$";
    NSString *patternEmail = @"MAIL[0-9]:(.*?)$";
    NSString *patternPhone = @"TEL[0-9]:(.*?)$";
    NSRegularExpression *regexName = [NSRegularExpression regularExpressionWithPattern:patternName options:0 error:nil];
    NSRegularExpression *regexYomi = [NSRegularExpression regularExpressionWithPattern:patternYomi options:0 error:nil];
    NSRegularExpression *regexEmail = [NSRegularExpression regularExpressionWithPattern:patternEmail options:0 error:nil];
    NSRegularExpression *regexPhone = [NSRegularExpression regularExpressionWithPattern:patternPhone options:0 error:nil];
    
    // Iterate over elements
    for (NSString *element in codeElements) {
        // Get name
        NSTextCheckingResult *match = [regexName firstMatchInString:element options:0 range:NSMakeRange(0, element.length)];
        if (match.numberOfRanges > 0) {
            contact.lastname = [element substringWithRange:[match rangeAtIndex:1]];
        }
        // Get yomi
        match = [regexYomi firstMatchInString:element options:0 range:NSMakeRange(0, element.length)];
        if (match.numberOfRanges > 0) {
            contact.lastyomi = [element substringWithRange:[match rangeAtIndex:1]];
        }
        // Get email
        match = [regexEmail firstMatchInString:element options:0 range:NSMakeRange(0, element.length)];
        if (match.numberOfRanges > 0) {
            [contact.emails addObject:[element substringWithRange:[match rangeAtIndex:1]]];
        }
        // Get phone
        match = [regexPhone firstMatchInString:element options:0 range:NSMakeRange(0, element.length)];
        if (match.numberOfRanges > 0) {
            [contact.phones addObject:[element substringWithRange:[match rangeAtIndex:1]]];
        }
    }
    return contact;
}

- (void)updateText {
    NSMutableString *result = [[NSMutableString alloc] init];
    if (contactInfo.firstname != nil)
        [result appendFormat:@"名前: %@ %@\n", contactInfo.lastname, contactInfo.firstname];
    else
        [result appendFormat:@"名前: %@\n", contactInfo.lastname];
    if (contactInfo.firstyomi != nil)
        [result appendFormat:@"ふりがな: %@ %@\n", contactInfo.lastyomi, contactInfo.firstyomi];
    else
        [result appendFormat:@"ふりがな: %@\n", contactInfo.lastyomi];
    for (int i = 0; i < contactInfo.emails.count; i++) {
        [result appendFormat:@"メールアドレス %d: %@\n", i+1, [contactInfo.emails objectAtIndex:i]];
    }
    for (int i = 0; i < contactInfo.phones.count; i++) {
        [result appendFormat:@"電話番号 %d: %@\n", i+1, [contactInfo.phones objectAtIndex:i]];
    }
    barcodeResults.text = result;
}

- (void)registContact:(ABAddressBookRef)iPhoneAddressBook {
    CFErrorRef error = NULL;
    ABRecordRef newBook = ABPersonCreate();
    // 姓を指定
    ABRecordSetValue(newBook, kABPersonLastNameProperty, (__bridge CFStringRef)contactInfo.lastname, &error);
    ABRecordSetValue(newBook, kABPersonLastNamePhoneticProperty, (__bridge CFStringRef)contactInfo.lastyomi, &error);
    // 名を指定
    ABRecordSetValue(newBook, kABPersonFirstNameProperty, (__bridge CFStringRef)contactInfo.firstname, &error);
    ABRecordSetValue(newBook, kABPersonFirstNamePhoneticProperty, (__bridge CFStringRef)contactInfo.firstyomi, &error);
    // TELを指定
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (NSString *phone in contactInfo.phones) {
        ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFStringRef)phone, NULL, NULL);
    }
    ABRecordSetValue(newBook, kABPersonPhoneProperty, multiPhone, &error);
    CFRelease(multiPhone);
    // Mail Addressを指定
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (NSString *email in contactInfo.emails) {
        ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFStringRef)email, NULL, NULL);
    }
    ABRecordSetValue(newBook, kABPersonEmailProperty, multiEmail, &error);
    CFRelease(multiEmail);
    // 電話帳にレコードを追加・保存
    ABAddressBookAddRecord(iPhoneAddressBook, newBook, &error);
    ABAddressBookSave(iPhoneAddressBook, &error);
    CFRelease(newBook);
    CFRelease(iPhoneAddressBook);
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] init];
        if (error != NULL) {
            CFStringRef errorDesc = CFErrorCopyDescription(error);
            alert.title = @"アドレス帳保存エラー";
            alert.message = [NSString stringWithFormat:@"エラー: %@", errorDesc];
            CFRelease(errorDesc);
        } else {
            alert.title = @"登録完了";
            alert.message = @"連絡先に追加されました。";
        }
        [alert addButtonWithTitle:@"OK"];
        [alert show];
    });
}







@end






