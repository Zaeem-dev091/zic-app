import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zic/customization/app_colors.dart';

class TransferAssetsDialog extends StatefulWidget {
  const TransferAssetsDialog({super.key});

  @override
  State<TransferAssetsDialog> createState() => _TransferAssetsDialogState();
}

class _TransferAssetsDialogState extends State<TransferAssetsDialog> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  double receiverGets = 0;

  void calculateReceiver() {
    final amount = double.tryParse(amountController.text) ?? 0;

    setState(() {
      receiverGets = amount; // change if fee logic exists
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Text(
                  "TRANSFER ASSETS",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 22.w),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            /// WARNING
            Text(
              "Important:\nDouble-check the receiver wallet address before confirming. Assets sent to the wrong address cannot be recovered.",
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 20.h),

            /// RECEIVER ADDRESS
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: "Enter receiver wallet address",
                border: UnderlineInputBorder(),
              ),
            ),

            SizedBox(height: 16.h),

            /// AMOUNT FIELD
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              onChanged: (value) => calculateReceiver(),
              decoration: InputDecoration(
                hintText: "Enter amount",
                border: UnderlineInputBorder(),
              ),
            ),

            SizedBox(height: 16.h),

            /// TRANSFER FEE
            Row(
              children: [
                Text(
                  "Transfer Fee: ",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "-- LIO",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h),

            /// RECEIVER GETS
            Row(
              children: [
                Text("Receiver will get: ", style: TextStyle(fontSize: 14.sp)),
                Text(
                  receiverGets.toString(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            SizedBox(height: 22.h),

            /// CONFIRM BUTTON
            // Obx(() {
            //   final controller = Get.find<HomeController>();

            //   return controller.isLoading.value
            //       ? Center(
            //           child: CircularProgressIndicator(color: kPrimaryColor),
            //         )
            //       : SizedBox(
            //           width: double.infinity,
            //           child: ElevatedButton(
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: kPrimaryColor,
            //               padding: EdgeInsets.symmetric(vertical: 14.h),
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(12.r),
            //               ),
            //             ),
            //             onPressed: () async {
            //               final amount = amountController.text;
            //               final address = addressController.text;

            //               if (amount.isEmpty || address.isEmpty) {
            //                 Get.snackbar("Error", "Please fill all the fields");
            //                 return;
            //               }
            //               final interedAmount = double.tryParse(amount) ?? 0.0;

            //               if (interedAmount > 30000 || interedAmount < 10000) {
            //                 Get.snackbar(
            //                   "Error",
            //                   "Amount must be between 10000 and 30000",
            //                 );
            //                 return;
            //               }
            //               print("Amount: $amount");
            //               print("Address: $address");

            //               // await Get.find<HomeController>().transferAssets(
            //               //   amount.toString(),
            //               //   address.toString(),
            //               // );

            //               Navigator.pop(context);
            //             },
            //             child: Text(
            //               "Confirm Transfer",
            //               style: TextStyle(
            //                 fontSize: 16.sp,
            //                 fontWeight: FontWeight.w600,
            //               ),
            //             ),
            //           ),
            //         );
            // }),
          ],
        ),
      ),
    );
  }
}
