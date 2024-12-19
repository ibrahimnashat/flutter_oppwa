package net.ogmods.flutter_oppwa;

import android.content.ComponentName;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.oppwa.mobile.connect.exception.PaymentError;
import com.oppwa.mobile.connect.exception.PaymentException;
import com.oppwa.mobile.connect.payment.CheckoutInfo;
import com.oppwa.mobile.connect.provider.Connect;
import com.oppwa.mobile.connect.provider.ITransactionListener;
import com.oppwa.mobile.connect.provider.OppPaymentProvider;
import com.oppwa.mobile.connect.provider.Transaction;
import com.oppwa.mobile.connect.provider.TransactionType;

import java.util.HashMap;
import java.util.Map;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.browser.customtabs.CustomTabsCallback;
import androidx.browser.customtabs.CustomTabsClient;
import androidx.browser.customtabs.CustomTabsIntent;
import androidx.browser.customtabs.CustomTabsServiceConnection;
import androidx.browser.customtabs.CustomTabsSession;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

class FlutterOppwaDelegate extends CustomTabsServiceConnection implements ITransactionListener, PluginRegistry.NewIntentListener {
    private final ActivityPluginBinding binding;
    private final OppPaymentProvider provider;
    private final MethodChannel.Result result;
    private final Handler handler;
    private final String shopperResultUrl;
    private boolean didRedirect = false;
    private Transaction transaction;
    private String transactionType = "submit";

    private void success(Object result) {
        handler.post(() -> this.result.success(result));
    }

    private void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
        handler.post(() -> this.result.error(errorCode, errorMessage, errorDetails));
    }

    public FlutterOppwaDelegate(@NonNull ActivityPluginBinding binding, @NonNull Connect.ProviderMode mode, MethodChannel.Result result) {
        this.binding = binding;
        this.result = result;
        shopperResultUrl = binding.getActivity().getPackageName().replaceAll("_", "") + ".payments";
        provider = new OppPaymentProvider(binding.getActivity().getApplicationContext(), mode);
        handler = new Handler(Looper.getMainLooper());
    }

    public void submitTransaction(Transaction transaction) throws PaymentException {
        transactionType = "submit";
        transaction.getPaymentParams().setShopperResultUrl(shopperResultUrl + "://result");
        provider.submitTransaction(transaction, this);
    }

    public void registerTransaction(Transaction transaction) throws PaymentException {
        transactionType = "register";
        transaction.getPaymentParams().setShopperResultUrl(shopperResultUrl + "://result");
        provider.registerTransaction(transaction, this);
    }

    public void sendTransaction(Transaction transaction, String endpoint) {
        transactionType = "send";
        transaction.getPaymentParams().setShopperResultUrl(shopperResultUrl + "://result");
        provider.sendTransaction(transaction, endpoint, this);
    }

    public void requestCheckoutInfo(String checkoutId) {
        provider.requestCheckoutInfo(checkoutId, this);
    }

    @Override
    public void paymentConfigRequestSucceeded(@NonNull CheckoutInfo checkoutInfo) {
        success(FlutterOppwaUtils.toJson(checkoutInfo));
    }

    @Override
    public void paymentConfigRequestFailed(@NonNull PaymentError paymentError) {
        error("payment_error", "Config request failed", FlutterOppwaUtils.toJson(paymentError));
    }

    @Override
    public void transactionCompleted(@NonNull Transaction transaction) {
        if (!transactionType.equals("submit") || transaction.getTransactionType() == TransactionType.SYNC) {
            success(FlutterOppwaUtils.toJson(transaction));
        } else {
            if (transaction.getRedirectUrl() == null) {
                Map<String, Object> details = new HashMap<>();
                details.put("transaction", FlutterOppwaUtils.toJson(transaction));
                error("invalid_transaction", "The transaction type was async but the redirect url was null", details);
                return;
            }
            this.transaction = transaction;
            CustomTabsClient.bindCustomTabsService(binding.getActivity().getApplicationContext(), FlutterOppwaUtils.getPackageName(binding.getActivity()), this);
        }
    }

    @Override
    public void transactionFailed(@NonNull Transaction transaction, @NonNull PaymentError paymentError) {
        Map<String, Object> details = FlutterOppwaUtils.toJson(paymentError);
        details.put("transaction", FlutterOppwaUtils.toJson(transaction));
        error("payment_error", "transaction failed", details);
    }


    @Override
    public boolean onNewIntent(Intent intent) {
        Log.w("flutter_oppwa", "onNewIntent: scheme = " + intent.getScheme());

        if (intent.getScheme().equals(shopperResultUrl)) {
            didRedirect = true;
        }
        return false;
    }

    @Override
    public void onCustomTabsServiceConnected(@NonNull ComponentName name, @NonNull CustomTabsClient client) {
        binding.addOnNewIntentListener(FlutterOppwaDelegate.this);
        CustomTabsSession session = client.newSession(new CustomTabsCallback() {
            @Override
            public void onNavigationEvent(int navigationEvent, @Nullable Bundle extras) {
                Log.w("flutter_oppwa", "onNavigationEvent: Code = " + navigationEvent);
                if (navigationEvent == TAB_HIDDEN) {
                    if (didRedirect) {
                        success(FlutterOppwaUtils.toJson(transaction));
                    } else {
                        Map<String, Object> details = new HashMap<>();
                        details.put("transaction", FlutterOppwaUtils.toJson(transaction));
                        error("payment_canceled", "The payment was canceled", details);
                    }
                    binding.getActivity().getApplicationContext().unbindService(FlutterOppwaDelegate.this);
                }
                super.onNavigationEvent(navigationEvent, extras);
            }
        });
        Uri uri = Uri.parse(transaction.getRedirectUrl());
        didRedirect = false;
        CustomTabsIntent customTabsIntent = (new CustomTabsIntent.Builder(session)).build();
        customTabsIntent.intent.setData(uri);
        customTabsIntent.intent.setFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
        customTabsIntent.launchUrl(binding.getActivity(), uri);
    }

    @Override
    public void onServiceDisconnected(ComponentName name) {
        binding.removeOnNewIntentListener(this);
        didRedirect = false;
    }
}
