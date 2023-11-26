codeunit 50711 "Shopping Cart Mgt."
{
    procedure AddItemToCart(CustomerNo: Code[20]; ItemNo: Code[20]; Quantity: Decimal)
    var
        CurrItemQty: Decimal;
        AddedItemMsg: Label 'Added item %1 for customer %2. Quantity in cart: %3.', Comment = '%1: Item No., %2: Customer No., %3: Ordered quantity';
    begin
        if not IsItemAvailable(ItemNo, 0, Quantity) then
            exit;

        CurrItemQty := GetItemQuantityInCart(CustomerNo, ItemNo);
        if CurrItemQty > 0 then
            UpdateItemQty(CustomerNo, ItemNo, Quantity + CurrItemQty)
        else
            CreateCartEntry(CustomerNo, ItemNo, Quantity);

        LogEvent(StrSubstNo(AddedItemMsg, ItemNo, CustomerNo, Quantity));
    end;

    procedure RemoveItemFromCart(CustomerNo: Code[20]; ItemNo: Code[20]; Quantity: Decimal)
    var
        ShoppingCart: Record "Shopping Cart";
        RemovedItemMsg: Label 'Removed item %1 from the cart for customer %2.', Comment = '%1: Item No., %2: Customer No.';
    begin
        ShoppingCart.SetRange("Customer No.", CustomerNo);
        ShoppingCart.SetRange("Item No.", ItemNo);
        ShoppingCart.DeleteAll(true);

        LogEvent(StrSubstNo(RemovedItemMsg, ItemNo, CustomerNo));
    end;

    procedure UpdateItemQty(CustomerNo: Code[20]; ItemNo: Code[20]; NewQuantity: Decimal)
    var
        CurrItemQty: Decimal;
        UpdatedItemMsg: Label 'Updated item %1 for customer %2. Quantity in cart: %3.', Comment = '%1: Item No., %2: Customer No., %3: Ordered quantity';
    begin
        CurrItemQty := GetItemQuantityInCart(CustomerNo, ItemNo);

        if CurrItemQty = NewQuantity then
            exit;

        if NewQuantity > CurrItemQty then
            if not IsItemAvailable(ItemNo, CurrItemQty, NewQuantity) then
                exit;

        UpdateCartEntry(CustomerNo, ItemNo, NewQuantity);
        LogEvent(StrSubstNo(UpdatedItemMsg, ItemNo, CustomerNo, NewQuantity));
    end;

    local procedure GetItemQuantityInCart(CustomerNo: Code[20]; ItemNo: Code[20]): Decimal
    var
        ShoppingCart: Record "Shopping Cart";
    begin
        ShoppingCart.SetRange("Customer No.", CustomerNo);
        ShoppingCart.SetRange("Item No.", ItemNo);
        ShoppingCart.CalcSums(Quantity);
        exit(ShoppingCart.Quantity);
    end;

    local procedure IsItemAvailable(ItemNo: Code[20]; OldQuantity: Decimal; NewQuantity: Decimal): Boolean
    var
        Item: Record Item;
        AvailableToPromise: Codeunit "Available to Promise";
        AvailableQty: Decimal;
        TotalBookedQty: Decimal;
        InsufficientQtyErr: Label 'Ordered quantity is %1, but only %2 available.', Comment = '%1: Ordered quantity, %2: Available quantity';
    begin
        Item.Get(ItemNo);
        AvailableQty := AvailableToPromise.CalcAvailableInventory(Item);
        TotalBookedQty := CalcTotalBookedItemQty(ItemNo);
        if NewQuantity - OldQuantity > AvailableQty - TotalBookedQty then begin
            LogEvent(StrSubstNo(InsufficientQtyErr, NewQuantity, AvailableQty - TotalBookedQty + OldQuantity));
            exit(false);
        end;

        exit(true);
    end;

    local procedure CreateCartEntry(CustomerNo: Code[20]; ItemNo: Code[20]; Quantity: Decimal)
    var
        ShoppingCart: Record "Shopping Cart";
    begin
        ShoppingCart.Validate(Position, GetLastPositioninCart(CustomerNo) + 1);
        ShoppingCart.Validate("Customer No.", CustomerNo);
        ShoppingCart.Validate("Item No.", ItemNo);
        ShoppingCart.Validate(Quantity, Quantity);
        ShoppingCart.Insert(true);
    end;

    local procedure CalcTotalBookedItemQty(ItemNo: Code[20]): Decimal
    var
        ShoppingCart: Record "Shopping Cart";
    begin
        ShoppingCart.ReadIsolation := IsolationLevel::ReadCommitted;
        ShoppingCart.SetRange("Item No.", ItemNo);
        ShoppingCart.CalcSums(Quantity);
        exit(ShoppingCart.Quantity);
    end;

    local procedure UpdateCartEntry(CustomerNo: Code[20]; ItemNo: Code[20]; NewQuantity: Decimal)
    var
        ShoppingCart: Record "Shopping Cart";
    begin
        ShoppingCart.ReadIsolation := IsolationLevel::UpdLock;
        ShoppingCart.SetRange("Customer No.", CustomerNo);
        ShoppingCart.SetRange("Item No.", ItemNo);
        ShoppingCart.FindFirst();
        ShoppingCart.Validate(Quantity, NewQuantity);
        ShoppingCart.Modify(true);
    end;

    local procedure GetLastPositioninCart(CustomerNo: Code[20]): Integer
    var
        ShoppingCart: Record "Shopping Cart";
    begin
        ShoppingCart.SetRange("Customer No.", CustomerNo);
        if ShoppingCart.FindLast() then
            exit(ShoppingCart.Position);

        exit(0);
    end;

    local procedure LogEvent(MessageText: Text)
    var
        ShoppingSessionEvent: Record "Shopping Session Event";
    begin
        ShoppingSessionEvent."Session ID" := SessionId();
        ShoppingSessionEvent."Event No." := GetLastEventNo() + 1;
        ShoppingSessionEvent.Message := CopyStr(MessageText, 1, MaxStrLen(ShoppingSessionEvent.Message));
        ShoppingSessionEvent.Insert();
    end;

    local procedure GetLastEventNo(): Integer
    var
        ShoppingSessionEvent: Record "Shopping Session Event";
    begin
        ShoppingSessionEvent.SetRange("Session ID", SessionId());
        if ShoppingSessionEvent.FindLast() then
            exit(ShoppingSessionEvent."Event No.");

        exit(0);
    end;
}