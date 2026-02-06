import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../core/application/provider/core_provider.dart";
import "../../../../core/router/router/router.dart";
import "../../../../shared/application/shared_validation.dart";
import "../../../../shared/presentation/base_screen/shared_app_bar.dart";
import "../../../../shared/presentation/base_screen/shared_base_screen.dart";
import "../../../../shared/presentation/text_field/shared_text_field.dart";
import "../../provider/signin_provider.dart";

class SigninScreen extends HookConsumerWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final TextEditingController emailController = useTextEditingController();
    final int? canResendSeconds = ref.watch(authTimerProvider).canResend
        ? null
        : ref.watch(authTimerProvider).seconds;
    return SharedBaseScreen(
      appBar: SharedAppBar(title: "Sign in", canPop: false),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              SharedTextFormField(
                validator: validateEmail,
                textEditingController: emailController,
                hintText: "Email",
              ),
              if (canResendSeconds != null)
                Text(
                  "retry in $canResendSeconds s",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              FilledButton(
                onPressed:
                    ref.watch(signinAsyncNotifierProvider).isLoading ||
                        !ref.watch(authTimerProvider).canResend
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          ref.read(authTimerProvider.notifier).startTimer();
                          await ref
                              .read(signinAsyncNotifierProvider.notifier)
                              .signin(emailController.text);
                          ref
                              .read(currentAuthDataNotifierProvider.notifier)
                              .setEmail(emailController.text);
                          if (!context.mounted) return;
                          await SigninInputOtpRoute().push(context);
                        }
                      },
                child: Text(
                  "Sign in",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
