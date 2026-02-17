const List<Map<String, dynamic>> kFaqData = [
  {
    "category": "General",
    "questions": [
      {
        "question": "What is Kipa?",
        "answer":
            "Kipa is a secure payment and delivery platform that protects both buyers and sellers through escrow. When you pay for an item, your money is held safely until you confirm delivery, ensuring neither party gets scammed.",
      },
      {
        "question": "How does Kipa protect me?",
        "answer":
            "For Buyers: Your payment is held in escrow until you receive and confirm your item. If something goes wrong, you can open a dispute.\n\nFor Sellers: You're guaranteed payment once the buyer confirms delivery or the confirmation window expires.",
      },
      {
        "question": "Is my money safe?",
        "answer":
            "Yes. Funds are held in escrow and only released when:\n- The buyer confirms delivery, OR\n- The 24-hour confirmation window expires without a dispute, OR\n- A dispute is resolved",
      },
    ],
  },
  {
    "category": "Account & Authentication",
    "questions": [
      {
        "question": "How do I sign up?",
        "answer":
            "Simply enter your phone number and verify with the OTP (one-time password) sent via SMS. No passwords needed!",
      },
      {
        "question": "Why don't I need a password?",
        "answer":
            "We use OTP-based authentication for better security. Each time you log in, you verify with a fresh code sent to your phone.",
      },
      {
        "question": "What if I don't receive the OTP?",
        "answer":
            "- Wait a few seconds; SMS delivery can be delayed\n- If SMS fails, we'll automatically try a voice call\n- Check that your phone number is correct\n- You can request a new OTP after the cooldown period",
      },
      {
        "question": "Can I use Kipa on multiple devices?",
        "answer":
            "Yes, but logging in on a new device will revoke your session on other devices for security.",
      },
    ],
  },
  {
    "category": "Buying",
    "questions": [
      {
        "question": "How do I pay for an item?",
        "answer":
            "1. The seller shares a payment link or code with you\n2. Open the link or enter the code in the app\n3. Review the item details and total amount\n4. Pay using your wallet balance or card\n5. Your money is held in escrow until delivery",
      },
      {
        "question": "What happens after I pay?",
        "answer":
            "- For delivery orders: A rider/driver is assigned to pick up and deliver your item\n- For pickup orders: You'll coordinate with the seller to collect the item\n- For inter-state orders: The seller ships via a logistics partner",
      },
      {
        "question": "How do I confirm delivery?",
        "answer":
            "1. Inspect your item when it arrives\n2. If satisfied, enter the dropoff code provided by the rider/driver\n3. This releases payment to the seller",
      },
      {
        "question": "What if I don't confirm delivery?",
        "answer":
            "If you don't confirm or dispute within 24 hours of delivery, the payment is automatically released to the seller.",
      },
      {
        "question": "What if the item is wrong or damaged?",
        "answer":
            "Open a dispute immediately! Do not confirm delivery. Our team will review the case and can:\n- Issue a full refund\n- Issue a partial refund\n- Rule in the seller's favor (with evidence)",
      },
      {
        "question": "Can I cancel my order?",
        "answer":
            "- Before pickup: Yes, you'll receive a full refund\n- After pickup: Contact support; cancellation may incur fees",
      },
    ],
  },
  {
    "category": "Selling",
    "questions": [
      {
        "question": "How do I create a payment request?",
        "answer":
            "1. Go to \"Create Payment Request\"\n2. Enter item details (name, description, price, images)\n3. Select delivery type (intra-state, inter-state, or pickup)\n4. Set pickup address if applicable\n5. Share the generated link or payment code with your buyer",
      },
      {
        "question": "Can I reuse payment links?",
        "answer":
            "Yes! When creating a payment request, enable \"Reusable Link\" to allow multiple buyers to pay through the same link. You can also set a maximum number of uses.",
      },
      {
        "question": "When do I get paid?",
        "answer":
            "Payment is released to your wallet when:\n- The buyer confirms delivery, OR\n- 24 hours pass after delivery without a dispute",
      },
      {
        "question": "What fees do I pay?",
        "answer":
            "A small platform fee is deducted from your payout. The exact percentage is shown when you create the payment request.",
      },
      {
        "question": "What if the buyer opens a dispute?",
        "answer":
            "- You'll be notified immediately\n- Provide evidence (photos, messages, shipping proof)\n- Our team will review and make a fair decision",
      },
      {
        "question": "What if no rider is available?",
        "answer":
            "If no rider accepts the delivery within the search period, the order is cancelled and the buyer is refunded.",
      },
    ],
  },
  {
    "category": "Delivery",
    "questions": [
      {
        "question": "What delivery options are available?",
        "answer":
            "1. Intra-state (Same city): Our riders pick up and deliver within hours\n2. Inter-state (Different states): Ships via logistics partners (GIG, Kwik)\n3. Pickup: Buyer collects directly from seller",
      },
      {
        "question": "How long does delivery take?",
        "answer":
            "- Intra-state: Usually 1-3 hours depending on distance\n- Inter-state: 2-5 business days depending on the route",
      },
      {
        "question": "How do I track my delivery?",
        "answer":
            "- Intra-state: Real-time GPS tracking in the app\n- Inter-state: Tracking number provided once shipped",
      },
      {
        "question": "What's the pickup code?",
        "answer":
            "A 6-digit code the seller gives to the rider to verify they're collecting the right package.",
      },
      {
        "question": "What's the dropoff code?",
        "answer":
            "A 6-digit code you (the buyer) give to the rider to confirm you've received the package. This triggers payment release.",
      },
      {
        "question": "What if I'm not available for delivery?",
        "answer":
            "If the rider can't reach you:\n1. First attempt: Rider waits and contacts you\n2. If unreachable: Item may be returned to seller\n3. A 5% unavailability fee may be deducted from your refund",
      },
      {
        "question": "Can I reschedule delivery?",
        "answer":
            "Yes, if you miss delivery, you can rebook within 48 hours. After that, the item is returned to the seller.",
      },
    ],
  },
  {
    "category": "Errands (On-Demand Delivery)",
    "questions": [
      {
        "question": "What are errands?",
        "answer":
            "Errands let you request a rider to pick up and deliver anything - documents, food, packages, etc. No payment link needed; you pay the delivery fee directly.",
      },
      {
        "question": "How do I create an errand?",
        "answer":
            "1. Enter pickup location and contact\n2. Enter dropoff location and contact\n3. Describe what's being delivered\n4. Choose vehicle type (motorcycle or car)\n5. Confirm and pay the delivery fee",
      },
      {
        "question": "How much do errands cost?",
        "answer":
            "The fee is calculated based on:\n- Distance between pickup and dropoff\n- Vehicle type (cars cost more than motorcycles)",
      },
    ],
  },
  {
    "category": "Wallet",
    "questions": [
      {
        "question": "How do I add money to my wallet?",
        "answer":
            "1. Go to Wallet > Top Up\n2. Enter the amount\n3. Pay via card or bank transfer\n4. Funds are available immediately",
      },
      {
        "question": "How do I withdraw money?",
        "answer":
            "1. Go to Wallet > Withdraw\n2. Enter amount (minimum applies)\n3. Select or add your bank account\n4. Enter your wallet PIN\n5. Funds typically arrive within 24 hours",
      },
      {
        "question": "What's a wallet PIN?",
        "answer":
            "A 4-6 digit code required for withdrawals and sensitive transactions. Set this up in your wallet settings.",
      },
      {
        "question": "What if I forget my wallet PIN?",
        "answer": "Contact support to verify your identity and reset your PIN.",
      },
      {
        "question": "What's a Virtual Account (DVA)?",
        "answer":
            "A dedicated bank account number linked to your Kipa wallet. Anyone can transfer money to this account, and it automatically tops up your wallet.",
      },
    ],
  },
  {
    "category": "Disputes",
    "questions": [
      {
        "question": "When should I open a dispute?",
        "answer":
            "- Item not received\n- Item significantly different from description\n- Item damaged during delivery\n- Wrong item delivered\n- Seller not responding",
      },
      {
        "question": "How do I open a dispute?",
        "answer":
            "1. Go to the order in your Purchases\n2. Tap \"Open Dispute\"\n3. Select a reason and provide details\n4. Upload evidence (photos, screenshots)",
      },
      {
        "question": "What evidence should I provide?",
        "answer":
            "- Photos of the item received\n- Photos showing damage or defects\n- Screenshots of conversations with seller\n- Comparison with item listing photos",
      },
      {
        "question": "How long does dispute resolution take?",
        "answer":
            "Most disputes are resolved within 24-72 hours. Complex cases may take longer.",
      },
      {
        "question": "What are the possible outcomes?",
        "answer":
            "- Buyer wins: Full refund issued\n- Seller wins: Payment released to seller\n- Partial refund: Amount split based on circumstances\n- Mutual resolution: Both parties agree to a solution",
      },
      {
        "question": "Can I appeal a dispute decision?",
        "answer":
            "Contact support with additional evidence if you believe the decision was incorrect.",
      },
    ],
  },
  {
    "category": "Riders & Drivers",
    "questions": [
      {
        "question": "How do I become a rider?",
        "answer":
            "1. Create an account\n2. Go to \"Become a Rider\"\n3. Submit required documents (ID, license, vehicle papers)\n4. Complete verification (usually 24-48 hours)\n5. Once approved, go online to start receiving jobs",
      },
      {
        "question": "What vehicles can I use?",
        "answer": "- Motorcycle\n- Car (for larger deliveries)",
      },
      {
        "question": "How do I get paid?",
        "answer":
            "Earnings are credited to your wallet after each completed delivery. You can withdraw anytime.",
      },
      {
        "question": "What's the commission structure?",
        "answer":
            "A small commission is deducted from each delivery. Your net payout is shown before you accept any job.",
      },
      {
        "question": "What if I can't complete a delivery?",
        "answer":
            "Contact support immediately. Abandoning deliveries without notice may result in account suspension.",
      },
      {
        "question": "Can I reject delivery jobs?",
        "answer":
            "Yes, but consistently rejecting jobs may affect your visibility for future jobs.",
      },
    ],
  },
  {
    "category": "Payments & Fees",
    "questions": [
      {
        "question": "What payment methods are accepted?",
        "answer":
            "- Wallet balance\n- Debit/credit cards\n- Bank transfer (to Virtual Account)",
      },
      {
        "question": "Are there any hidden fees?",
        "answer":
            "No. All fees are clearly shown before you confirm any transaction:\n- Buyers see: Item price + delivery fee + service fee\n- Sellers see: Platform fee deducted from payout",
      },
      {
        "question": "Is there a minimum withdrawal amount?",
        "answer":
            "Yes, the minimum withdrawal is displayed in the app. This covers bank transfer costs.",
      },
      {
        "question": "Why was my payment declined?",
        "answer":
            "Common reasons:\n- Insufficient card balance\n- Card not enabled for online payments\n- Bank security block (contact your bank)\n- Network issues (try again)",
      },
    ],
  },
  {
    "category": "Security",
    "questions": [
      {
        "question": "How secure is Kipa?",
        "answer":
            "- All data is encrypted in transit and at rest\n- OTP-based authentication (no passwords to steal)\n- Wallet PIN for sensitive transactions\n- Session management (logout other devices)",
      },
      {
        "question": "What if someone accesses my account?",
        "answer":
            "1. Contact support immediately\n2. We'll revoke all active sessions\n3. Re-verify your phone number\n4. Review recent transactions",
      },
      {
        "question": "How do I report fraud?",
        "answer":
            "Contact support with:\n- Transaction details\n- Evidence of fraud\n- Any communication with the other party",
      },
    ],
  },
  {
    "category": "Contact & Support",
    "questions": [
      {
        "question": "How do I contact support?",
        "answer":
            "- In-app chat support\n- Email: support@kipa.com\n- Response time: Usually within a few hours",
      },
      {
        "question": "What are your operating hours?",
        "answer":
            "Support is available 24/7 for urgent issues. Standard inquiries are handled during business hours.",
      },
      {
        "question": "Where can I report a bug?",
        "answer":
            "Use the in-app feedback option or email support with:\n- Description of the issue\n- Steps to reproduce\n- Screenshots if applicable",
      },
    ],
  },
];
