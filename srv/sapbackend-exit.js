const cds = require("@sap/cds");

// module.exports = cds.service.impl(async function (){
//    const { incidentes } = this.entities;
//    const sapbackend = await cds.connect.to("sapbackend");
//    this.on("READ", incidentes, async (req) =>{
//     return await sapbackend.tx(req).send({
//          query : req.query
//      })
//     })
// })

module.exports = async (srv) => {
    const { incidentes } = srv.entities;
    const sapbackend = await cds.connect.to("sapbackend");

    srv.on(["READ"], incidentes, async (req) => {
//no entiendo que hace acá pero lo pongo igual, aunq no uso esta query:

let incidentquery = SELECT.from(req.query.SELECT.from).limit(
    req.query.SELECT.limit
)
if (req.query.SELECT.where) incidentquery.where(req.query.SELECT.where)
if (req.query.SELECT.orderBy) incidentquery.orderBy(req.query.SELECT.orderBy)


        let incident = await sapbackend.tx(req).send({
            // aca usa el incidentquery pero no entiendo qué hace eso, asiq deje la query original
            query: req.query
        })

        let incidents = [];
        if (Array.isArray(incident)) {
            incidents = incident
        }
        else {
            incidents[0] = incident
        }
        return incidents;
    })

}