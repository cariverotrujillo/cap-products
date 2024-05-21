using {com.logali as logali} from '../db/schema';



// service CatalogeService {
//     entity Prodcuts        as projection on logali.materials.Products;
//     entity Suppliers       as projection on logali.sales.Suppliers;
//     entity UnitOfMeasures  as projection on logali.materials.UnitOfMeasures;
//     entity DimensionsUnits as projection on logali.materials.DimensionsUnits;
//     entity SalesData       as projection on logali.sales.SalesData;
//     entity Reviews   as projection on logali.materials.ProductReview;
//     entity Currencies as projection on logali.materials.Currencies;
//     entity Categories as projection on logali.materials.Categories;
//     entity Orders as projection on logali.sales.Orders;
//     entity OrderItems as projection on logali.sales.OrderItems;
// //entity Car as projection on logali.car;


// }


define service CatalogeService {

    entity Prodcuts           as
        select from logali.reports.Products {
            ID,
            name          as ProductName     @mandatory,
            Description                      @mandatory,
            ImageUrl,
            ReleaseDate,
            DiscontinuedDate,
            Price                            @mandatory,
            Height,
            width,
            Depth,
            Quantity                         @(
                mandatory,
                assert.range: [
                    0.00,
                    20.00
                ]
            ),
            Currency      as ToCurrency      @mandatory,
            Category      as ToCategory      @mandatory,
            Category.name as Category        @readonly,
            Supplier,
            UnitOfMeasure as ToUnitofMeasure @mandatory,
            DimensionUnit as ToDimensionUnit,
            SalesData,
            Reviews,
            Rating,
            StockAvailability,
            ToStockAvailibilty
        }

    entity Suppliers          as
        select from logali.sales.Suppliers {
            ID,
            name,
            Email,
            Phone,
            Fax,
            products as ToProduct

        }

    entity Reviews            as
        select from logali.materials.ProductReview {
            ID,
            Name,
            Rating,
            Comment,
            createdAt,
            Product as ToProduct
        }

    @readonly
    entity SalesData          as
        select from logali.sales.SalesData {
            ID,
            DeliveryDate,
            Revenue,
            Currency.ID               as Currencykey,
            DeliveryMonth.ID          as DeliveryMonthId,
            DeliveryMonth.Description as DeliveryMonthDesc,
            Product                   as ToProduct

        }

    @readonly
    entity StockAvailability  as
        select from logali.materials.StockAvailability {
            ID,
            Description,
            Product as ToProduct
        }

    @readonly
    entity VH_Categories      as
        select from logali.materials.Categories {
            ID   as Code,
            name as text
        }

    @readonly
    entity VH_Currencies      as
        select from logali.materials.Currencies {
            ID          as Code,
            Description as text
        }

    @readonly
    entity VH_UnitOfMeasures  as
        select from logali.materials.UnitOfMeasures {
            ID          as Code,
            Description as text
        }

    @readonly
    entity VH_DimensionsUnits as
        select
            ID          as Code,
            Description as text
        from logali.materials.DimensionsUnits;
}

define service MyService {

    entity SuppliersProducts  as
        select from logali.materials.Products[name = 'Bread']{
            *,
            name,
            Description,
            Supplier.Address
        }
        where
            Supplier.Address.PostalCode = 98074;

    entity SupliersTotalSales as
        select
            Supplier.Email,
            Category.name,
            SalesData.Currency.ID,
            SalesData.Currency.Description
        from logali.materials.Products;

    entity Entityinfix        as
        select Supplier[name = 'Exotic Liquids'].Phone from logali.materials.Products
        where
            Products.name = 'Bread';

    entity EntityJoin         as
        select Phone from logali.materials.Products
        left join logali.sales.Suppliers as sup
            on(
                sup.ID = Products.Supplier.ID
            )
        where
                sup.name      = 'Exotic Liquids'
            and Products.name = 'Bread'
}

define service reports {

    entity AverageRating as projection on logali.reports.AverageRating;

    entity EntityCasting as
        select
            cast(
                Price as      Integer
            )     as Price,
            Price as Price2 : Integer
        from logali.materials.Products;

    entity EntityExist as
    select from logali.materials.Products{
        name
    }
    where exists Supplier[name = 'Exotic Liquids' ]
    
}
