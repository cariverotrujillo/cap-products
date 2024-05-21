namespace com.training;

using {cuid, Country} from '@sap/cds/common';

// type EmailAddresses_01 : array of {
//     kind  : String;
//     email : String;
// }

// type EmailAddresses_02 : {
//     kind  : String;
//     email : String;
// }

// entity emails {
//     emails_01 :      EmailAddresses_01;
//     emails_02 : many EmailAddresses_02;
//     emails_03 : many {
//         kind  : String;
//         email : String;
//     }
// // }
// type gender : String enum {
//     male;
//     female;
// };

// entity order {
//     ClientGender : gender;
//     status       : Integer enum {
//         submitted = 1;
//         fulfilled = 2;
//         shipped   = 3;
//         cancel    = -1;
//     };
//     priority     : String @assert.range enum {
//         high;
//         medium;
//         low;
//     }
// }
// entity car{
//     key id: UUID;
//     name: String;
//     virtual discount_01: Decimal
//     @Core.Computed : false ;
//     virtual discount_02: Decimal;
// }

// entity ParamProducts(pName : String)     as
//     select from Products {
//         name,
//         Price,
//         Quantity
//     }
//     where
//         name = :pName;

// entity ProjParamProducts(pName : String) as projection on Products
//                                             where
//                                                 name = :pName;


entity course : cuid {
    // key ID      : UUID;
    student : Association to many studentcourse
                  on student.course = $self;
}

entity student : cuid {
    //  key ID     : UUID;
    course : Association to many studentcourse
                 on course.student = $self;
}

entity studentcourse : cuid {
    //   key ID      : UUID;
    student : Association to student;
    course  : Association to course;
}

entity orders {
    key clientemail : String;
        firstname   : String;
        lastname    : String;
        CreatedOn   : Date;
        reviewd     : Boolean;
        approved    : Boolean;
        country     : Country;
        status      : String(1);

}
