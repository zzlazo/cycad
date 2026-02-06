import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../core/application/provider/core_provider.dart";
import "../../../../shared/presentation/base_screen/shared_app_bar.dart";
import "../../../../shared/presentation/base_screen/shared_base_screen.dart";
import "../../../../shared/presentation/text_field/shared_text_field.dart";
import "../../model/signin_model.dart";
import "../../provider/signin_provider.dart";

class SigninInputOtpScreen extends HookConsumerWidget {
  const SigninInputOtpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(currentAuthDataNotifierProvider).email == null) {
      return SharedBaseScreen(body: Text("email is null"));
    }
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final TextEditingController controller = useTextEditingController();
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
              Text(
                "Check your inbox for One Time Password",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SharedTextFormField(
                textEditingController: controller,
                hintText: "One Time Password",
              ),

              FilledButton(
                onPressed: ref.watch(signinAsyncNotifierProvider).isLoading
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          ref.read(authTimerProvider.notifier).startTimer();
                          await ref
                              .read(signinAsyncNotifierProvider.notifier)
                              .sendOtp(
                                SendOtpRequest(
                                  email: ref
                                      .read(currentAuthDataNotifierProvider)
                                      .email!,
                                  otp: controller.text,
                                ),
                              );
                        }
                      },
                child: Text(
                  "Send",
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
