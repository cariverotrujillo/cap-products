
using { sapbackend as external } from './external/sapbackend.csn';

define service sapbackendexit {
    @cds.persistence :{
        table,
        skip: false
    }
@cds.autoexpose
// entity incidentes as select from external.IncidentsSet;
   entity incidentes as projection on external.IncidentsSet; 

}