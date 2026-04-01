void TrailAllOrders() {
    // ... other code
    int req, res;

    req = OrderSend(...);
    if(req < 0) {
        Print("Error sending order: ", GetLastError());
    }

    // ... other code

    req = OrderSend(...);
    if(req < 0) {
        Print("Error sending order: ", GetLastError());
    }
    // ... other code
}