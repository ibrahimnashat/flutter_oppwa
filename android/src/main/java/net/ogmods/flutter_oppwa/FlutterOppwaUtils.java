package net.ogmods.flutter_oppwa;

import android.app.Activity;

import androidx.annotation.Nullable;
import androidx.browser.customtabs.CustomTabsClient;

import com.oppwa.mobile.connect.exception.PaymentError;
import com.oppwa.mobile.connect.exception.PaymentException;
import com.oppwa.mobile.connect.payment.BillingAddress;
import com.oppwa.mobile.connect.payment.BrandInfo;
import com.oppwa.mobile.connect.payment.CardBrandInfo;
import com.oppwa.mobile.connect.payment.CheckoutInfo;
import com.oppwa.mobile.connect.payment.PaymentParams;
import com.oppwa.mobile.connect.payment.card.BaseCardPaymentParams;
import com.oppwa.mobile.connect.payment.card.CardPaymentParams;
import com.oppwa.mobile.connect.payment.stcpay.STCPayPaymentParams;
import com.oppwa.mobile.connect.payment.token.BankAccount;
import com.oppwa.mobile.connect.payment.token.Card;
import com.oppwa.mobile.connect.payment.token.Token;
import com.oppwa.mobile.connect.payment.token.TokenPaymentParams;
import com.oppwa.mobile.connect.payment.token.VirtualAccount;
import com.oppwa.mobile.connect.provider.ThreeDS2Info;
import com.oppwa.mobile.connect.provider.Transaction;
import com.oppwa.mobile.connect.provider.model.yookassa.YooKassaInfo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class FlutterOppwaUtils {
    public static String getPackageName(Activity activity) {
        return CustomTabsClient.getPackageName(activity, Collections.singletonList("com.android.chrome"));
    }

    private static <T> void putNullable(Map<String, Object> map, String name, @Nullable T value) {
        if (value != null) map.put(name, value);
    }

    public static Map<String, Object> toJson(PaymentException error) {
        return toJson(error.getError());
    }

    public static Map<String, Object> toJson(PaymentError error) {
        Map<String, Object> map = new HashMap<>();
        putNullable(map, "code", FlutterEnums.toJson(FlutterEnums.FlutterErrorCode.values(), error.getErrorCode()));
        putNullable(map, "message", error.getErrorMessage());
        putNullable(map, "info", error.getErrorInfo());
        return map;
    }

    public static Map<String, Object> toJson(Transaction transaction) {
        Map<String, Object> map = new HashMap<>();
        putNullable(map, "transactionType", FlutterEnums.toJson(FlutterEnums.FlutterTransactionType.values(), transaction.getTransactionType()));
        putNullable(map, "brandSpecificInfo", transaction.getBrandSpecificInfo());
        putNullable(map, "paymentParams", toJson(transaction.getPaymentParams()));
        putNullable(map, "threeDS2Info", toJson(transaction.getThreeDS2Info()));
        putNullable(map, "yooKassaInfo", toJson(transaction.getYooKassaInfo()));
        putNullable(map, "redirectUrl", transaction.getRedirectUrl());
        putNullable(map, "threeDS2MethodRedirectUrl", transaction.getThreeDS2MethodRedirectUrl());
        return map;
    }

    public static Map<String, Object> toJson(PaymentParams params) {
        Map<String, Object> map = new HashMap<>();
        if (params instanceof CardPaymentParams) {
            CardPaymentParams card = (CardPaymentParams) params;
            putNullable(map, "__typename__", "CardPaymentParams");
            putNullable(map, "number", card.getNumber());
            putNullable(map, "holder", card.getHolder());
            putNullable(map, "expiryMonth", card.getExpiryMonth());
            putNullable(map, "expiryYear", card.getExpiryYear());
            putNullable(map, "mobilePhone", card.getMobilePhone());
            putNullable(map, "countryCode", card.getCountryCode());
            putNullable(map, "billingAddress", toJson(card.getBillingAddress()));
        }
        if (params instanceof STCPayPaymentParams) {
            STCPayPaymentParams stc = (STCPayPaymentParams) params;
            putNullable(map, "__typename__", "STCPayPaymentParams");
            putNullable(map, "mobilePhoneNumber", stc.getMobilePhoneNumber());
            putNullable(map, "verificationOption", FlutterEnums.toJson(FlutterEnums.FlutterSTCPayVerificationOption.values(), stc.getVerificationOption()));
        }
        if (params instanceof TokenPaymentParams) {
            TokenPaymentParams token = (TokenPaymentParams) params;
            putNullable(map, "__typename__", "TokenPaymentParams");
            putNullable(map, "tokenId", token.getTokenId());
        }
        if (params instanceof BaseCardPaymentParams) {
            BaseCardPaymentParams card = (BaseCardPaymentParams) params;
            putNullable(map, "cvv", card.getCvv());
            putNullable(map, "threeDS2AuthParams", card.getThreeDS2AuthParams());
            putNullable(map, "numberOfInstallments", card.getNumberOfInstallments());
        }
        // TODO: handle other types of payment params
        putNullable(map, "checkoutId", params.getCheckoutId());
        putNullable(map, "paymentBrand", params.getPaymentBrand());
        putNullable(map, "shopperResultUrl", params.getShopperResultUrl());
        return map;
    }

    @Nullable
    public static Map<String, Object> toJson(@Nullable BillingAddress address) {
        if (address == null) return null;
        Map<String, Object> map = new HashMap<>();
        putNullable(map, "country", address.getCountry());
        putNullable(map, "state", address.getState());
        putNullable(map, "city", address.getCity());
        putNullable(map, "postCode", address.getPostCode());
        putNullable(map, "street1", address.getStreet1());
        putNullable(map, "street2", address.getStreet2());
        return map;
    }

    @Nullable
    public static Map<String, Object> toJson(@Nullable ThreeDS2Info info) {
        if (info == null) return null;
        Map<String, Object> map = new HashMap<>();
        putNullable(map, "authStatus", FlutterEnums.toJson(FlutterEnums.FlutterThreeDS2Status.values(), info.getAuthStatus()));
        putNullable(map, "authResponse", info.getAuthResponse());
        putNullable(map, "callbackUrl", info.getCallbackUrl());
        putNullable(map, "cardHolderInfo", info.getCardHolderInfo());
        putNullable(map, "challengeCompletionCallbackUrl", info.getChallengeCompletionCallbackUrl());
        putNullable(map, "protocolVersion", info.getProtocolVersion());
        return map;
    }

    @Nullable
    public static Map<String, Object> toJson(@Nullable YooKassaInfo info) {
        if (info == null) return null;
        Map<String, Object> map = new HashMap<>();
        putNullable(map, "status", FlutterEnums.toJson(FlutterEnums.FlutterYooKassaStatus.values(), info.getStatus()));
        putNullable(map, "confirmationUrl", info.getConfirmationUrl());
        putNullable(map, "callbackUrl", info.getCallbackUrl());
        return map;
    }

    @Nullable
    public static Map<String, Object> toJson(@Nullable CheckoutInfo info) {
        if (info == null) return null;
        Map<String, Object> map = new HashMap<>();
        putNullable(map, "amount", info.getAmount());
        putNullable(map, "brands", toList(info.getBrands()));
        putNullable(map, "currencyCode", info.getCurrencyCode());
        putNullable(map, "endpoint", info.getEndpoint());
        putNullable(map, "klarnaMerchantIds", toList(info.getKlarnaMerchantIds()));
        putNullable(map, "resourcePath", info.getResourcePath());
        putNullable(map, "threeDs2Brands", toList(info.getThreeDS2Brands()));
        putNullable(map, "threeDs2Flow", FlutterEnums.toJson(FlutterEnums.FlutterCheckoutThreeDS2Flow.values(), info.getThreeDS2Flow()));
        Token[] tokens = info.getTokens();
        if (tokens != null) {
            List<Map<String, Object>> tokensJson = new ArrayList<>();
            for (Token token : tokens) tokensJson.add(toJson(token));
            putNullable(map, "tokens", tokensJson);
        }
        return map;
    }

    public static Map<String, Object> toJson(Token token) {
        Map<String, Object> map = new HashMap<>();
        putNullable(map, "tokenId", token.getTokenId());
        putNullable(map, "paymentBrand", token.getPaymentBrand());
        putNullable(map, "bankAccount", toJson(token.getBankAccount()));
        putNullable(map, "card", toJson(token.getCard()));
        putNullable(map, "virtualAccount", toJson(token.getVirtualAccount()));
        return map;
    }

    @Nullable
    public static Map<String, Object> toJson(@Nullable BankAccount account) {
        if (account == null) return null;
        Map<String, Object> map = new HashMap<>();
        putNullable(map, "holder", account.getHolder());
        putNullable(map, "iban", account.getIban());
        return map;
    }

    @Nullable
    public static Map<String, Object> toJson(@Nullable Card card) {
        if (card == null) return null;
        Map<String, Object> map = new HashMap<>();
        putNullable(map, "expiryMonth", card.getExpiryMonth());
        putNullable(map, "expiryYear", card.getExpiryYear());
        putNullable(map, "holder", card.getHolder());
        putNullable(map, "last4Digits", card.getLast4Digits());
        return map;
    }

    @Nullable
    public static Map<String, Object> toJson(@Nullable VirtualAccount account) {
        if (account == null) return null;
        Map<String, Object> map = new HashMap<>();
        putNullable(map, "holder", account.getHolder());
        putNullable(map, "accountId", account.getAccountId());
        return map;
    }

    @Nullable
    public static <T> List<T> toList(@Nullable T[] array) {
        if (array == null) return null;
        List<T> list = new ArrayList<>();
        Collections.addAll(list, array);
        return list;
    }
}

