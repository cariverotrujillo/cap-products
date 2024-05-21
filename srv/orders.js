const cds = require("@sap/cds");
const res = require("express/lib/response");
const { orders } = cds.entities("com.training");

module.exports = (srv) => {
  /*  srv.before("*", (req)=>{
        console.log(`Method: ${req.method}`)
        console.log(`Target: ${req.target}`)
    })
  /*
    /*********READ */
    srv.on("READ", "orders", async (req) => {

        if (req.data.clientemail !== undefined) {
            return await SELECT.from`com.training.orders`.where`clientemail = ${req.data.clientemail}`

        }

        return await SELECT.from(orders);
    });
    srv.after("READ", "orders", (data) => {
        return data.map((order) => { order.reviewd = true })
    });
    /*********CREATE */
    srv.on("CREATE", "orders", async (req) => {
        let returndata = await cds.transaction(req).run(
            INSERT.into(orders).entries({
                clientemail: req.data.clientemail,
                firstname: req.data.firstname,
                lastname: req.data.lastname,
                CreatedOn: req.data.CreatedOn,
                reviewd: req.data.reviewd,
                approved: req.data.approved
            })
        ).then((resolve, reject) => {
            console.log("Resolve", resolve)
            console.log("Reject", reject)
            if (resolve !== undefined) {
                return req.data;
            } else {
                req.err(409, "Registro no insertado");
            }
        }).catch((err) => {
            console.log(err)
            req.error(err.code, err.message)
        })
        console.log("before end", returndata)
        return returndata;
    })
    srv.before("CREATE", "orders", (req) => {
        req.data.CreatedOn = new Date().toISOString().slice(0, 10);
    })

    /*********UPDATE */
    srv.on("UPDATE", "orders", async (req) => {
        let returndata = await cds.transaction(req).run[
            UPDATE(orders, req.data.clientemail).set({
                firstname: req.data.firstname,
                lastname: req.data.lastname,
            })
        ].then((resolve, reject) => {
            console.log("Resolve", resolve)
            console.log("Reject", reject)
            if (resolve[0] == 0) {
                req.err(409, "Registro no insertado");
            }
        }).catch((err) => {
            console.log(err)
            req.error(err.code, err.message)
        })
        console.log("before end", returndata);
        return returndata;
    })
    /*********DELETE */
    srv.on("DELETE", "orders", async (req) => {
        let returndata = await cds.transaction(req).run[
            DELETE.from(orders).where({
                clientemail: req.data.clientemail
            })
        ].then((resolve, reject) => {
            console.log("Resolve", resolve)
            console.log("Reject", reject)
            if (resolve !== 1) {
                req.err(409, "Registro no encontrado");
            }
        }).catch((err) => {
            console.log(err)
            req.error(err.code, err.message)
        })
        console.log("before end", returndata);
        return await returndata;
    })
    /*********FUNCTION */

    srv.on("GetClientTaxRate", async (req) => {
        const { clientemail } = req.data
        const db = srv.transaction(req)

        const results = await db.read(orders, ["country_code"]).where({ clientemail: clientemail })

        console.log(results[0])
        switch (results[0].country_code) {
            case 'ES':
                return 21.5;
            case 'UK':
                return 24.6;
            case 'AR':
                return 21.00;
        }
    })
    /*********ACTION */
    srv.on("CancelOrder", async (req) => {

        const { clientemail } = req.data
        const db = srv.transaction(req)

        const resultsRead = await db.read(orders, ["firstname", "lastname", "approved"]).where({ clientemail: clientemail })

        let ReturnOrder = {
            status: "",
            message: ""
        }

        if (resultsRead[0].approved == false) {
            const resultUpdate = db.update(orders).set({ status: "C" }).where({ clientemail: clientemail })
            ReturnOrder.status = "Succeded"
            ReturnOrder.message = `The order placed by ${resultsRead[0].firstname} ${resultsRead[0].lastname} was cancelled`
        } else {
            ReturnOrder.status = "Failed"
            ReturnOrder.message = `The order placed by ${resultsRead[0].firstname} ${resultsRead[0].lastname} was NOT cancelled because it was already approved`
        }
        return ReturnOrder;
    })
};  