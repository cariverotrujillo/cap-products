const cds = require("@sap/cds");
const cors = require("cors");
const adapterproxy = require("@sap/cds-odata-v2-adapter-proxy");

cds.on("bootstrap", (app)=>{
    app.use(adapterproxy())
    app.use(cors())
    app.get("/alive", (_,res)=>{
        res.status(200).send("Server is alive")
    }) 
})

module.exports = cds.server;