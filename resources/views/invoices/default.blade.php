<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Invoice {{ $order->order_number }}</title>
    <style>
        body { font-family: 'DejaVu Sans', sans-serif; font-size: 12px; color: #111c2d; margin: 40px; }
        .header { text-align: center; margin-bottom: 32px; border-bottom: 2px solid #93000b; padding-bottom: 16px; }
        .header h1 { color: #93000b; font-size: 24px; margin: 0; }
        .header p { color: #515f74; margin: 4px 0 0; }
        .info { display: flex; justify-content: space-between; margin-bottom: 32px; }
        .info div { width: 48%; }
        .info h3 { font-size: 12px; color: #515f74; text-transform: uppercase; letter-spacing: 1px; margin: 0 0 4px; }
        .info p { margin: 0; font-size: 14px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 32px; }
        th { background: #93000b; color: white; padding: 10px 12px; text-align: left; font-size: 11px; text-transform: uppercase; letter-spacing: 1px; }
        td { padding: 10px 12px; border-bottom: 1px solid #d8e3fb; font-size: 13px; }
        .total { text-align: right; font-size: 18px; font-weight: bold; color: #93000b; margin-top: 16px; }
        .footer { text-align: center; color: #515f74; font-size: 11px; border-top: 1px solid #d8e3fb; padding-top: 16px; margin-top: 32px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>MedFoot</h1>
        <p>HIGH-PRECISION MEDICAL PROCUREMENT</p>
    </div>

    <div class="info">
        <div>
            <h3>Invoice To</h3>
            <p>{{ $order->user->name }}<br>{{ $order->shipping_address }}</p>
        </div>
        <div style="text-align:right">
            <h3>Invoice Details</h3>
            <p>Order: {{ $order->order_number }}<br>Date: {{ $order->created_at->format('M d, Y') }}</p>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>Item</th>
                <th>SKU</th>
                <th>Qty</th>
                <th style="text-align:right">Unit Price</th>
                <th style="text-align:right">Subtotal</th>
            </tr>
        </thead>
        <tbody>
            @foreach ($order->items as $item)
            <tr>
                <td>{{ $item->product->name }}</td>
                <td>{{ $item->product->sku ?? 'N/A' }}</td>
                <td>{{ $item->quantity }}</td>
                <td style="text-align:right">TZS {{ number_format($item->unit_price, 2) }}</td>
                <td style="text-align:right">TZS {{ number_format($item->subtotal, 2) }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>

    <div class="total">
        Total: TZS {{ number_format($order->total_amount, 2) }}
    </div>

    <div class="footer">
        <p>MedFoot &mdash; High-Precision Medical Procurement</p>
        <p>Thank you for your business.</p>
    </div>
</body>
</html>
