using com.training as training from '../db/training';

define service Manageorders {
    type CancelOrderReturn {
        Status  : String enum {
            Succeded;
            Failed
        };
        message : String;
    }

    //  function GetClientTaxRate(clientemail : String) returns Decimal(4, 2);
    //  action   CancelOrder(clientemail : String)      returns CancelOrderReturn;
    entity orders as projection on training.orders
        actions {
            function GetClientTaxRate(clientemail : String) returns Decimal(4, 2);
            action   CancelOrder(clientemail : String)      returns CancelOrderReturn;
        }
}
