//  © Copyright ACI Worldwide, Inc. 2018, 2025

@import Foundation;

NS_ASSUME_NONNULL_BEGIN
/// :nodoc:
@interface OPPBinCache : NSObject

+ (instancetype)sharedInstance;

- (void)addPaymentBrands:(id)paymentBrands forBin:(NSString *)bin;
- (nullable NSArray<NSString *> *)paymentBrandsForBin:(NSString *)bin;
- (BOOL)hasValueForBin:(NSString *)bin;
- (void)clear;

@end

NS_ASSUME_NONNULL_END
